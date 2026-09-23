import 'package:flutter/material.dart';

/// Shows the profile photo, name and university, stacked one under
/// the other. Nothing here ever changes, so it is a StatelessWidget
/// with plain final fields and a const constructor.
class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/profile.jpg',
              width: 120,
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              name,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              university,
              style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
