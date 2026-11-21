# Maintenance Plan

## 1. Purpose and current status

This document defines a proposed maintenance approach for the Scholarship Requirement Tracker prototype. It describes activities that should be performed during development and activities that would be needed before operational deployment.

This is a proposed plan, not evidence that a production support team, automated monitoring service, scheduled backup process, or service-level agreement is currently operating.

## 2. Routine maintenance

| Frequency / trigger | Activity | Evidence |
|---|---|---|
| Every code change | Run targeted tests and inspect the affected source changes | Test output and reviewed Git diff |
| Before each weekly submission | Run backend tests, Flutter analysis, Flutter tests, and release build as applicable | Weekly verification record |
| Before dependency updates | Review release notes, compatibility, and security impact; update in a controlled change | Dependency update record |
| Regularly during development | Review Laravel logs and investigate failed requests | Sanitized log review |
| Before database recovery exercises | Confirm the target is an isolated disposable database | Restore-test record |
| Before deployment | Review HTTPS, secrets, storage permissions, CORS, database credentials, and monitoring | Deployment checklist |
| After a defect fix | Retest the affected workflow and relevant regression tests | Fix-and-retest record |
| Before a release | Review Git status, staged and unstaged changes, secrets, and generated files | Release review record |

## 3. Data protection and access control

- Use private document storage and least-privilege access.
- Restrict document downloads to authorized staff and actively assigned reviewers.
- Verify that students can access only their own application records and notifications.
- Use synthetic data in development and UAT. Do not use real student records or confidential documents in screenshots.
- Keep credentials, API tokens, and environment-specific secrets out of source control.
- Define a retention and deletion policy before real institutional use.
- Encrypt backups and restrict access to backup files in any operational deployment.
- Review authorization rules whenever routes, roles, or document access logic change.

## 4. Database backup and recovery

### 4.1 Proposed backup approach

Before operational deployment, the responsible team should define:

- Backup frequency and retention period
- Backup ownership and access permissions
- Encryption and secure storage location
- Recovery point objective (RPO)
- Recovery time objective (RTO)
- Backup verification and restore-test schedule

No production backup schedule or production recovery objective has been established by the current prototype work.

### 4.2 Recovery-test safety requirements

- Preserve the original MariaDB data directory.
- Preserve the pristine recovery snapshot without modifying it.
- Conduct restore rehearsals only against an isolated disposable database instance.
- Do not use destructive migration or database reset commands against the original database or pristine snapshot.
- Record the source backup, target environment, recovery date, validation checks, and result.
- Verify application connectivity and expected test data after restoration.

### 4.3 Application rollback

- Preserve reviewed, known-good application commits or release tags.
- Review database schema compatibility before rolling back application code.
- Treat application rollback and database restoration as separate procedures.
- Record the reason for rollback, affected version, recovery actions, and verification result.

## 5. Operational monitoring

The current Laravel implementation exposes the `/up` health endpoint. A successful response from this endpoint alone does not prove database connectivity, document-storage availability, queue health, notification delivery, or continuous service availability.

A future operational deployment should define monitoring for:

- Application and API availability
- Database connectivity and errors
- Document storage capacity and access failures
- Queue and scheduled-task execution, where used
- Notification delivery and repeated failures
- Authentication and authorization errors
- Application exceptions and relevant security events

Monitoring thresholds, alert recipients, escalation procedures, and support coverage remain to be assigned.

## 6. Maintenance responsibilities

| Area | Responsible person / team | Contact / escalation |
|---|---|---|
| Frontend | To be assigned | To be defined |
| Backend and API | To be assigned | To be defined |
| Database and backup | To be assigned | To be defined |
| Security and access control | To be assigned | To be defined |
| UAT and acceptance | To be assigned | To be defined |
| Deployment and monitoring | To be assigned | To be defined |

Responsibilities must be assigned and approved before operational use.

## 7. Maintenance records

The team should retain the following records:

- Change and release history
- Backend and frontend test results
- Dependency update records
- Defect reports and fix/retest evidence
- Sanitized error and monitoring reviews
- Backup and restore-test records
- Access-control and security reviews
- Deployment and rollback records
- UAT observations and acceptance decisions

Records must not contain passwords, bearer tokens, private keys, or unnecessary confidential student information.

## 8. Current limitations and outstanding work

The current project is a local prototype. The following operational capabilities are not established by the Week 17 evidence:

- No production backup schedule or retention policy
- No demonstrated production restore procedure
- No assigned production maintenance or escalation team
- No established RPO or RTO
- No demonstrated continuous monitoring or automated alerting
- No production service-level objectives
- No production deployment approval

These items require institutional decisions, assigned owners, and implementation evidence before the system can be treated as an operational production service.
