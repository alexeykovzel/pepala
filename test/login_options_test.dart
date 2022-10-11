import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pepala/pages/auth/auth_options.dart';

void main() {
  testWidgets('Login options page has a title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginOptionsPage()));

    // Check that the page has a title
    final titleFinder = find.text("Pepapa");
    expect(titleFinder, findsOneWidget);
  });
}
