import 'package:flutter/material.dart';

import '../models/event.dart';

/// R38 + R22: profile fields and the theme mode chips.
class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.profile,
    required this.events,
    required this.themeMode,
    required this.onProfile,
    required this.onThemeMode,
  });

  final Profile profile;
  final List<Event> events;
  final ThemeMode themeMode;
  final void Function(Profile profile) onProfile;
  final void Function(ThemeMode mode) onThemeMode;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _group;

  /// R38: the group validator is a RegExp, e.g. IT-2301.
  static final RegExp _groupPattern = RegExp(r'^[A-Z]{2,4}-\d{4}$');

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _group = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(covariant ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // "Reset data" in the drawer replaces the profile from outside.
    if (oldWidget.profile != widget.profile) {
      _name.text = widget.profile.name;
      _group.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  void _save() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    widget.onProfile(
      widget.profile.copyWith(name: _name.text.trim(), group: _group.text),
    );
  }

  String? _validateGroup(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return null; // group is optional
    return _groupPattern.hasMatch(v) ? null : 'Format: IT-2301';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // R38: computed on every build, never stored.
    final name = widget.profile.name;
    final lists = name.isEmpty
        ? 0
        : widget.events.where((e) => e.contains(name)).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => _save(),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _group,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.characters,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validateGroup,
                decoration: const InputDecoration(
                  labelText: 'Group',
                  hintText: 'IT-2301',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (_) => _save(),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('You are on $lists lists', style: text.titleMedium),
        const SizedBox(height: 24),
        Text('Theme', style: text.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final (mode, label) in const [
              (ThemeMode.system, 'System'),
              (ThemeMode.light, 'Light'),
              (ThemeMode.dark, 'Dark'),
            ])
              ChoiceChip(
                label: Text(label),
                selected: widget.themeMode == mode,
                onSelected: (_) => widget.onThemeMode(mode),
              ),
          ],
        ),
      ],
    );
  }
}
