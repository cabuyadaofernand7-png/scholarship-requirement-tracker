import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'login_page.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(apiService: ApiService()),
    );
  }
}

// DASHBOARD PAGE

class DashboardPage extends StatelessWidget {
  final ApiService apiService;
  final Map<String, dynamic> user;

  const DashboardPage({
    super.key,
    required this.apiService,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Requirement Tracker'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                user['name'] ?? 'Student',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                await apiService.logout();

                if (!context.mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(
                      apiService: apiService,
                    ),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logout failed: $e'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Dashboard',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Monitor your scholarship application and requirements.',
            ),
            const SizedBox(height: 24),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                SummaryCard(
                  title: 'Applications',
                  value: '1',
                  icon: Icons.description_outlined,
                ),
                SummaryCard(
                  title: 'Submitted Documents',
                  value: '3',
                  icon: Icons.upload_file,
                ),
                SummaryCard(
                  title: 'Missing Documents',
                  value: '2',
                  icon: Icons.warning_amber,
                ),
                SummaryCard(
                  title: 'Notifications',
                  value: '2',
                  icon: Icons.notifications_active_outlined,
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              'Application Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.school,
                  color: Colors.indigo,
                ),
                title: const Text('Scholarship Application'),
                subtitle: const Text(
                  'Sample Application • Status: Draft',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplicationDetailsPage(
                        apiService: apiService,
                        applicationId: 3,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Required Documents',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            const DocumentItem(
              name: 'Certificate of Registration',
              submitted: true,
              requiredDocumentId: 1,
            ),
            const DocumentItem(
              name: 'Latest Grades',
              submitted: true,
              requiredDocumentId: 2,
            ),
            const DocumentItem(
              name: 'Certificate of Indigency',
              submitted: false,
              requiredDocumentId: 3,
            ),
            const DocumentItem(
              name: 'Parent or Guardian Information',
              submitted: false,
              requiredDocumentId: 4,
            ),

            const SizedBox(height: 24),

            const Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            FutureBuilder<List<dynamic>>(
              future: apiService.getNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      title: Text('Unable to load notifications'),
                      subtitle: Text(
                        'Please check your Laravel server connection.',
                      ),
                    ),
                  );
                }

                final notifications = snapshot.data ?? [];

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
  }
}

// APPLICATION DETAILS PAGE


class ApplicationDetailsPage extends StatefulWidget {
  final ApiService apiService;
  final int applicationId;

  const ApplicationDetailsPage({
    super.key,
    required this.apiService,
    required this.applicationId,
  });

  @override
  State<ApplicationDetailsPage> createState() =>
      _ApplicationDetailsPageState();
}

class _ApplicationDetailsPageState
    extends State<ApplicationDetailsPage> {
  final Map<int, String> uploadedFiles = {};
  final Map<int, bool> isUploading = {};

  final List<Map<String, dynamic>> requiredDocuments = [
    {
      'id': 1,
      'name': 'Certificate of Registration',
    },
    {
      'id': 2,
      'name': 'Latest Grades',
    },
    {
      'id': 3,
      'name': 'Certificate of Indigency',
    },
    {
      'id': 4,
      'name': 'Parent or Guardian Information',
    },
  ];

  bool isSubmitting = false;

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
        applicationId: widget.applicationId,
        requiredDocumentId: documentId,
        fileName: fileName,
        fileBytes: fileBytes,
      );

      if (!mounted) return;

      setState(() {
        uploadedFiles[documentId] = fileName;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$fileName uploaded successfully.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isUploading[documentId] = false;
        });
      }
    }
  }

  Future<void> submitApplication() async {
    if (uploadedFiles.length != requiredDocuments.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all four required documents.'),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final result = await widget.apiService.submitApplication(
        applicationId: widget.applicationId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'Application submitted successfully.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
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
    final completedCount = uploadedFiles.length;
    final progress = completedCount / requiredDocuments.length;

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
            const Text(
              'Scholarship Application',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Application Number'),
                    subtitle: const Text('TEST-W14-SUBMISSION-001'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    title: Text('Application Status'),
                    subtitle: Text('Draft'),
                    trailing: Chip(label: Text('Draft')),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Required Documents'),
                    subtitle: Text(
                      '$completedCount of ${requiredDocuments.length} uploaded',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Application Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
            ),
            const SizedBox(height: 8),

            Text(
              '$completedCount of ${requiredDocuments.length} requirements completed.',
            ),

            const SizedBox(height: 24),

            const Text(
              'Document Checklist',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            ...requiredDocuments.map((document) {
              final id = document['id'] as int;

              return DocumentItem(
                name: document['name'] as String,
                submitted: uploadedFiles.containsKey(id),
                requiredDocumentId: id,
                isUploading: isUploading[id] ?? false,
                uploadedFileName: uploadedFiles[id],
                onUpload: (fileName, bytes) {
                  uploadDocument(id, fileName, bytes);
                },
              );
            }),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                completedCount == requiredDocuments.length &&
                    !isSubmitting
                    ? submitApplication
                    : null,
                icon: isSubmitting
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.send),
                label: Text(
                  isSubmitting
                      ? 'Submitting...'
                      : 'Submit Application',
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Upload all required documents before submission.',
                textAlign: TextAlign.center,
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
              Icon(
                icon,
                size: 30,
                color: Colors.indigo,
              ),
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

// DOCUMENT ITEM

class DocumentItem extends StatefulWidget {
final String name;
final bool submitted;
final int requiredDocumentId;
final bool isUploading;
final String? uploadedFileName;
final Function(String fileName, Uint8List bytes)? onUpload;

const DocumentItem({
super.key,
required this.name,
required this.submitted,
required this.requiredDocumentId,
this.isUploading = false,
this.uploadedFileName,
this.onUpload,
});

@override
State<DocumentItem> createState() => _DocumentItemState();
}

class _DocumentItemState extends State<DocumentItem> {
  String? selectedFileName;
  Uint8List? selectedFileBytes;
  bool isPicking = false;

  Future<void> pickDocument() async {
    setState(() {
      isPicking = true;
    });

    try {
      final pickedFile = await FilePicker.pickFile();

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        if (!mounted) return;

        setState(() {
          selectedFileName = pickedFile.name;
          selectedFileBytes = bytes;
        });

        widget.onUpload?.call(pickedFile.name, bytes);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to select file: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isPicking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.uploadedFileName ?? selectedFileName;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          widget.submitted
              ? Icons.check_circle
              : Icons.pending_actions,
          color: widget.submitted ? Colors.green : Colors.orange,
        ),
        title: Text(widget.name),
        subtitle: Text(
          widget.isUploading
              ? 'Uploading...'
              : fileName ?? 'No file uploaded',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: ElevatedButton(
          onPressed: widget.isUploading || isPicking
              ? null
              : pickDocument,
          child: widget.isUploading || isPicking
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(fileName != null ? 'Change' : 'Upload'),
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
        leading: const Icon(
          Icons.notifications_outlined,
          color: Colors.indigo,
        ),
        title: Text(title),
        subtitle: Text(message),
      ),
    );
  }
}