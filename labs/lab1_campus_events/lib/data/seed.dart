import '../models/event.dart';

/// Twelve seed events, dates relative to today.
List<Event> seedEvents() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  DateTime at(int days, int hour) =>
      today.add(Duration(days: days, hours: hour));

  return [
    Event(
      id: 'e1',
      title: 'Autumn Open Mic Night',
      category: EventCategory.music,
      when: at(2, 19),
      place: 'Main Hall, Building A',
      limit: 120,
      names: const ['Aidos', 'Dana', 'Timur', 'Alina'],
      description: 'Bring a song, a poem or just your ears.',
    ),
    Event(
      id: 'e2',
      title: 'Hackathon: Build a Campus App in 24 Hours',
      category: EventCategory.tech,
      when: at(5, 10),
      place: 'Innovation Lab',
      limit: 40,
      names: const ['Nurlan', 'Madina', 'Arman', 'Zhanna', 'Dias'],
      description: 'Teams of 3-4. Pizza and mentors included.',
    ),
    // Mandatory: 60-character title that must wrap without stripes.
    Event(
      id: 'e3',
      title: 'Interdisciplinary Student Research and Innovation Expo, 2026',
      category: EventCategory.career,
      when: at(9, 11),
      place: 'Exhibition Centre',
      limit: 200,
      names: const ['Saule', 'Erlan'],
      description: 'Posters, demos and a jury from industry.',
    ),
    // Mandatory: item at its limit (FULL).
    Event(
      id: 'e4',
      title: 'Basketball Friendly: Faculty vs Students',
      category: EventCategory.sport,
      when: at(3, 17),
      place: 'Sports Complex',
      limit: 5,
      names: const ['Aidos', 'Timur', 'Dias', 'Arman', 'Erlan'],
      description: 'Only five spots on the bench.',
    ),
    // Mandatory: past item.
    Event(
      id: 'e5',
      title: 'Freshers Welcome Concert',
      category: EventCategory.music,
      when: at(-6, 18),
      place: 'Amphitheatre',
      limit: 300,
      names: const ['Dana', 'Alina', 'Madina'],
      description: 'Where it all started.',
    ),
    // Mandatory: online item (place is a link).
    Event(
      id: 'e6',
      title: 'Flutter Study Jam (online)',
      category: EventCategory.tech,
      when: at(1, 20),
      place: 'https://meet.example.com/flutter-jam',
      limit: 100,
      online: true,
      names: const ['Zhanna', 'Nurlan'],
      description: 'Widgets, state and a lot of questions.',
    ),
    // Mandatory: item without the optional description.
    Event(
      id: 'e7',
      title: 'Morning Run Club',
      category: EventCategory.sport,
      when: at(1, 7),
      place: 'Campus Park',
      limit: 30,
      names: const ['Saule'],
    ),
    // 3 places left -> "3 left" badge.
    Event(
      id: 'e8',
      title: 'Watercolour Workshop',
      category: EventCategory.art,
      when: at(4, 15),
      place: 'Art Studio',
      limit: 12,
      names: const [
        'Dana', 'Alina', 'Madina', 'Zhanna', 'Saule',
        'Aidos', 'Erlan', 'Dias', 'Arman',
      ],
      description: 'All materials are provided.',
    ),
    Event(
      id: 'e9',
      title: 'Career Fair',
      category: EventCategory.career,
      when: at(12, 10),
      place: 'Main Hall, Building B',
      limit: 500,
      names: const ['Timur', 'Dana'],
    ),
    Event(
      id: 'e10',
      title: 'Photo Walk: Old Town',
      category: EventCategory.art,
      when: at(7, 16),
      place: 'Meeting at the main gate',
      limit: 25,
      names: const ['Alina'],
      description: 'Any camera works, even a phone.',
    ),
    Event(
      id: 'e11',
      title: 'Chess Tournament',
      category: EventCategory.sport,
      when: at(-2, 14),
      place: 'Library, 2nd floor',
      limit: 32,
      names: const ['Arman', 'Dias', 'Erlan'],
      description: 'Rapid format, 10 + 5.',
    ),
    Event(
      id: 'e12',
      title: 'Resume Clinic (online)',
      category: EventCategory.career,
      when: at(6, 18),
      place: 'https://meet.example.com/resume-clinic',
      limit: 60,
      online: true,
      names: const ['Madina'],
      description: 'Send your CV, get it reviewed live.',
    ),
  ];
}
