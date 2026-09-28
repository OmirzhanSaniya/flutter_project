import 'package:flutter_test/flutter_test.dart';

import 'package:reactive_screen/main.dart';

void main() {
  testWidgets('Home screen shows the app bar title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('A screen that reacts'), findsOneWidget);
  });
}
