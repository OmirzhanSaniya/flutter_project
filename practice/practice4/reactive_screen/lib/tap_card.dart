import 'package:flutter/material.dart';

/// A card that counts taps. Tapping it increments the count; long-pressing
/// it asks whether to reset. `_taps` is the only piece of state here, and
/// it lives in `_TapCardState` — nowhere else.
class TapCard extends StatefulWidget {
  const TapCard({super.key});

  @override
  State<TapCard> createState() => _TapCardState();
}

class _TapCardState extends State<TapCard> {
  int _taps = 0;

  Future<void> _confirmReset() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset the count?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    // showDialog is an async gap: the widget could have been removed from
    // the tree while the dialog was open, so check mounted before touching
    // state again.
    if (!mounted) return;

    if (shouldReset ?? false) {
      setState(() => _taps = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        //onTap: () => _taps++,
        onTap: () => setState(() => _taps++),
        onLongPress: _confirmReset,
        child: ListTile(
          title: const Text('Tap this card'),
          trailing: Text('$_taps'),
        ),
      ),
    );
  }
}
