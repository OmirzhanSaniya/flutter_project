/// R9: sealed class - the compiler forces every switch to cover all cases.
sealed class Countdown {
  const Countdown();

  /// Events are assumed to last [length]; after that they are over.
  factory Countdown.of(
    DateTime when,
    DateTime now, {
    Duration length = const Duration(hours: 2),
  }) {
    if (now.isBefore(when)) return Upcoming(when.difference(now));
    if (now.isBefore(when.add(length))) return Started(now.difference(when));
    return const Ended();
  }
}

final class Upcoming extends Countdown {
  const Upcoming(this.left);

  final Duration left;
}

final class Started extends Countdown {
  const Started(this.ago);

  final Duration ago;
}

final class Ended extends Countdown {
  const Ended();
}
