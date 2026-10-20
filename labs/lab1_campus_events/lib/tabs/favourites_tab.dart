import 'package:flutter/material.dart';

import '../models/event.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_list.dart';

class FavouritesTab extends StatelessWidget {
  const FavouritesTab({
    super.key,
    required this.events,
    required this.onOpen,
    required this.onFavourite,
    required this.onBrowse,
  });

  final List<Event> events;
  final void Function(Event event) onOpen;
  final void Function(Event event) onFavourite;

  /// R28: switches the shell to the first tab, no second Navigator.
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final favourites = events.where((e) => e.favourite).toList()
      ..sort((a, b) => a.when.compareTo(b.when));
    return EventList(
      events: favourites,
      onOpen: onOpen,
      onFavourite: onFavourite,
      empty: EmptyState(
        icon: Icons.favorite_border,
        message: 'No favourites yet',
        actionLabel: 'Browse events',
        onAction: onBrowse,
      ),
    );
  }
}
