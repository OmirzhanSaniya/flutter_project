import 'package:flutter/material.dart';

/// Enhanced enum: every value carries a label and an icon.
enum EventCategory {
  music('Music', Icons.music_note),
  sport('Sport', Icons.sports_soccer),
  tech('Tech', Icons.computer),
  art('Art', Icons.palette),
  career('Career', Icons.work);

  const EventCategory(this.label, this.icon);

  final String label;
  final IconData icon;

  /// R2: exhaustive switch expression, returns a colorScheme role.
  Color color(ColorScheme scheme) => switch (this) {
        EventCategory.music => scheme.primary,
        EventCategory.sport => scheme.secondary,
        EventCategory.tech => scheme.tertiary,
        EventCategory.art => scheme.error,
        EventCategory.career => scheme.outline,
      };
}

/// R1: immutable model - final fields, const constructor, copyWith.
@immutable
class Event {
  /// [names] must be an unmodifiable list: seed uses `const [...]`,
  /// [copyWith] wraps with List.unmodifiable.
  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.when,
    required this.place,
    required this.limit,
    this.names = const [],
    this.online = false,
    this.description,
    this.favourite = false,
  });

  /// R3: empty instance for the "new event" form.
  factory Event.empty() => Event(
        id: '',
        title: '',
        category: EventCategory.tech,
        when: DateTime.now().add(const Duration(days: 1)),
        place: '',
        limit: 50,
      );

  final String id;
  final String title;
  final EventCategory category;
  final DateTime when;

  /// Place, or a link when [online] is true.
  final String place;
  final int limit;
  final List<String> names;
  final bool online;

  /// R6: optional text.
  final String? description;
  final bool favourite;

  // R4: derived values are getters, never stored.
  int get count => names.length;
  int get free => limit - count;
  bool get isFull => count >= limit;
  bool get isPast => when.isBefore(DateTime.now());
  bool contains(String name) => names.contains(name);

  /// R5: record getter.
  ({int taken, int free}) get places => (taken: count, free: free);

  Event copyWith({
    String? id,
    String? title,
    EventCategory? category,
    DateTime? when,
    String? place,
    int? limit,
    List<String>? names,
    bool? online,
    String? description,
    bool clearDescription = false,
    bool? favourite,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      when: when ?? this.when,
      place: place ?? this.place,
      limit: limit ?? this.limit,
      names: names == null ? this.names : List.unmodifiable(names),
      online: online ?? this.online,
      description: clearDescription ? null : (description ?? this.description),
      favourite: favourite ?? this.favourite,
    );
  }
}

/// R1 + R3: second model.
@immutable
class Profile {
  const Profile({required this.name, required this.group});

  const Profile.empty()
      : name = '',
        group = '';

  final String name;
  final String group;

  Profile copyWith({String? name, String? group}) =>
      Profile(name: name ?? this.name, group: group ?? this.group);
}
