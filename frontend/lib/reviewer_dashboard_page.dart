import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';
import 'services/api_service.dart';

class ReviewerDashboardPage extends StatefulWidget {
  final ApiService apiService;
  final Map<String, dynamic> user;

  const ReviewerDashboardPage({
    super.key,
    required this.apiService,
    required this.user,
  });

  @override
  State<ReviewerDashboardPage> createState() => _ReviewerDashboardPageState();
}

class _ReviewerDashboardPageState extends State<ReviewerDashboardPage> {
  late Future<List<dynamic>> applicationsFuture;
  final Map<int, String?> selectedStatuses = {};
  int? updatingApplicationId;
  int? downloadingDocumentId;

  @override
  void initState() {
    super.initState();
    applicationsFuture = widget.apiService.getReviewerApplications();
  }

  void _reload() {
    setState(
      () => applicationsFuture = widget.apiService.getReviewerApplications(),
    );
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
    );
  }

  Future<void> _updateStatus(int id, String status) async {
    setState(() => updatingApplicationId = id);
    try {
      await widget.apiService.updateApplicationStatus(
        applicationId: id,
        status: status,
      );
      if (!mounted) return;
      selectedStatuses.remove(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application status updated.')),
      );
      _reload();
    } catch (error) {
      if (mounted) _showError(error);
    } finally {
      if (mounted) setState(() => updatingApplicationId = null);
    }
  }

  Future<void> _download(Map<String, dynamic> document) async {
    final id = document['id'] as int;
    setState(() => downloadingDocumentId = id);
    try {
      final bytes = await widget.apiService.downloadDocument(id);
      final filename =
          '${document['original_filename'] ?? 'application-document'}'
              .split(RegExp(r'[/\\]'))
              .last;
      await FilePicker.saveFile(
        fileName: filename,
        bytes: bytes,
        mimeType: '${document['mime_type'] ?? 'application/octet-stream'}',
      );
    } catch (error) {
      if (mounted) _showError(error);
    } finally {
      if (mounted) setState(() => downloadingDocumentId = null);
    }
  }

  Future<void> _logout() async {
    await widget.apiService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginPage(apiService: widget.apiService),
      ),
      (_) => false,
    );
  }

  List<String> _nextStatuses(String current) {
    if (current == 'submitted') return ['under_review'];
    if (current == 'under_review') {
      return ['incomplete', 'for_correction', 'approved', 'rejected'];
    }
    return [];
  }

  String _label(String value) => value.replaceAll('_', ' ').toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviewer Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh assigned applications',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Log out',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: FutureBuilder<List<dynamic>>(
            future: applicationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _ReviewerMessage(
                  message: 'Unable to load assigned applications.',
                  onRetry: _reload,
                );
              }
              final applications = snapshot.data ?? [];
              if (applications.isEmpty) {
                return const Center(
                  child: Text('No applications are currently assigned to you.'),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Welcome, ${widget.user['name'] ?? 'Reviewer'}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  const Text('Only your active review assignments are shown.'),
                  const SizedBox(height: 16),
                  ...applications.map((item) {
                    final application = Map<String, dynamic>.from(item as Map);
                    final id = application['id'] as int;
                    final status = '${application['status']}';
                    final program =
                        application['scholarship_program'] as Map? ?? {};
                    final student = application['student'] as Map? ?? {};
                    final documents =
                        application['documents'] as List<dynamic>? ?? [];
                    final allowedStatuses = _nextStatuses(status);
                    final selectedStatus = selectedStatuses[id];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${application['application_number']} · ${_label(status)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text('Student: ${student['name'] ?? 'Unknown'}'),
                            Text('Program: ${program['name'] ?? 'Unknown'}'),
                            const SizedBox(height: 12),
                            Text(
                              'Submitted documents (${documents.length})',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (documents.isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text('No documents have been uploaded.'),
                              ),
                            ...documents.map((item) {
                              final document = Map<String, dynamic>.from(
                                item as Map,
                              );
                              final requiredDocument =
                                  document['required_document'] as Map? ?? {};
                              final documentId = document['id'] as int;
                              final documentStatus =
                                  '${document['status'] ?? 'submitted'}';
                              final feedback = document['feedback'];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.description_outlined),
                                title: Text(
                                  '${document['original_filename'] ?? requiredDocument['document_name'] ?? 'Uploaded document'}',
                                ),
                                subtitle: Text(
                                  '${requiredDocument['document_name'] ?? 'Document'} · ${_label(documentStatus)}'
                                  '${feedback == null ? '' : '\n$feedback'}',
                                ),
                                isThreeLine: feedback != null,
                                trailing: IconButton(
                                  tooltip: 'Download document',
                                  onPressed: downloadingDocumentId == documentId
                                      ? null
                                      : () => _download(document),
                                  icon: downloadingDocumentId == documentId
                                      ? const SizedBox.square(
                                          dimension: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.download),
                                ),
                              );
                            }),
                            if (allowedStatuses.isNotEmpty) ...[
                              const Divider(),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: DropdownButtonFormField<String>(
                                      initialValue: selectedStatus,
                                      decoration: const InputDecoration(
                                        labelText: 'Next review status',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: allowedStatuses
                                          .map(
                                            (value) => DropdownMenuItem(
                                              value: value,
                                              child: Text(_label(value)),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) => setState(
                                        () => selectedStatuses[id] = value,
                                      ),
                                    ),
                                  ),
                                  FilledButton.icon(
                                    onPressed:
                                        selectedStatus == null ||
                                            updatingApplicationId == id
                                        ? null
                                        : () =>
                                              _updateStatus(id, selectedStatus),
                                    icon: const Icon(Icons.fact_check_outlined),
                                    label: Text(
                                      updatingApplicationId == id
                                          ? 'Saving…'
                                          : 'Update status',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ReviewerMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ReviewerMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
