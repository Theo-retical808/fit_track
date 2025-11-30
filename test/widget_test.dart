// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fit_track/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ThenixFitnessApp());

    // Verify that the auth screen loads with the app name
    expect(find.text('Thenix Fitness'), findsOneWidget);
    expect(find.text('Transform Your Body, Transform Your Life'), findsOneWidget);
    expect(find.text('Start Your Journey'), findsOneWidget);
  });
}
