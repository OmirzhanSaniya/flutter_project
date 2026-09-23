import 'package:flutter_test/flutter_test.dart';
import 'package:profile_screen/main.dart';

void main() {
  testWidgets('Profile screen shows the app bar title',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileApp());

    expect(find.text('My profile'), findsOneWidget);
  });
}
