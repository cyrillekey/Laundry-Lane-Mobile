import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:laundrylane/models/chat_session.dart';
import 'package:laundrylane/providers/token_provider.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/chat/chat_window.dart';

class ChatSupportPage extends ConsumerWidget {
  const ChatSupportPage({super.key});
  static const routeName = '/support-chat';
  @override
  Widget build(BuildContext context, ref) {
    final chatState = ref.watch(chatSessionProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text("New Chat", style: GoogleFonts.almarai()),
        icon: Icon(TablerIcons.message),
        onPressed: () {},
      ),
      appBar: AppBar(title: Text("Chats"), centerTitle: true),
      body: RefreshIndicator.adaptive(
        onRefresh: () async => ref.invalidate(chatSessionProvider),
        child: chatState.when(
          data: (chats) {
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, index) => ChatItem(session: chats[index]),
              separatorBuilder: (_, index) => SizedBox(height: 16),
              itemCount: chats.length,
            );
          },
          error: (error, stackTrace) {
            return ErrorWidget(error);
          },
          loading:
              () => ListView.separated(
                itemBuilder: (_, index) => _ChatLoadingShimmer(),
                separatorBuilder: (_, index) => Divider(),
                itemCount: 12,
              ),
        ),
      ),
    );
  }
}

class _ChatLoadingShimmer extends StatelessWidget {
  const _ChatLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ChatItem extends ConsumerWidget {
  const ChatItem({super.key, required this.session});
  final ChatSession session;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userProvider).value;
    final recipient = session.members!.firstWhere((e) => e.id != user?.id);
    bool isLastSender = session.lastMessage?.senderId == user?.id;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap:
          () => Navigator.pushNamed(
            context,
            ChatWindow.routeName,
            arguments: session,
          ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            CachedNetworkImage(
              errorWidget:
                  (context, _, _) => CircleAvatar(
                    radius: 28,
                    child: Image.asset("assets/icons/user.png"),
                  ),
              // TODO: implmenet user avatar in chat
              imageUrl: user?.avatar ?? "",
              imageBuilder:
                  (context, imageProvider) =>
                      CircleAvatar(radius: 28, backgroundImage: imageProvider),
            ),
            SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipient.user?.name ?? "N/A",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    session.lastMessage?.message ?? "",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Jiffy.parseFromDateTime(
                    session.lastMessage!.createdat!,
                  ).fromNow(),
                ),
                SizedBox(
                  child:
                      isLastSender
                          ? Icon(
                            session.lastMessage!.read == true
                                ? TablerIcons.check
                                : TablerIcons.checks,
                          )
                          : session.lastMessage?.read == true
                          ? SizedBox(height: 24, width: 24)
                          : Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              session.unreadCount.toString(),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
