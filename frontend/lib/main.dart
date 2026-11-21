import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'services/api_service.dart';
import 'login_page.dart';
import 'new_application_page.dart';

void main() {
  runApp(const ScholarshipTrackerApp());
}

class ScholarshipTrackerApp extends StatelessWidget {
  const ScholarshipTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scholarship Requirement Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: LoginPage(apiService: ApiService()),
    );
  }
}

// DASHBOARD PAGE

class DashboardPage extends StatefulWidget {
  final ApiService apiService;
  final Map<String, dynamic> user;

  const DashboardPage({
    super.key,
    required this.apiService,
    required this.user,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<dynamic>> applicationsFuture;

  @override
  void initState() {
    super.initState();
    applicationsFuture = widget.apiService.getApplications();
  }

  void reloadApplications() {
    setState(() {
      applicationsFuture = widget.apiService.getApplications();
    });
  }

  void showNotifications() {
    final notificationsFuture = widget.apiService.getNotifications();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Notifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: notificationsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Unable to load notifications.'),
                        );
                      }

                      final notifications = snapshot.data ?? [];

                      if (notifications.isEmpty) {
                        return const Center(
                          child: Text('No notifications yet'),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.all(12),
                        children: notifications.map((notification) {
                          return NotificationItem(
                            title: notification['title'] ?? 'Notification',
                            message: notification['message'] ?? '',
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatStatus(String status) {
    return status.replaceAll('_', ' ').toUpperCase();
  }

  Future<void> openApplication(Map<String, dynamic> application) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ApplicationDetailsPage(
          apiService: widget.apiService,
          application: application,
        ),
      ),
    );

    if (result == true && mounted) {
      reloadApplications();
    }
  }

  Future<void> openNewApplication() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => NewApplicationPage(apiService: widget.apiService),
      ),
    );
    if (created == true && mounted) reloadApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Requirement Tracker'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: showNotifications,
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                widget.user['name'] ?? 'Student',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                await widget.apiService.logout();

                if (!context.mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(apiService: widget.apiService),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Logout failed: $e')));
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: applicationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    const Text('Unable to load your applications.'),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: reloadApplications,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final applications = snapshot.data ?? [];

          int submittedDocuments = 0;
          int missingDocuments = 0;

          for (final rawApplication in applications) {
            final application = Map<String, dynamic>.from(
              rawApplication as Map,
            );
            final documents =
                application['required_documents'] as List<dynamic>? ?? [];

            for (final rawDocument in documents) {
              final document = Map<String, dynamic>.from(rawDocument as Map);

              if (document['is_required'] == true) {
                if (document['uploaded'] == true) {
                  submittedDocuments++;
                } else {
                  missingDocuments++;
                }
              }
            }
          }

          return RefreshIndicator(
            onRefresh: () async {
              reloadApplications();
              await applicationsFuture;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Student Dashboard',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Monitor your scholarship application and requirements.',
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: openNewApplication,
                    icon: const Icon(Icons.add),
                    label: const Text('New Application'),
                  ),
                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SummaryCard(
                        title: 'Applications',
                        value: '${applications.length}',
                        icon: Icons.description_outlined,
                      ),
                      SummaryCard(
                        title: 'Submitted Documents',
                        value: '$submittedDocuments',
                        icon: Icons.upload_file,
                      ),
                      SummaryCard(
                        title: 'Missing Documents',
                        value: '$missingDocuments',
                        icon: Icons.warning_amber,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Application Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  if (applications.isEmpty)
                    const Card(
                      child: ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('No applications found'),
                        subtitle: Text(
                          'Your scholarship applications will appear here.',
                        ),
                      ),
                    )
                  else
                    ...applications.map((rawApplication) {
                      final application = Map<String, dynamic>.from(
                        rawApplication as Map,
                      );

                      final program =
                          application['scholarship_program']
                              as Map<String, dynamic>?;

                      final programName =
                          program?['name'] ?? 'Scholarship Application';

                      final status =
                          application['status']?.toString() ?? 'unknown';

                      return Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.school,
                            color: Colors.indigo,
                          ),
                          title: Text(programName),
                          subtitle: Text(
                            '${application['application_number'] ?? 'No application number'}'
                            '\nStatus: ${formatStatus(status)}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => openApplication(application),
                        ),
                      );
                    }),

                  const SizedBox(height: 24),

                  const Text(
                    'Recent Notifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  FutureBuilder<List<dynamic>>(
                    future: widget.apiService.getNotifications(),
                    builder: (context, notificationSnapshot) {
                      if (notificationSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (notificationSnapshot.hasError) {
                        return const Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                            title: Text('Unable to load notifications'),
                          ),
                        );
                      }

                      final notifications = notificationSnapshot.data ?? [];

                      if (notifications.isEmpty) {
                        return const Card(
                          child: ListTile(
                            leading: Icon(Icons.notifications_none),
                            title: Text('No notifications yet'),
                          ),
                        );
                      }

                      return Column(
                        children: notifications.map((notification) {
                          return NotificationItem(
                            title: notification['title'] ?? 'Notification',
                            message: notification['message'] ?? '',
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// APPLICATION DETAILS PAGE

class ApplicationDetailsPage extends StatefulWidget {
  final ApiService apiService;
  final Map<String, dynamic> application;

  const ApplicationDetailsPage({
    super.key,
    required this.apiService,
    required this.application,
  });

  @override
  State<ApplicationDetailsPage> createState() => _ApplicationDetailsPageState();
}

class _ApplicationDetailsPageState extends State<ApplicationDetailsPage> {
  final Map<int, bool> isUploading = {};
  late List<Map<String, dynamic>> requiredDocuments;

  bool isSubmitting = false;

  int get applicationId => widget.application['id'] as int;

  String get applicationStatus =>
      widget.application['status']?.toString() ?? 'unknown';

  bool get canUpload =>
      applicationStatus == 'draft' || applicationStatus == 'for_correction';

  @override
  void initState() {
    super.initState();

    final documents =
        widget.application['required_documents'] as List<dynamic>? ?? [];

    requiredDocuments = documents
        .map((document) => Map<String, dynamic>.from(document as Map))
        .toList();
  }

  int get requiredCount => requiredDocuments
      .where((document) => document['is_required'] == true)
      .length;

  int get completedCount => requiredDocuments
      .where(
        (document) =>
            document['is_required'] == true && document['uploaded'] == true,
      )
      .length;

  bool get allRequiredUploaded => completedCount == requiredCount;

  Future<void> uploadDocument(
    int documentId,
    String fileName,
    Uint8List fileBytes,
  ) async {
    setState(() {
      isUploading[documentId] = true;
    });

    try {
      await widget.apiService.uploadDocument(
        applicationId: applicationId,
        requiredDocumentId: documentId,
        fileName: fileName,
        fileBytes: fileBytes,
      );

      if (!mounted) return;

      setState(() {
        final index = requiredDocuments.indexWhere(
          (document) => document['id'] == documentId,
        );

        if (index != -1) {
          requiredDocuments[index]['uploaded'] = true;
          requiredDocuments[index]['document'] = {
            'original_filename': fileName,
            'status': 'pending',
          };
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$fileName uploaded successfully.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isUploading[documentId] = false;
        });
      }
    }
  }

  Future<void> pickDocument(int documentId) async {
    try {
      final pickedFile = await FilePicker.pickFile();

      if (pickedFile == null) return;

      final bytes = await pickedFile.readAsBytes();

      if (!mounted) return;

      await uploadDocument(documentId, pickedFile.name, bytes);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Unable to select file: $e')));
    }
  }

  Future<void> submitApplication() async {
    if (!allRequiredUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all required documents first.'),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final result = await widget.apiService.submitApplication(
        applicationId: applicationId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'Application submitted successfully.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Submission failed: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final program =
        widget.application['scholarship_program'] as Map<String, dynamic>?;

    final programName = program?['name'] ?? 'Scholarship Application';

    final applicationNumber =
        widget.application['application_number'] ?? 'Not available';

    final progress = requiredCount == 0 ? 0.0 : completedCount / requiredCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              programName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Application Number'),
                    subtitle: Text(applicationNumber),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Application Status'),
                    subtitle: Text(
                      applicationStatus.replaceAll('_', ' ').toUpperCase(),
                    ),
                    trailing: Chip(
                      label: Text(
                        applicationStatus.replaceAll('_', ' ').toUpperCase(),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Required Documents'),
                    subtitle: Text(
                      '$completedCount of $requiredCount uploaded',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Application Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            LinearProgressIndicator(value: progress, minHeight: 8),
            const SizedBox(height: 8),

            Text(
              '$completedCount of $requiredCount required documents completed.',
            ),

            const SizedBox(height: 24),

            const Text(
              'Document Checklist',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (requiredDocuments.isEmpty)
              const Card(
                child: ListTile(title: Text('No document requirements found')),
              )
            else
              ...requiredDocuments.map((document) {
                final id = document['id'] as int;
                final uploaded = document['uploaded'] == true;
                final documentInfo =
                    document['document'] as Map<String, dynamic>?;

                final fileName = documentInfo?['original_filename']?.toString();

                final isRequired = document['is_required'] == true;
                final uploading = isUploading[id] ?? false;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      uploaded ? Icons.check_circle : Icons.pending_actions,
                      color: uploaded ? Colors.green : Colors.orange,
                    ),
                    title: Text(document['document_name'] ?? 'Document'),
                    subtitle: Text(
                      [
                        isRequired ? 'Required' : 'Optional',
                        uploading
                            ? 'Uploading...'
                            : fileName ?? 'No file uploaded',
                      ].join('\n'),
                    ),
                    isThreeLine: true,
                    trailing: canUpload
                        ? ElevatedButton(
                            onPressed: uploading
                                ? null
                                : () => pickDocument(id),
                            child: uploading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(uploaded ? 'Change' : 'Upload'),
                          )
                        : uploaded
                        ? const Icon(Icons.check)
                        : const Icon(Icons.lock_outline),
                  ),
                );
              }),

            const SizedBox(height: 24),

            if (['draft', 'for_correction'].contains(applicationStatus))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: allRequiredUploaded && !isSubmitting
                      ? submitApplication
                      : null,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    isSubmitting ? 'Submitting...' : 'Submit Application',
                  ),
                ),
              ),

            if (applicationStatus == 'for_correction')
              const Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.orange),
                  title: Text('Correction required'),
                  subtitle: Text(
                    'Upload the corrected documents as instructed by the reviewer.',
                  ),
                ),
              ),

            if (!canUpload)
              const Card(
                child: ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('Document uploads are unavailable'),
                  subtitle: Text(
                    'This application is no longer in an uploadable status.',
                  ),
                ),
              ),

            if (applicationStatus == 'draft')
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Upload all required documents before submission.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// SUMMARY CARD

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

// NOTIFICATION ITEM

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;

  const NotificationItem({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications_outlined, color: Colors.indigo),
        title: Text(title),
        subtitle: Text(message),
      ),
    );
  }
}
