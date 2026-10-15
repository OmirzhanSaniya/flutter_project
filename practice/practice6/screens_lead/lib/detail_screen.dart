import 'package:flutter/material.dart';

import 'routes.dart';
import 'students.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.student});

  final Student student;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // The student on screen. It starts as the one we were given and is
  // replaced (never mutated) when the edit screen answers.
  late Student _student = widget.student;

  Future<void> _edit() async {
    // 1. await: the edit screen is on top; we wait underneath.
    final name = await Navigator.of(context).pushNamed<String>(
      Routes.edit,
      arguments: _student,
    );
    // 2. null = the user backed out; !mounted = we were removed meanwhile.
    if (name == null || !mounted) return;
    // 3. only the change goes inside setState.
    setState(() => _student = _student.copyWith(name: name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_student.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: _edit,
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.school),
            title: Text(_student.group),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(_student.email),
          ),
        ],
      ),
    );
  }
}
