import 'package:flutter/material.dart';

import 'routes.dart';
import 'students.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nothing is below this screen on the stack, so AppBar draws no
      // back arrow by itself.
      appBar: AppBar(title: const Text('Students')),
      //appBar: AppBar(
      //leading: const BackButton(),
      //title: const Text('Students'),
      //),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final s = students[index];
          return ListTile(
            leading: CircleAvatar(child: Text(s.name[0])),
            title: Text(s.name),
            subtitle: Text(s.group),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pushNamed(
              Routes.student,
              //'/studnet',
              //Routes.studnet,
              arguments: s,
            ),
          );
        },
      ),
    );
  }
}
