import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:frontend/services/api_service.dart';

class FakeApiService extends ApiService {
  @override
  Future<List<dynamic>> getNotifications() async {
    return [];
  }
}

void main() {
  testWidgets('Scholarship dashboard displays correctly',
          (WidgetTester tester) async {

        final fakeApiService = FakeApiService();

        await tester.pumpWidget(
          MaterialApp(
            home: DashboardPage(
              apiService: fakeApiService,
              user: {
                'name': 'Test Student',
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Student Dashboard'), findsOneWidget);
        expect(find.text('Application Overview'), findsOneWidget);
        expect(find.text('Required Documents'), findsOneWidget);
        expect(find.text('Recent Notifications'), findsOneWidget);
      });
}
