import 'package:flutter/material.dart';

import 'models/book.dart';

/// What the user decided on the detail screen. The detail never touches the
/// list: it only answers, and the list does the work.
enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});

  final Book book;

  Future<void> _confirmDelete(BuildContext context) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Delete '${book.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    // Only on a clear "yes", and only if this screen is still alive.
    if (sure != true || !context.mounted) return;
    Navigator.of(context).pop(BookAction.delete);
  }

  @override
  Widget build(BuildContext context) {
    // The back arrow is drawn by AppBar itself: nothing is written for it.
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(book.title),
            subtitle: const Text('Title'),
          ),
          ListTile(
            title: Text(book.author),
            subtitle: const Text('Author'),
          ),
          ListTile(
            title: Text('${book.pages}'),
            subtitle: const Text('Pages'),
          ),
          ListTile(
            title: Text(book.year == null ? 'Year unknown' : '${book.year}'),
            subtitle: const Text('Year'),
          ),
          ListTile(
            title: Text(book.read ? 'Read' : 'Unread'),
            subtitle: const Text('Status'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(BookAction.toggleRead),
            child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _confirmDelete(context),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
