import 'package:flutter/material.dart';

/// Level 5: shows the result of the sign-up. It does not know what screen it
/// is on: it asks only about its own box (LayoutBuilder, not MediaQuery).
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.name,
    required this.email,
    required this.group,
    required this.birth,
  });

  final String name;
  final String email;
  final String group;
  final String birth;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      ListTile(
        leading: const Icon(Icons.person),
        title: Text(name),
        subtitle: const Text('Name'),
      ),
      ListTile(
        leading: const Icon(Icons.mail),
        title: Text(email),
        subtitle: const Text('Email'),
      ),
      ListTile(
        leading: const Icon(Icons.school),
        title: Text(group),
        subtitle: const Text('Group'),
      ),
      ListTile(
        leading: const Icon(Icons.cake),
        title: Text(birth),
        subtitle: const Text('Date of birth'),
      ),
    ];

    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            // Wide box: two columns. The grid sits inside a scroll view, so
            // it must size itself to its children (shrinkWrap) and must not
            // scroll on its own.
            return GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: tiles,
            );
          }
          // Narrow box: one column.
          return Column(mainAxisSize: MainAxisSize.min, children: tiles);
        },
      ),
    );
  }
}
