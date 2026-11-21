# Security Deployment and Maintenance Evaluation

## Implemented controls evidenced in the project

- Registration hashes passwords with Laravel `Hash::make`; login checks with `Hash::check`. Sanctum issues bearer tokens, and logout deletes the current token.
- Protected routes use `auth:sanctum`; controllers check roles, ownership, reviewer assignment, and application-state rules.
- Students cannot access other students' application data. Staff-only routes and assignment-based reviewer downloads have API/browser evidence.
- Uploaded files are validated against configured types and size. Files use the Laravel local disk and a permission-checked download controller.
- A storage exception is reported server-side while the client receives a generic 503. The regression test verifies no document row is created on that exception path.
- Recorded UAT used controlled accounts and sample data. A targeted scan found no high-confidence credential patterns in staged Week 17 material.

## Controls not established for production

| Area | Current evidence | Production work still required |
|---|---|---|
| Transport | Local HTTP used during UAT | HTTPS certificates, secure headers, browser-origin/CORS policy |
| Secret management | Local `.env` ignored from Git; developer config has no credentials | Production secret manager, rotation, access control, protected backups |
| Passwords/tokens | Laravel hashing and Sanctum token lifecycle in source | Rate limits, token-expiry/revocation review, monitoring, browser threat review |
| Document privacy | Local private disk and authorized download path | Verify storage access controls, encryption at rest, backup encryption, retention/purge |
| Database | MariaDB isolated UAT; tests use SQLite memory | Production isolation, least privilege, backups, restore tests |
| Automation | Authenticated deadline/missing-document endpoints and API deduplication evidence | Scheduler/cron, monitored jobs, delivery/retry policy; no production schedule demonstrated |
| Logging | Laravel reports storage exception and logs deadline check | Retention, redaction, access, alerting, incident response |
| Availability/recovery | Browser retry after local API outage; storage 503 retest | Monitoring, tested backups, RPO/RTO, rollback and recovery exercises |
| Performance | No load or comparative benchmark recorded | Define representative load, measure latency/resources, set thresholds |

## Deployment recommendation

Do not deploy this local prototype to production. A future deployment needs approved hosting; separate frontend/API/database configuration; HTTPS; managed secrets; private durable file storage; database and file backups with successful restore evidence; monitoring and named owners; and a reviewed rollback process. Approve deployment only after security, UAT, privacy, and operational acceptance are recorded.

## Maintenance cycle

For each change, review the diff, run focused tests and relevant regression, run Flutter tests/analyze/build, verify OpenAPI changes, test role boundaries, and update the evidence index. Before release, check secrets, environment-specific configuration, migrations, backup/restore, storage access, rollback, and maintenance ownership. The Week 17 maintenance plan is proposed guidance, not evidence of an operating support service.
