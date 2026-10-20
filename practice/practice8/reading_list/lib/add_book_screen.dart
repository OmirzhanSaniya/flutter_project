import 'package:flutter/material.dart';

import 'models/book.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  // Created once, as fields of State, disposed in dispose().
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _pages = TextEditingController();
  final _year = TextEditingController();

  @override
  void dispose() {
    for (final c in [_title, _author, _pages, _year]) {
      c.dispose();
    }
    super.dispose();
  }

  void _unfocus(PointerDownEvent _) =>
      FocusManager.instance.primaryFocus?.unfocus();

  // Validators: null = fine, String = show this under the field.
  String? _validateTitle(String? v) =>
      (v ?? '').trim().length < 2 ? 'Title is too short' : null;

  String? _validateAuthor(String? v) =>
      (v ?? '').trim().isEmpty ? 'Author is required' : null;

  String? _validatePages(String? v) {
    final n = int.tryParse(v ?? '');
    if (n == null || n <= 0) return 'A whole number above 0';
    return null;
  }

  String? _validateYear(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null; // an empty year is fine
    final n = int.tryParse(s);
    if (n == null || n < 1450 || n > DateTime.now().year) {
      return 'A year from 1450 to ${DateTime.now().year}';
    }
    return null;
  }

  void _save() {
    // The one bang allowed in this project: the Form is built by now.
    if (!_formKey.currentState!.validate()) return;
    final book = Book(
      title: _title.text.trim(),
      author: _author.text.trim(),
      // Safe: the validator proved it is a number.
      pages: int.parse(_pages.text),
      // tryParse('') is null, which is exactly what an empty year means.
      year: int.tryParse(_year.text.trim()),
    );
    Navigator.of(context).pop(book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a book')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onTapOutside: _unfocus,
                validator: _validateTitle,
              ),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(labelText: 'Author'),
                textInputAction: TextInputAction.next,
                onTapOutside: _unfocus,
                validator: _validateAuthor,
              ),
              TextFormField(
                controller: _pages,
                decoration: const InputDecoration(labelText: 'Pages'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTapOutside: _unfocus,
                validator: _validatePages,
              ),
              TextFormField(
                controller: _year,
                decoration: const InputDecoration(
                  labelText: 'Year (optional)',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
                onTapOutside: _unfocus,
                validator: _validateYear,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
