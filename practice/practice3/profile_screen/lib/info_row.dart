import 'package:flutter/material.dart';

/// One label/value line, e.g. "Course" on the left, "2" on the right.
/// Used four times in main.dart, once per entry in `facts`.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.onSurfaceVariant)),
          Text(
            value,
            style:
                TextStyle(color: colors.onSurface, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
