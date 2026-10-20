import 'package:flutter/material.dart';

import 'data/seed.dart';
import 'models/event.dart';
import 'routes.dart';
import 'tabs/events_tab.dart';
import 'tabs/favourites_tab.dart';
import 'tabs/profile_tab.dart';

class Shell extends StatefulWidget {
  const Shell({super.key, required this.themeMode, required this.onThemeMode});

  final ThemeMode themeMode;
  final void Function(ThemeMode mode) onThemeMode;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  /// R10: the data lives here; tabs get it as parameters and callbacks.
  List<Event> _events = seedEvents();
  Profile _profile = const Profile.empty();
  int _tab = 0;

  // R12: setState wraps only the change itself.
  void _favourite(Event e) {
    final updated = e.copyWith(favourite: !e.favourite);
    setState(() => _events = _replace(updated));
  }

  List<Event> _replace(Event updated) =>
      [for (final e in _events) e.id == updated.id ? updated : e];

  void _changed(Event updated) {
    final exists = _events.any((e) => e.id == updated.id);
    setState(() => _events = exists ? _replace(updated) : [..._events, updated]);
  }

  void _delete(Event removed) {
    final rest = _events.where((e) => e.id != removed.id).toList();
    setState(() => _events = rest);
  }

  void _setProfile(Profile p) => setState(() => _profile = p);

  void _goTo(int index) => setState(() => _tab = index);

  void _open(Event e) {
    Navigator.pushNamed(
      context,
      Routes.detail,
      arguments: DetailArgs(
        event: e,
        profileName: _profile.name,
        onChanged: _changed,
        onDelete: _delete,
        onOpenProfile: () => _goTo(2),
      ),
    );
  }

  /// R27: await the result, check null and mounted, then setState.
  Future<void> _add() async {
    final created = await Navigator.pushNamed<Event>(
      context,
      Routes.form,
      arguments: const FormArgs(),
    );
    if (created == null || !mounted) return;
    _changed(created);
  }

  Future<void> _about() async {
    Navigator.pop(context); // close the drawer
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About'),
        content: const Text('Campus Events - Flutter I, Lab 1.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _reset() async {
    Navigator.pop(context); // close the drawer
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset data?'),
        content: const Text('Events return to the seed, profile is cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final fresh = seedEvents();
    setState(() {
      _events = fresh;
      _profile = const Profile.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Events', 'Favourites', 'Profile'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[_tab])),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Campus Events',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: _about,
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Reset data'),
                onTap: _reset,
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _tab,
        children: [
          EventsTab(events: _events, onOpen: _open, onFavourite: _favourite),
          FavouritesTab(
            events: _events,
            onOpen: _open,
            onFavourite: _favourite,
            onBrowse: () => _goTo(0),
          ),
          ProfileTab(
            profile: _profile,
            events: _events,
            themeMode: widget.themeMode,
            onProfile: _setProfile,
            onThemeMode: widget.onThemeMode,
          ),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
              onPressed: _add,
              tooltip: 'New event',
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _goTo,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favourites',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
