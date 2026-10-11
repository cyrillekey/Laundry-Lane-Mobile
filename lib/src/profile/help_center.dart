import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:laundrylane/models/support_models.dart';
import 'package:laundrylane/src/apis/api_service.dart';
import 'package:laundrylane/src/chat/chat_list.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});
  static const routeName = '/help-center';

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text(
            "Chat Support",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          icon: Icon(TablerIcons.message),
          onPressed:
              () => Navigator.of(context).pushNamed(ChatSupportPage.routeName),
        ),
        appBar: AppBar(title: Text("Support Center"), centerTitle: true),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(TablerIcons.search, size: 28),
                    hintText: "Search for help",
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: 16,
                    ),
                    constraints: BoxConstraints.tightFor(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              TabBar.secondary(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                tabs: [Tab(text: "FAQ"), Tab(text: "Contact Us")],
              ),
              Expanded(child: TabBarView(children: [FaqTab(), ContactsTab()])),
            ],
          ),
        ),
      ),
    );
  }
}

class FaqTab extends ConsumerWidget {
  const FaqTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final faqState = ref.watch(faqsState);
    return faqState.when(
      data: (faqs) {
        return ListView.separated(
          padding: const EdgeInsets.only(top: 24),
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: faqs.length,
          itemBuilder: (context, index) => FaqItem(faq: faqs[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}

class ContactsTab extends ConsumerWidget {
  const ContactsTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final watchContacts = ref.watch(supportContactsState);
    return watchContacts.when(
      data: (contacts) {
        return ListView.separated(
          padding: const EdgeInsets.only(top: 24),
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: contacts.length,
          itemBuilder:
              (context, index) => ContactItem(
                icon: getIcon(contacts[index].type),
                title: contacts[index].name,
                subtitle: contacts[index].value,
              ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }
}

class ContactItem extends StatelessWidget {
  const ContactItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: 1.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      leading: Icon(
        icon,
        size: 28,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          width: 1.5,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),

      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 12),

              Container(
                alignment: Alignment.center,

                child: Icon(TablerIcons.circle_filled, size: 6),
              ),
              SizedBox(width: 12),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18),
      ],
    );
  }
}

IconData getIcon(String icon) {
  switch (icon) {
    case "contact":
      return CupertinoIcons.phone;
    case "email":
      return TablerIcons.mail;
    case "twitter":
      return TablerIcons.brand_twitter_filled;
    case 'facebook':
      return TablerIcons.brand_facebook_filled;
    case 'instagram':
      return TablerIcons.brand_instagram;
    case 'whatsapp':
      return TablerIcons.brand_whatsapp;
    case 'telegram':
      return TablerIcons.brand_telegram;
    case 'website':
      return TablerIcons.world;
    default:
      return TablerIcons.phone;
  }
}

class FaqItem extends StatelessWidget {
  const FaqItem({super.key, required this.faq});
  final FaqModel faq;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(faq.question),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(width: 1.5, color: Theme.of(context).primaryColor),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(width: 1.5, color: Theme.of(context).primaryColor),
      ),
      childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [Text(faq.answer)],
    );
  }
}
