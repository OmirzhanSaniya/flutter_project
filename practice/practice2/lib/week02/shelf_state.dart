import 'models.dart';

// Level 5: Dart 3 — sealed classes, patterns, records

/// A shelf can only ever be in one of exactly three states. `sealed` lets
/// the compiler check that every switch below is exhaustive: add a fourth
/// subtype and every switch that lacks a `default` fails to compile until
/// it is handled.
sealed class ShelfState {
  const ShelfState();
}

class Empty extends ShelfState {
  const Empty();
}

class Ready extends ShelfState {
  final List<Book> books;
  const Ready(this.books);
}

class Broken extends ShelfState {
  final String message;
  const Broken(this.message);
}

/// A switch *expression* with no default — exhaustiveness is guaranteed by
/// the sealed hierarchy above, using object patterns to pull field values
/// straight out of each variant.
String describeShelf(ShelfState state) => switch (state) {
      Empty() => 'The shelf is empty.',
      Ready(books: final books) when books.isEmpty => 'The shelf is empty.',
      Ready(books: final books) => 'The shelf holds ${books.length} book(s).',
      Broken(message: final message) => 'The shelf is broken: $message',
    };

/// Returns both numbers together as a record — not a class, not a List.
({int count, double avgPages}) statsOf(List<Book> books) {
  if (books.isEmpty) return (count: 0, avgPages: 0.0);
  final totalPages = books.fold<int>(0, (sum, book) => sum + book.pages);
  return (count: books.length, avgPages: totalPages / books.length);
}
