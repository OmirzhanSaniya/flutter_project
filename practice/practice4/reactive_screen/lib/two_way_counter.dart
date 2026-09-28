import 'package:flutter/material.dart';

/// A counter that goes both up and down, plus a Save button that simulates
/// a two-second network call. `_count` and `_saving` are the only state,
/// both living in `_TwoWayCounterState`.
class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _count = 0;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);

    await Future.delayed(const Duration(seconds: 2));

    // The widget could be gone by the time this await returns.
    if (!mounted) return;

    setState(() => _saving = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              // At zero, passing null disables the button — the framework
              // greys it out itself, no manual check needed.
              onPressed: _count > 0 ? () => setState(() => _count--) : null,
              child: const Text('-'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '$_count',
                style: TextStyle(fontSize: 22, color: colors.onSurface),
              ),
            ),
            FilledButton(
              onPressed: () => setState(() => _count++),
              child: const Text('+'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
