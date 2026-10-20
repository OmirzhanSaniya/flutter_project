import 'package:flutter/material.dart';

import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // A copy of the list, so the seed list itself is never touched.
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  // Derived, not stored: a switch expression over the enum.
  List<Book> get _visible => switch (_filter) {
        Filter.all => _books,
        Filter.unread => unread(_books),
        Filter.read => _books.where((b) => b.read).toList(),
      };

  String _label(Filter f) => switch (f) {
        Filter.all => 'All',
        Filter.unread => 'Unread',
        Filter.read => 'Read',
      };

  // Level 4: open the detail and wait for its answer.
  Future<void> _open(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (_) => DetailScreen(book: book)),
    );
    if (!mounted) return;
    switch (action) {
      case null: // backed out: nothing changes
        break;
      case BookAction.toggleRead:
        setState(() => book.read = !book.read);
      case BookAction.delete:
        setState(() => _books.remove(book));
    }
  }

  // Level 5: open the form and wait for a new Book.
  Future<void> _add() async {
    final book = await Navigator.of(context).push<Book>(
      MaterialPageRoute(builder: (_) => const AddBookScreen()),
    );
    if (book == null || !mounted) return;
    setState(() => _books.add(book));
  }

  Widget _stat(String number, String label) {
    final text = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Text(number, style: text.headlineSmall),
          Text(label, style: text.bodySmall),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${visible.length})')),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        tooltip: 'Add a book',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Header: three equal columns. The numbers come from Level 1.
          Card(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _stat('${_books.length}', 'Books'),
                  _stat('${totalPages(_books)}', 'Pages'),
                  _stat('${unread(_books).length}', 'Unread'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                for (final f in Filter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_label(f)),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final book = visible[index];
                return BookTile(
                  book: book,
                  onToggle: () => setState(() => book.read = !book.read),
                  onTap: () => _open(book),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
