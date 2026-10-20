import 'package:flutter_test/flutter_test.dart';

import 'package:signup_form/main.dart';

void main() {
  testWidgets('Sign up form shows its fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Sign up'), findsWidgets);
  });
}
