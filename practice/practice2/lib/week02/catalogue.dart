import 'models.dart';
// Level 3: Null Safety

class Library {
  final List<LibraryItem> items = [];

  void add(LibraryItem item) => items.add(item);

  /// Returns null when there is no book with this title — never throws.
  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) return item;
    }
    return null;
  }

  /// The author's country for a title, or 'unknown'. A single expression
  /// combining ?. (safe navigation past a possibly-missing book) and
  /// ?? (fallback past a possibly-missing country).
  String countryOf(String title) => findByTitle(title)?.author.country ?? 'unknown';

  /// Set once, by [open] — not available before the library is opened.
  late final DateTime openedAt;

  void open() {
    openedAt = DateTime.now();
  }

  String? _cachedReport;

  /// Builds the report once and reuses it on every later call.
  String report() => _cachedReport ??= _buildReport();

  String _buildReport() => displayList.join('\n');

  // Level 4: Collections — one expression each, no for loops.

  /// Every title in the catalogue.
  Iterable<String> get allTitles => items.map((item) => item.title);

  /// Books published after 2010.
  List<Book> get booksAfter2010 =>
      items.whereType<Book>().where((book) => book.year > 2010).toList();

  /// Average page count across all books.
  /// fold is used instead of reduce because reduce throws on an empty
  /// iterable (it needs at least one element to seed the accumulator),
  /// while fold takes an explicit start value and is safe on empty input.
  double get averagePages {
    final books = items.whereType<Book>().toList();
    return books.isEmpty
        ? 0
        : books.fold<int>(0, (sum, book) => sum + book.pages) / books.length;
  }

  /// Author name -> number of books by that author.
  Map<String, int> get bookCountByAuthor => items.whereType<Book>().fold<Map<String, int>>(
        <String, int>{},
        (map, book) => map..update(book.author.name, (n) => n + 1, ifAbsent: () => 1),
      );

  /// Distinct author names.
  Set<String> get authorNames => items.whereType<Book>().map((b) => b.author.name).toSet();

  /// Every genre present in the library.
  Set<Genre> get genresPresent => items.whereType<Book>().map((b) => b.genre).toSet();

  /// The full display list, built as a single list literal using
  /// collection-for and collection-if / spread.
  List<String> get displayList => [
        'CATALOGUE',
        for (final book in items.whereType<Book>()) '${book.title} (${book.year})',
        ...authorNames,
        if (items.whereType<Book>().any((book) => book.pages == 0)) '(incomplete data)',
      ];
}
