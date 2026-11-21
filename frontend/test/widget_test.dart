import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:frontend/new_application_page.dart';
import 'package:frontend/services/api_service.dart';

class FakeApiService extends ApiService {
  @override
  Future<List<dynamic>> getScholarshipPrograms() async => [
    {
      'id': 41,
      'name': 'Community Scholarship',
      'description': 'Support for eligible students.',
      'academic_year': '2026-2027',
      'application_deadline': '2026-12-15',
      'has_applied': false,
      'application': null,
      'required_documents': [
        {
          'id': 1,
          'document_name': 'Certificate of Enrollment',
          'description': 'Current semester proof.',
          'is_required': true,
          'allowed_file_types': 'pdf,jpg,png',
          'max_file_size_kb': 5120,
        },
      ],
    },
    {
      'id': 42,
      'name': 'Applied Scholarship',
      'has_applied': true,
      'application': {'status': 'draft'},
      'required_documents': [],
    },
  ];

  @override
  Future<Map<String, dynamic>> createApplication({
    required int scholarshipProgramId,
  }) async => {
    'success': true,
    'application': {
      'id': 12,
      'application_number': 'APP-TEST-NEW-001',
      'status': 'draft',
    },
  };

  @override
  Future<List<dynamic>> getApplications() async {
    return [
      {
        'id': 1,
        'application_number': 'TEST-APP-001',
        'status': 'submitted',
        'scholarship_program': {'name': 'Test Scholarship'},
        'required_documents': [
          {
            'id': 1,
            'document_name': 'Transcript of Records',
            'is_required': true,
            'uploaded': true,
          },
          {
            'id': 2,
            'document_name': 'Certificate of Registration',
            'is_required': true,
            'uploaded': false,
          },
        ],
      },
    ];
  }

  @override
  Future<List<dynamic>> getNotifications() async {
    return [
      {
        'title': 'Application Received',
        'message': 'Your application has been received.',
      },
    ];
  }
}

void main() {
  testWidgets('Scholarship dashboard displays correctly', (
    WidgetTester tester,
  ) async {
    final fakeApiService = FakeApiService();

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(
          apiService: fakeApiService,
          user: {'name': 'Test Student'},
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Student Dashboard'), findsOneWidget);
    expect(find.text('Application Overview'), findsOneWidget);
    expect(find.text('Recent Notifications'), findsOneWidget);

    expect(find.text('Test Scholarship'), findsOneWidget);
    expect(find.textContaining('TEST-APP-001'), findsOneWidget);
    expect(find.textContaining('Status: SUBMITTED'), findsOneWidget);

    expect(find.text('Applications'), findsOneWidget);
    expect(find.text('Submitted Documents'), findsOneWidget);
    expect(find.text('Missing Documents'), findsOneWidget);

    expect(find.text('Application Received'), findsOneWidget);
    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Application Received'), findsNWidgets(2));
  });

  testWidgets('student can review programs and create a draft application', (
    WidgetTester tester,
  ) async {
    final fakeApiService = FakeApiService();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) =>
                        NewApplicationPage(apiService: fakeApiService),
                  ),
                ),
                child: const Text('Open programs'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open programs'));
    await tester.pumpAndSettle();

    expect(find.text('Community Scholarship'), findsOneWidget);
    expect(
      find.textContaining('Certificate of Enrollment (required)'),
      findsOneWidget,
    );
    expect(find.textContaining('Maximum size: 5120 KB'), findsOneWidget);
    expect(find.textContaining('Types: pdf,jpg,png'), findsOneWidget);
    expect(find.text('Already applied · draft'), findsOneWidget);

    await tester.tap(find.text('Create draft application'));
    await tester.pumpAndSettle();

    expect(find.text('Open programs'), findsOneWidget);
    expect(
      find.textContaining('Draft APP-TEST-NEW-001 created.'),
      findsOneWidget,
    );
  });
}
