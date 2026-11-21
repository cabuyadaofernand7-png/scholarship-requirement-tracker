import 'package:flutter/material.dart';

import 'services/api_service.dart';

class NewApplicationPage extends StatefulWidget {
  final ApiService apiService;

  const NewApplicationPage({super.key, required this.apiService});

  @override
  State<NewApplicationPage> createState() => _NewApplicationPageState();
}

class _NewApplicationPageState extends State<NewApplicationPage> {
  late Future<List<dynamic>> programsFuture;
  int? creatingProgramId;

  @override
  void initState() {
    super.initState();
    programsFuture = widget.apiService.getScholarshipPrograms();
  }

  void _reload() {
    setState(() => programsFuture = widget.apiService.getScholarshipPrograms());
  }

  Future<void> _createApplication(int programId) async {
    setState(() => creatingProgramId = programId);
    try {
      final result = await widget.apiService.createApplication(
        scholarshipProgramId: programId,
      );
      if (!mounted) return;
      final application = result['application'] as Map<String, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Draft ${application['application_number']} created. Add documents from your dashboard.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
      _reload();
    } finally {
      if (mounted) setState(() => creatingProgramId = null);
    }
  }

  String _dateLabel(dynamic value) {
    if (value == null || '$value'.isEmpty) return 'No date limit';
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Scholarship Application'),
        actions: [
          IconButton(
            tooltip: 'Refresh programs',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: FutureBuilder<List<dynamic>>(
            future: programsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _ProgramMessage(
                  message: 'Unable to load open scholarship programs.',
                  onRetry: _reload,
                );
              }
              final programs = snapshot.data ?? [];
              if (programs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'There are no scholarship programs accepting applications right now.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Available Programs',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Review each program and its required documents before creating a draft.',
                  ),
                  const SizedBox(height: 16),
                  ...programs.map((rawProgram) {
                    final program = Map<String, dynamic>.from(
                      rawProgram as Map,
                    );
                    final id = program['id'] as int;
                    final documents =
                        program['required_documents'] as List<dynamic>? ?? [];
                    final existingApplication = program['application'] as Map?;
                    final alreadyApplied = program['has_applied'] == true;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${program['name'] ?? 'Scholarship Program'}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (program['academic_year'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Academic year: ${program['academic_year']}',
                                ),
                              ),
                            if (program['description'] != null &&
                                '${program['description']}'.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('${program['description']}'),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Application deadline: ${_dateLabel(program['application_deadline'])}',
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Required documents',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (documents.isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Text(
                                  'No additional documents are listed.',
                                ),
                              ),
                            ...documents.map((rawDocument) {
                              final document = Map<String, dynamic>.from(
                                rawDocument as Map,
                              );
                              final isRequired =
                                  document['is_required'] == true;
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  isRequired
                                      ? Icons.checklist
                                      : Icons.description_outlined,
                                ),
                                title: Text(
                                  '${document['document_name'] ?? 'Document'}${isRequired ? ' (required)' : ' (optional)'}',
                                ),
                                subtitle: Text(
                                  [
                                    if (document['description'] != null &&
                                        '${document['description']}'.isNotEmpty)
                                      '${document['description']}',
                                    if (document['allowed_file_types'] != null)
                                      'Types: ${document['allowed_file_types']}',
                                    if (document['max_file_size_kb'] != null)
                                      'Maximum size: ${document['max_file_size_kb']} KB',
                                  ].join(' · '),
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            if (alreadyApplied)
                              Chip(
                                avatar: const Icon(Icons.check_circle_outline),
                                label: Text(
                                  'Already applied${existingApplication?['status'] == null ? '' : ' · ${existingApplication?['status']}'}',
                                ),
                              )
                            else
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FilledButton.icon(
                                  onPressed: creatingProgramId == id
                                      ? null
                                      : () => _createApplication(id),
                                  icon: creatingProgramId == id
                                      ? const SizedBox.square(
                                          dimension: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.add),
                                  label: Text(
                                    creatingProgramId == id
                                        ? 'Creating draft…'
                                        : 'Create draft application',
                                  ),
                                ),
                              ),
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

class _ProgramMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProgramMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
