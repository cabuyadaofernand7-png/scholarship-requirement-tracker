import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'services/api_service.dart';

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
      home: const DashboardPage(),
    );
  }
}

// DASHBOARD PAGE

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              child: Icon(Icons.person),
            ),
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
                      builder: (context) =>
                      const ApplicationDetailsPage(),
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
              future: ApiService().getNotifications(),
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

class ApplicationDetailsPage extends StatelessWidget {
  const ApplicationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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

            const Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Application Number'),
                    subtitle: Text('SAMPLE-2026-001'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('Application Status'),
                    subtitle: Text('Draft'),
                    trailing: Chip(
                      label: Text('Draft'),
                    ),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('Required Documents'),
                    subtitle: Text('2 submitted, 2 missing'),
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

            const LinearProgressIndicator(
              value: 0.5,
              minHeight: 8,
            ),

            const SizedBox(height: 8),

            const Text(
              '2 of 4 sample requirements completed.',
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.send),
                label: const Text('Submit Application'),
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Complete all required documents before submission.',
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
// DOCUMENT ITEM

class DocumentItem extends StatefulWidget {
  final String name;
  final bool submitted;
  final int requiredDocumentId;

  const DocumentItem({
    super.key,
    required this.name,
    required this.submitted,
    required this.requiredDocumentId,
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

        setState(() {
          selectedFileName = pickedFile.name;
          selectedFileBytes = bytes;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pickedFile.name} selected successfully.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to select file: $e'),
        ),
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
    final bool isSelected =
        selectedFileName != null && selectedFileBytes != null;

    final Color statusColor = widget.submitted
        ? Colors.green
        : isSelected
        ? Colors.blue
        : Colors.orange;

    final IconData statusIcon = widget.submitted
        ? Icons.check_circle
        : isSelected
        ? Icons.attach_file
        : Icons.pending_actions;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          statusIcon,
          color: statusColor,
        ),
        title: Text(widget.name),
        subtitle: isSelected
            ? Text(
          selectedFileName!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
            : Text(
          widget.submitted
              ? 'Previously submitted'
              : 'No file selected',
        ),
        trailing: ElevatedButton(
          onPressed: isPicking ? null : pickDocument,
          child: isPicking
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
              : Text(isSelected ? 'Change' : 'Upload'),
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