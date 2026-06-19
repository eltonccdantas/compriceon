import 'package:flutter_test/flutter_test.dart';
import 'package:compriceon/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CompriceonApp());
    expect(find.text('Compriceon'), findsOneWidget);
  });
}
