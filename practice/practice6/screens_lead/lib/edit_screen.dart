import 'package:flutter/material.dart';

import 'students.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.student});

  final Student student;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // The draft. Starts as the current name; onChanged keeps it up to date.
  late String _name = widget.student.name;

  // Computed, not stored: the form is dirty when the draft differs from
  // what came in.
  bool get _dirty => _name != widget.student.name;

  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    // didPop true: the pop already happened, nothing to do.
    if (didPop) return;

    // didPop false: the form was dirty and the pop was blocked. Ask.
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    // Pop for real only on a clear "yes", and only if we are still here.
    if (discard == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit name')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'New name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => _name = v),
              ),
              const SizedBox(height: 16),
              FilledButton(
                // Our own pop(value): not the system back button, so
                // PopScope has no say in it.
                onPressed: () => Navigator.of(context).pop(_name),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
