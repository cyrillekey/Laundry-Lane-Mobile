import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:laundrylane/models/chat_message.dart';
import 'package:laundrylane/models/chat_session.dart';
import 'package:laundrylane/providers/token_provider.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:laundrylane/utils/extenstions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWindow extends StatefulHookConsumerWidget {
  const ChatWindow({super.key});
  static const routeName = '/chat-window';

  @override
  ConsumerState<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends ConsumerState<ChatWindow> {
  late WebSocketChannel channel;
  late ChatSession session;
  late ChatMember recipient;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    session = ModalRoute.of(context)!.settings.arguments as ChatSession;
    final token = ref.watch(tokenProvider).value;
    channel = WebSocketChannel.connect(
      Uri.parse("$websocketUrl/chat/websocket/${session.id}?authToken=$token"),
    );
    recipient = session.members!.firstWhere(
      (e) => e.id != ref.watch(userProvider).value?.id,
    );
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatsProvider(session.id!));
    List<ChatMessage> messages = chatState.value ?? [];
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        title: Row(
          children: [
            CachedNetworkImage(
              imageUrl: recipient.user?.avatar ?? "",
              imageBuilder:
                  (context, imageProvider) => CircleAvatar(
                    minRadius: 22,
                    foregroundImage: imageProvider,
                  ),
              errorWidget:
                  (context, url, error) => CircleAvatar(
                    minRadius: 22,
                    child: Image.asset("assets/icons/user.png", height: 44),
                  ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipient.user?.name ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  // TODO: replace with recipient role
                  "Store Manager",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: MessageInput(
        channel: channel,
        listScrollController: _scrollController,
        onSend: (message, attachments) {},
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, spanshot) {
          if (spanshot.hasData) {
            Map<String, dynamic> message = (jsonDecode(
              spanshot.data.toString(),
            ));
            if (message.isNotEmpty) {
              final newMessage = ChatMessage.fromJson((message));
              // ADD NEW MESSAGE IF NOT EXIST
              messages.addIfNotExist(newMessage);

              // messages.add(newMessage);
            }
          }
          return GroupedListView<ChatMessage, String>(
            elements: messages,
            useStickyGroupSeparators: true,
            groupBy:
                (transaction) => Jiffy.parseFromDateTime(
                  transaction.createdat!,
                ).toLocal().format(pattern: "d MMMM y"),

            groupSeparatorBuilder:
                (groupByValue) => Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  height: 50,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      groupByValue,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
            physics: const BouncingScrollPhysics(),
            groupComparator:
                (a, b) => DateFormat(
                  "d MMMM y",
                ).parse(b).compareTo(DateFormat("d MMMM y").parse(a)),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ).copyWith(bottom: MediaQuery.of(context).size.height * .11),
            separator: const Divider(height: 14, color: Colors.transparent),
            itemComparator: (a, b) => (b.createdat)!.compareTo((a.createdat!)),
            itemBuilder:
                (context, item) => ChatItem(
                  message: item,
                  onDelete: () {
                    // TODO: impelement message delete
                  },
                ),
            reverse: true,
            controller: _scrollController,
          );
        },
      ),
    );
  }
}

class MessageInput extends StatefulHookConsumerWidget {
  const MessageInput({
    super.key,
    required this.listScrollController,
    required this.onSend,
    required this.channel,
  });

  final ScrollController listScrollController;
  final WebSocketChannel channel;
  final void Function(String? message, List<String>? files) onSend;

  @override
  ConsumerState<MessageInput> createState() => MessageInputState();
}

class MessageInputState extends ConsumerState<MessageInput> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ).copyWith(top: 16, bottom: 24),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            // UploadButton(formKey: widget.formKey),
            const SizedBox(width: 12),
            Expanded(
              child: FormBuilderTextField(
                validator: FormBuilderValidators.required(),
                name: "message",
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ).copyWith(left: 16),
                  filled: true,

                  hintText: "Type a message",
                  enabled: true,
                  suffixIcon: Container(
                    height: 40,
                    width: 10,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        if (formKey.currentState?.saveAndValidate() ?? false) {
                          String message =
                              formKey.currentState!.value["message"];
                          widget.channel.sink.add(
                            jsonEncode({"message": message}),
                          );
                          formKey.currentState?.reset();
                        }
                      },
                      child: const Icon(TablerIcons.send),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(216, 220, 236, 1),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(216, 220, 236, 1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(36),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(216, 220, 236, 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatItem extends ConsumerWidget {
  final ChatMessage message;

  final VoidCallback onDelete;
  const ChatItem({super.key, required this.message, required this.onDelete});

  @override
  Widget build(BuildContext context, ref) {
    final userID = ref.watch(userProvider).value?.id;
    String time = Jiffy.parseFromDateTime(
      message.createdat!,
    ).toLocal().format(pattern: "HH:mm a");
    bool myMessage = message.senderId == userID ? true : false;
    return Container(
      margin: const EdgeInsets.only(top: 8),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: 10,
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color:
                  myMessage
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.tertiaryFixedDim,
              borderRadius: BorderRadius.only(
                topLeft:
                    myMessage
                        ? const Radius.circular(10)
                        : const Radius.circular(0),
                topRight:
                    !myMessage
                        ? const Radius.circular(10)
                        : const Radius.circular(0),
                bottomLeft: const Radius.circular(10),
                bottomRight: const Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.attachments != null &&
                    message.attachments!.isNotEmpty) ...[
                  // dynamicWidget(message.attachments!, "", context),
                  const SizedBox(height: 12),
                ],
                Text(
                  "${message.message?.trim()}",
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        myMessage
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onTertiaryFixed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment:
                myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(time),
              const SizedBox(width: 10),
              Visibility(
                visible: myMessage,
                child: Icon(
                  message.read == true ? TablerIcons.checks : TablerIcons.check,
                  size: 20,
                  color:
                      message.read == true
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
