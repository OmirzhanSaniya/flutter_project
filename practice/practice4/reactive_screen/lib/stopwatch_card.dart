import 'dart:async';

import 'package:flutter/material.dart';

/// A stopwatch with Start/Stop/Reset. `_seconds` and `_timer` are the only
/// state; the mm:ss text is a getter computed from `_seconds`, not stored
/// separately — a value you can compute is not state.
class StopwatchCard extends StatefulWidget {
  const StopwatchCard({super.key});

  @override
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {
  int _seconds = 0;
  Timer? _timer;

  String get _formatted {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _start() {
    // Guard against starting twice — a second Timer.periodic would tick
    // faster than the display can show.
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _reset() {
    _stop();
    setState(() => _seconds = 0);
  }

  @override
  void dispose() {
    // Cancel first, so a tick can never fire after this State is gone —
    // the mirror image of super.initState() being first on the way in.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _formatted,
              style: TextStyle(fontSize: 28, color: colors.onSurface),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(onPressed: _start, child: const Text('Start')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: _stop, child: const Text('Stop')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
