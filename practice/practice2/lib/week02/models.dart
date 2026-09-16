// Level 1: Classes and Constructors

/// Country is optional because the data is incomplete for some entries.
class Author {
  final String name;
  final String? country;

  const Author({required this.name, this.country});

  @override
  String toString() => country == null ? name : '$name ($country)';
}

/// The genre of a book, each variant carrying a human-readable [label].
enum Genre {
  craft('Craft'),
  theory('Theory'),
  unknown('Unknown');

  final String label;

  const Genre(this.label);

  /// Anything that isn't exactly 'craft' or 'theory' — including null becomes [Genre.unknown]. This is the only place raw strings are turned into a real Genre.
  static Genre fromString(String? raw) {
    switch (raw) {
      case 'craft':
        return Genre.craft;
      case 'theory':
        return Genre.theory;
      default:
        return Genre.unknown;
    }
  }
}

// Level 2: Hierarchy
/// Anything that can live on a library shelf.
abstract class LibraryItem {
  final String title;
  final int year;

  const LibraryItem({required this.title, required this.year});

  String describe();

  /// "Old" just means published more than 20 years ago.
  bool get isOld => DateTime.now().year - year > 20;
}

/// Lets an item be borrowed. Mixed into [Book] only — magazines in this catalogue are reference-only and cannot be borrowed.
mixin Borrowable on LibraryItem {
  String borrowLabel() => 'Borrow "$title"';
}

class Book extends LibraryItem with Borrowable {
  final int pages;
  final Author author;
  final Genre genre;
  final String? description;

  const Book({
    required super.title,
    required super.year,
    required this.pages,
    required this.author,
    required this.genre,
    this.description,
  });

  /// Builds a [Book] from a raw JSON-like map, surviving missing keys.
  /// Missing 'pages' defaults to 0, missing 'genre'/'country' become
  /// Genre.unknown / null respectively — the defaults live here, once,
  /// instead of being re-checked by every caller.
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] as String? ?? 'Untitled',
      year: json['year'] as int? ?? 0,
      pages: json['pages'] as int? ?? 0,
      author: Author(
        name: json['author'] as String? ?? 'Unknown',
        country: json['country'] as String?,
      ),
      genre: Genre.fromString(json['genre'] as String?),
      description: json['description'] as String?,
    );
  }

  bool get isLong => pages > 400;

  Book copyWith({
    String? title,
    int? year,
    int? pages,
    Author? author,
    Genre? genre,
    String? description,
  }) {
    return Book(
      title: title ?? this.title,
      year: year ?? this.year,
      pages: pages ?? this.pages,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      description: description ?? this.description,
    );
  }

  @override
  String describe() => '$title by $author ($year, ${pages}p, ${genre.label})';

  @override
  String toString() =>
      'Book(title: $title, year: $year, pages: $pages, author: $author, '
      'genre: ${genre.label})';
}

class Magazine extends LibraryItem {
  final int issue;

  const Magazine({required super.title, required super.year, required this.issue});

  @override
  String describe() => '$title, issue #$issue ($year)';
}

/// A "hand-built" library item: implements the [LibraryItem] contract
/// without extending it, so nothing is inherited — every member,
/// including the fields, has to be written out here.
class Ghost implements LibraryItem {
  @override
  final String title;
  @override
  final int year;

  const Ghost({required this.title, required this.year});

  @override
  String describe() => '$title ($year) — a ghost entry, details lost';

  @override
  bool get isOld => DateTime.now().year - year > 20;
}
