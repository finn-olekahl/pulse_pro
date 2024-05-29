import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_pro/features/licenses/license_page.dart';
import 'package:pulse_pro/features/licenses/view/license_view.dart';


void main() {
  testWidgets('LicensesPage renders LicensesView', (WidgetTester tester) async {
    // Pump the widget into the widget tree
    await tester.pumpWidget(const MaterialApp(
      home: LicensesPage(),
    ));

    // Verify that LicensesView is present in the widget tree
    expect(find.byType(LicensesView), findsOneWidget);

    // Print a message indicating the test has passed
    ('LicensesView is present in the LicensesPage.');
  });
}
