import 'package:flutter/foundation.dart';

import 'models/event.dart';

/// R25: the only place where route names are written as strings.
class Routes {
  const Routes._();

  static const String shell = '/';
  static const String detail = '/detail';
  static const String form = '/form';
}

/// R26: typed arguments of the detail route: the item AND the callbacks.
class DetailArgs {
  const DetailArgs({
    required this.event,
    required this.profileName,
    required this.onChanged,
    required this.onDelete,
    required this.onOpenProfile,
  });

  final Event event;
  final String profileName;
  final void Function(Event updated) onChanged;
  final void Function(Event removed) onDelete;
  final VoidCallback onOpenProfile;
}

/// R26: typed arguments of the form route. null = create a new event.
class FormArgs {
  const FormArgs({this.event});

  final Event? event;
}
