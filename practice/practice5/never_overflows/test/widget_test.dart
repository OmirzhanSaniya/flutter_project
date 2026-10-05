import 'package:flutter_test/flutter_test.dart';

import 'package:never_overflows/main.dart';

void main() {
  testWidgets('Home screen shows the app bar title',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Contacts'), findsOneWidget);
  });
}
