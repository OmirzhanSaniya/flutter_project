import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/format.dart';

/// R26: receives Event? (null = new) and returns the Event via pop.
class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.event});

  final Event? event;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // R35: created once as fields of State, disposed in dispose().
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _limit = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _dateText = TextEditingController();
  final TextEditingController _timeText = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _placeFocus = FocusNode();
  final FocusNode _limitFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  EventCategory? _category;
  bool _online = false;
  DateTime? _date;
  TimeOfDay? _time;
  bool _dirty = false;
  bool _saving = false;

  bool get _isNew => widget.event == null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    if (e == null) return;
    _title.text = e.title;
    _place.text = e.place;
    _limit.text = '${e.limit}';
    _description.text = e.description ?? '';
    _category = e.category;
    _online = e.online;
    _date = DateTime(e.when.year, e.when.month, e.when.day);
    _time = TimeOfDay(hour: e.when.hour, minute: e.when.minute);
    _dateText.text = formatDate(e.when);
    _timeText.text = formatTime(e.when);
  }

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _limit.dispose();
    _description.dispose();
    _dateText.dispose();
    _timeText.dispose();
    _titleFocus.dispose();
    _placeFocus.dispose();
    _limitFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  /// R36: date and time are combined only on save / validation.
  DateTime? get _combined {
    final d = _date;
    final t = _time;
    if (d == null || t == null) return null;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked == null || !mounted) return; // cancel keeps the old value
    setState(() {
      _date = picked;
      _dateText.text = formatDate(picked);
      _dirty = true;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _time = picked;
      _timeText.text = '${two(picked.hour)}:${two(picked.minute)}';
      _dirty = true;
    });
  }

  // R34: validators.
  String? _validateTitle(String? v) {
    final s = (v ?? '').trim();
    if (s.length < 3) return 'At least 3 characters';
    if (s.length > 60) return 'At most 60 characters';
    return null;
  }

  String? _validatePlace(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return _online ? 'Link is required' : 'Place is required';
    if (_online && !s.contains('://')) return 'Link must contain ://';
    return null;
  }

  String? _validateLimit(String? v) {
    final n = int.tryParse((v ?? '').trim());
    if (n == null) return 'Enter a whole number';
    if (n < 1 || n > 500) return 'From 1 to 500';
    final current = widget.event?.count ?? 0;
    if (n < current) return 'Already $current going';
    return null;
  }

  String? _validateDate(String? v) {
    if (_date == null) return 'Pick a date';
    return null;
  }

  String? _validateTime(String? v) {
    final when = _combined;
    if (when == null) return 'Pick a time';
    if (_isNew && !when.isAfter(DateTime.now())) return 'Must be in the future';
    return null;
  }

  Event _build() {
    final base = widget.event ??
        Event.empty().copyWith(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
        );
    final description = _description.text.trim();
    return base.copyWith(
      title: _title.text.trim(),
      category: _category,
      when: _combined,
      place: _place.text.trim(),
      limit: int.parse(_limit.text.trim()),
      online: _online,
      description: description,
      clearDescription: description.isEmpty,
    );
  }

  /// R17 + R33: one validate(), fake 1 s save, no double save.
  Future<void> _save() async {
    if (_saving) return;
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return; // R14
    final event = _build();
    setState(() {
      _saving = false;
      _dirty = false; // Save never asks "Discard changes?"
    });
    Navigator.pop(context, event);
  }

  /// R30: asks only when something was changed.
  Future<void> _onPop(bool didPop, Object? result) async {
    if (didPop) return;
    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (discard != true || !mounted) return;
    Navigator.pop(context);
  }

  void _unfocus(PointerDownEvent _) => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: _onPop,
      child: Scaffold(
        appBar: AppBar(title: Text(_isNew ? 'New event' : 'Edit event')),
        // R37: scrollable, no Spacer inside.
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            onChanged: _markDirty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  focusNode: _titleFocus,
                  maxLength: 60,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  validator: _validateTitle,
                  onTapOutside: _unfocus,
                  onFieldSubmitted: (_) => _placeFocus.requestFocus(),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<EventCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final c in EventCategory.values)
                      DropdownMenuItem(value: c, child: Text(c.label)),
                  ],
                  validator: (v) => v == null ? 'Pick a category' : null,
                  onChanged: (v) => setState(() {
                    _category = v;
                    _dirty = true;
                  }),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Online event'),
                  value: _online,
                  onChanged: (v) => setState(() {
                    _online = v;
                    _dirty = true;
                  }),
                ),
                TextFormField(
                  controller: _place,
                  focusNode: _placeFocus,
                  keyboardType: _online ? TextInputType.url : TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: _validatePlace,
                  onTapOutside: _unfocus,
                  onFieldSubmitted: (_) => _limitFocus.requestFocus(),
                  decoration: InputDecoration(
                    labelText: _online ? 'Meeting link' : 'Place',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _limit,
                  focusNode: _limitFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: _validateLimit,
                  onTapOutside: _unfocus,
                  onFieldSubmitted: (_) => _descriptionFocus.requestFocus(),
                  decoration: const InputDecoration(
                    labelText: 'Capacity',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dateText,
                  readOnly: true,
                  onTap: _pickDate,
                  validator: _validateDate,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _timeText,
                  readOnly: true,
                  onTap: _pickTime,
                  validator: _validateTime,
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    suffixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _description,
                  focusNode: _descriptionFocus,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  minLines: 2,
                  maxLines: 4,
                  onTapOutside: _unfocus,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
