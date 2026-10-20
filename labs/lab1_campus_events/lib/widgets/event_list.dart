import 'package:flutter/material.dart';

import '../models/event.dart';
import 'event_card.dart';

/// R20: list on phones, grid with cells of at most 360 px from 600 px width.
/// Uses LayoutBuilder (the width the parent gives), not MediaQuery.
class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.events,
    required this.empty,
    required this.onOpen,
    required this.onFavourite,
  });

  final List<Event> events;

  /// Shown instead of the list when [events] is empty.
  final Widget empty;
  final void Function(Event event) onOpen;
  final void Function(Event event) onFavourite;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return empty;

    Widget cardAt(int i) => EventCard(
          event: events[i],
          onTap: () => onOpen(events[i]),
          onFavourite: () => onFavourite(events[i]),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => cardAt(i),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 360,
            mainAxisExtent: 120,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: events.length,
          itemBuilder: (_, i) => cardAt(i),
        );
      },
    );
  }
}
