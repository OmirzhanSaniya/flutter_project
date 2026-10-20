import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/event.dart';
import '../routes.dart';
import '../utils/format.dart';

enum _Menu { edit, delete }

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.args});

  final DetailArgs args;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Event _event;
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _event = widget.args.event;
    _now = DateTime.now();
    // R13: created once in initState, cancelled in dispose.
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _me => widget.args.profileName.trim();

  /// Local copy first, then tell the shell.
  void _apply(Event updated) {
    setState(() => _event = updated);
    widget.args.onChanged(updated);
  }

  Future<void> _register() async {
    if (_me.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Set your name in the profile first'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () {
              if (mounted) Navigator.pop(context);
              widget.args.onOpenProfile();
            },
          ),
        ),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Register?'),
        content: Text('Register as $_me for "${_event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Register'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    _apply(_event.copyWith(names: [..._event.names, _me]));
  }

  void _unregister() {
    final rest = _event.names.where((n) => n != _me).toList();
    _apply(_event.copyWith(names: rest));
  }

  Future<void> _edit() async {
    final updated = await Navigator.pushNamed<Event>(
      context,
      Routes.form,
      arguments: FormArgs(event: _event),
    );
    if (updated == null || !mounted) return;
    _apply(updated);
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete event?'),
        content: Text('"${_event.title}" will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    widget.args.onDelete(_event);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mine = _me.isNotEmpty && _event.contains(_me);

    // R16: null disables the button when the user cannot act.
    final String label;
    final VoidCallback? action;
    if (mine) {
      label = 'Cancel registration';
      action = _unregister;
    } else if (_event.isFull) {
      label = 'Event is full';
      action = null;
    } else if (_event.isPast) {
      label = 'Event is over';
      action = null;
    } else {
      label = 'Register';
      action = _register;
    }

    // R31: no back arrow is written, the Navigator adds it by itself.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_event.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            PopupMenuButton<_Menu>(
              onSelected: (m) => switch (m) {
                _Menu.edit => _edit(),
                _Menu.delete => _delete(),
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: _Menu.edit, child: Text('Edit')),
                PopupMenuItem(value: _Menu.delete, child: Text('Delete')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            // R24: header Stack.
            SizedBox(
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/header.jpg', fit: BoxFit.cover),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Chip(
                      avatar: Icon(
                        _event.category.icon,
                        color: _event.category.color(scheme),
                      ),
                      label: Text(_event.category.label),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Chip(
                      avatar: const Icon(Icons.timer_outlined),
                      label: Text(
                        describeCountdown(Countdown.of(_event.when, _now)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // R29: tabs; the label shows the live count.
            TabBar(
              tabs: [
                const Tab(text: 'About'),
                Tab(text: 'Going (${_event.count}/${_event.limit})'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_aboutTab(context), _namesTab(context)],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(onPressed: action, child: Text(label)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutTab(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // R5: record destructured where it is shown.
    final (:taken, :free) = _event.places;
    final description = _event.description;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(_event.title, style: text.titleLarge),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: Text(formatDateTime(_event.when)),
        ),
        ListTile(
          leading: Icon(_event.online ? Icons.link : Icons.place),
          title: Text(_event.place),
          subtitle: Text(_event.online ? 'Online' : 'On campus'),
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: Text('$taken going, $free places left'),
        ),
        // R6: collection-if, no `!`.
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(description, style: text.bodyLarge),
        ],
      ],
    );
  }

  Widget _namesTab(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    if (_event.names.isEmpty) {
      return Center(child: Text('Nobody yet', style: text.titleMedium));
    }
    return ListView(
      children: [
        for (final name in _event.names)
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: name == _me
                ? Text(
                    'You',
                    style: text.titleMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(name),
          ),
      ],
    );
  }
}
