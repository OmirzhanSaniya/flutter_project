import 'data.dart';
import 'models.dart';
import 'catalogue.dart';
import 'shelf_state.dart';

void main() {
  final library = Library()..open();

  for (final raw in rawBooks) {
    library.add(Book.fromJson(raw));
  }

  print('=== Library opened at ${library.openedAt} ===\n');

  // --- Level 4 queries -------------------------------------------------
  print('All titles: ${library.allTitles.toList()}');
  print('Books after 2010: ${library.booksAfter2010.map((b) => b.title).toList()}');
  print('Average pages: ${library.averagePages.toStringAsFixed(1)}');
  print('Books per author: ${library.bookCountByAuthor}');
  print('Distinct authors: ${library.authorNames}');
  print('Genres present: ${library.genresPresent}');
  print('');

  // --- Display list / cached report ------------------------------------
  print(library.report());
  print('');

  // --- Level 3 null-safety helpers --------------------------------------
  print('Country of "Refactoring": ${library.countryOf('Refactoring')}');
  print('Country of "Design Patterns": ${library.countryOf('Design Patterns')}');
  print('Country of "Nonexistent": ${library.countryOf('Nonexistent')}');
  print('');

  // --- Level 2 hierarchy 
  final firstBook = library.findByTitle('Clean Code');
  if (firstBook != null) {
    print(firstBook.describe());
    print(firstBook.borrowLabel());
  }
  const magazine = Magazine(title: 'Dart Weekly', year: 2024, issue: 12);
  print(magazine.describe());
  const ghost = Ghost(title: 'Lost Volume', year: 1950);
  print('${ghost.describe()} — isOld: ${ghost.isOld}');
  print('');

  // --- Level 5:Dart3, records + sealed classes / pattern matching
  final books = library.items.whereType<Book>().toList();
  final stats = statsOf(books);
  print('Stats record: count=${stats.count}, avgPages=${stats.avgPages.toStringAsFixed(1)}');

  final states = <ShelfState>[
    const Empty(),
    Ready(books),
    const Broken('shelf collapsed under its own weight'),
  ];
  for (final state in states) {
    print(describeShelf(state));
  }
}
