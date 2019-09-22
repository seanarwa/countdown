import 'package:flutter_test/flutter_test.dart';

import 'package:countdown/main.dart';

void main() {

  testWidgets('Empty Test', (WidgetTester tester) async {

    await tester.pumpWidget(App());

    expect(find.text(''), findsNothing);
  });
}