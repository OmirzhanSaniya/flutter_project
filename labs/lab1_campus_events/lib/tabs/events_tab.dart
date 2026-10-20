import 'package:flutter/material.dart';

import '../models/event.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_list.dart';

/// R21: search + category chips + "past" filter above the list.
class EventsTab extends StatefulWidget {
  const EventsTab({
    super.key,
    required this.events,
    required this.onOpen,
    required this.onFavourite,
  });

  final List<Event> events;
  final void Function(Event event) onOpen;
  final void Function(Event event) onFavourite;

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  EventCategory? _category; // null = "All"
  bool _showPast = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// R7: where + toList creates a copy; sorting never touches the original.
  List<Event> get _visible {
    final q = _query.trim().toLowerCase();
    final list = widget.events
        .where((e) => _category == null || e.category == _category)
        .where((e) => _showPast || !e.isPast)
        .where((e) => q.isEmpty || e.title.toLowerCase().contains(q))
        .toList();
    list.sort((a, b) => a.when.compareTo(b.when));
    return list;
  }

  void _resetSearch() {
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: TextField(
            controller: _search,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Search events',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      onPressed: _resetSearch,
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear',
                    ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _category == null,
                onSelected: (_) => setState(() => _category = null),
              ),
              for (final c in EventCategory.values) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  avatar: Icon(c.icon),
                  label: Text(c.label),
                  selected: _category == c,
                  onSelected: (_) => setState(() => _category = c),
                ),
              ],
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('Show past'),
                selected: _showPast,
                onSelected: (v) => setState(() => _showPast = v),
              ),
            ],
          ),
        ),
        Expanded(
          child: EventList(
            events: visible,
            onOpen: widget.onOpen,
            onFavourite: widget.onFavourite,
            empty: EmptyState(
              icon: Icons.event_busy,
              message: 'No events found',
              actionLabel: 'Reset search',
              onAction: _resetSearch,
            ),
          ),
        ),
      ],
    );
  }
}
