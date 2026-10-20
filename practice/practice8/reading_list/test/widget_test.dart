import 'package:flutter_test/flutter_test.dart';

import 'package:reading_list/main.dart';

void main() {
  testWidgets('Library shows the seed books', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Reading list (5)'), findsOneWidget);
    expect(find.text('Null Safety for Humans'), findsOneWidget);
  });
}
