import '../models/countdown.dart';

/// R8: own formatting helpers, no packages.
const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String two(int n) => n.toString().padLeft(2, '0');

String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

String formatTime(DateTime d) => '${two(d.hour)}:${two(d.minute)}';

/// "18 Oct, 10:00"
String formatDateTime(DateTime d) => '${formatDate(d)}, ${formatTime(d)}';

String formatDuration(Duration d) {
  if (d.inDays > 0) return '${d.inDays} d ${d.inHours % 24} h';
  if (d.inHours > 0) return '${d.inHours} h ${d.inMinutes % 60} min';
  return '${d.inMinutes} min';
}

/// R9: exhaustive switch over the sealed [Countdown].
String describeCountdown(Countdown c) => switch (c) {
      Upcoming(:final left) => 'Starts in ${formatDuration(left)}',
      Started(:final ago) => 'Started ${formatDuration(ago)} ago',
      Ended() => 'Ended',
    };
