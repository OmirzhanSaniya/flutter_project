import 'package:flutter/material.dart';

import 'contact_card.dart';
import 'contacts.dart';

/// The contacts screen: a header above a scrollable list of twenty
/// [ContactCard]s, separated by dividers.
class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${contacts.length} contacts',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, index) =>
                ContactCard(contact: contacts[index]),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ],
    );
  }
}
