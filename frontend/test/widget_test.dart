import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('Scholarship dashboard displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ScholarshipTrackerApp());

    expect(find.text('Student Dashboard'), findsOneWidget);
    expect(find.text('Application Overview'), findsOneWidget);
    expect(find.text('Required Documents'), findsOneWidget);
    expect(find.text('Recent Notifications'), findsOneWidget);
  });
}