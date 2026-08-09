import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('SMEC Connect App Boots Cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmecConnectApp(),
      ),
    );

    // Pump frames to complete splash timer
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(SmecConnectApp), findsOneWidget);
  });
}
