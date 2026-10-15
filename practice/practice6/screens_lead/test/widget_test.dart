import 'package:flutter_test/flutter_test.dart';

import 'package:screens_lead/main.dart';

void main() {
  testWidgets('List screen shows the students', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Students'), findsOneWidget);
    expect(find.text('Aida Akhmetova'), findsOneWidget);
  });
}
