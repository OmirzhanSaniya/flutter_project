import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/format.dart';

/// R18: reusable card. R19: avatar Stack with a "FULL" / "N left" badge.
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onFavourite,
  });

  final Event event;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  /// null when there is nothing to show (collection-if skips the badge).
  String? get _badge {
    if (event.isFull) return 'FULL';
    if (event.free <= 5) return '${event.free} left';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final badge = _badge;
    final dateColor = event.isPast ? scheme.outline : scheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: scheme.surfaceContainerHighest,
                    child: Icon(
                      event.category.icon,
                      color: event.category.color(scheme),
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      right: -8,
                      bottom: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge,
                          style: text.labelSmall?.copyWith(
                            color: scheme.onError,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium,
                    ),
                    Text(
                      formatDateTime(event.when),
                      style: text.bodyMedium?.copyWith(color: dateColor),
                    ),
                    Text(
                      event.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavourite,
                tooltip: event.favourite
                    ? 'Remove from favourites'
                    : 'Add to favourites',
                icon: Icon(
                  event.favourite ? Icons.favorite : Icons.favorite_border,
                  color: event.favourite ? scheme.error : scheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
