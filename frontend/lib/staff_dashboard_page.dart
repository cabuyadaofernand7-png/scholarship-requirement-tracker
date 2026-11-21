import 'package:flutter/material.dart';

import 'login_page.dart';
import 'services/api_service.dart';

class StaffDashboardPage extends StatefulWidget {
  final ApiService apiService;
  final Map<String, dynamic> user;

  const StaffDashboardPage({
    super.key,
    required this.apiService,
    required this.user,
  });

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  late Future<List<dynamic>> applicationsFuture;
  late Future<List<dynamic>> reviewersFuture;
  final Map<int, int?> selectedReviewerIds = {};
  int? assigningApplicationId;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    applicationsFuture = widget.apiService.getStaffApplications();
    reviewersFuture = widget.apiService.getReviewers();
  }

  Future<void> _refresh() async {
    setState(_reload);
    await Future.wait([applicationsFuture, reviewersFuture]);
  }

  Future<void> _assign(int applicationId) async {
    final reviewerId = selectedReviewerIds[applicationId];
    if (reviewerId == null) return;
    setState(() => assigningApplicationId = applicationId);
    try {
      await widget.apiService.assignReviewer(
        applicationId: applicationId,
        reviewerId: reviewerId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reviewer assigned successfully.')),
      );
      setState(_reload);
    } catch (error) {
      if (mounted) _showError(error);
    } finally {
      if (mounted) setState(() => assigningApplicationId = null);
    }
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
    );
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

  List<dynamic> _activeAssignments(Map<String, dynamic> application) {
    final assignments =
        application['review_assignments'] as List<dynamic>? ?? [];
    return assignments.where((assignment) {
      final status = assignment['status'];
      return status == 'pending' || status == 'in_progress';
    }).toList();
  }

  String _statusLabel(String value) => value.replaceAll('_', ' ').toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh applications',
            onPressed: _refresh,
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
                return _MessageState(
                  message: 'Unable to load applications.',
                  onRetry: _refresh,
                );
              }
              final applications = snapshot.data ?? [];
              if (applications.isEmpty) {
                return const Center(child: Text('No applications found.'));
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Welcome, ${widget.user['name'] ?? 'Staff'}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Review submitted applications and assign reviewers.',
                  ),
                  const SizedBox(height: 16),
                  ...applications.map((item) {
                    final application = Map<String, dynamic>.from(item as Map);
                    final id = application['id'] as int;
                    final program =
                        application['scholarship_program'] as Map? ?? {};
                    final student = application['student'] as Map? ?? {};
                    final assignments = _activeAssignments(application);
                    final canAssign =
                        application['status'] == 'submitted' &&
                        assignments.isEmpty;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${application['application_number']} · ${_statusLabel('${application['status']}')}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text('Student: ${student['name'] ?? 'Unknown'}'),
                            Text('Program: ${program['name'] ?? 'Unknown'}'),
                            if (program['academic_year'] != null)
                              Text(
                                'Academic year: ${program['academic_year']}',
                              ),
                            if (assignments.isNotEmpty)
                              Text(
                                'Assigned reviewer: ${assignments.first['reviewer']?['name'] ?? 'Reviewer'}',
                              ),
                            if (canAssign) ...[
                              const SizedBox(height: 12),
                              FutureBuilder<List<dynamic>>(
                                future: reviewersFuture,
                                builder: (context, reviewerSnapshot) {
                                  if (reviewerSnapshot.hasError) {
                                    return const Text(
                                      'Reviewer list is unavailable.',
                                    );
                                  }
                                  if (!reviewerSnapshot.hasData) {
                                    return const LinearProgressIndicator();
                                  }
                                  final reviewers = reviewerSnapshot.data!;
                                  if (reviewers.isEmpty) {
                                    return const Text(
                                      'No reviewer accounts are available.',
                                    );
                                  }
                                  final selected = selectedReviewerIds[id];
                                  return Wrap(
                                    spacing: 12,
                                    runSpacing: 8,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 280,
                                        child: DropdownButtonFormField<int>(
                                          initialValue: selected,
                                          decoration: const InputDecoration(
                                            labelText: 'Select reviewer',
                                            border: OutlineInputBorder(),
                                          ),
                                          items: reviewers.map((reviewer) {
                                            final row = reviewer as Map;
                                            return DropdownMenuItem<int>(
                                              value: row['id'] as int,
                                              child: Text('${row['name']}'),
                                            );
                                          }).toList(),
                                          onChanged: (value) => setState(
                                            () =>
                                                selectedReviewerIds[id] = value,
                                          ),
                                        ),
                                      ),
                                      FilledButton.icon(
                                        onPressed:
                                            assigningApplicationId == id ||
                                                selected == null
                                            ? null
                                            : () => _assign(id),
                                        icon: const Icon(
                                          Icons.person_add_alt_1,
                                        ),
                                        label: Text(
                                          assigningApplicationId == id
                                              ? 'Assigning…'
                                              : 'Assign reviewer',
                                        ),
                                      ),
                                    ],
                                  );
                                },
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

class _MessageState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MessageState({required this.message, required this.onRetry});

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
