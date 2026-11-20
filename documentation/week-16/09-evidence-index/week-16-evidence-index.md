# Week 16 Evidence Index

**Project:** Scholarship Requirement Tracker\
**Week:** 16 — Performance, Reliability and Deployment Evaluation\
**Preparation date:** November 21, 2026\
**Reference build:** `week-15-hardened-build`\
**Working-tree test commit:** `945e04c`

## 1. Evidence inventory

| No. | Deliverable | Evidence file | Status |
|---|---|---|---|
| 1 | Scope and workload models | `01-scope-and-workload-models/week-16-scope-and-workload-models.md` | Documented |
| 2 | Design and test conditions | `02-design-and-test-conditions/` | Pending |
| 3 | Performance baseline | `03-performance-evidence/week-16-performance-results.md` | Partial — local health endpoint |
| 4 | Performance measurement script | `03-performance-evidence/measure-local-health.ps1` | Created |
| 5 | Performance CSV | `03-performance-evidence/health-check-20261121-020650.csv` | Recorded |
| 6 | Performance measurement report | `03-performance-evidence/health-check-20261121-020650.md` | Recorded |
| 7 | Flutter Web observations | `04-flutter-web-observations/week-16-flutter-web-observations.md` | Partial — login screen with desktop and mobile screenshots |
| 8 | Desktop login screenshot | `04-flutter-web-observations/week-16-login-desktop.png` | Captured and file verified |
| 9 | Mobile login screenshot | `04-flutter-web-observations/week-16-login-mobile.png` | Captured and file verified |
| 10 | Environment comparison | `05-environment-and-configuration/week-16-environment-comparison.md` | Partial — local environment |
| 11 | Monitoring and health checks | `06-monitoring-and-health-checks/week-16-monitoring-and-health-evidence.md` | Partial — Laravel health endpoint |
| 12 | Rollback and recovery | `07-rollback-and-recovery/week-16-rollback-and-recovery-plan.md` | Plan documented; application rollback rehearsal pending |
| 13 | Regression and deployment evidence | `08-regression-and-deployment-evidence/` | Pending |
| 14 | Weekly summary | `10-weekly-summary/week-16-weekly-summary.md` | Pending |

## 2. Supporting prior-week evidence

The following earlier evidence may support Week 16 context but must not be represented as newly performed Week 16 tests:

- Week 15 backend regression: 54 tests passed, 114 assertions.
- Week 15 Flutter analysis, widget test, and Web production build results.
- Week 15 security and adverse-case test records.
- Week 15 hardened build tag: `week-15-hardened-build`.

## 3. Verified Week 16 observations

### Local health endpoint
- 30 sequential requests to `GET /up`.
- 30 HTTP 200 responses.
- Average response time: 250.45 ms.
- P95 response time: 432.11 ms.
- Maximum response time: 467.59 ms.
- Error rate: 0%.
- Successful sequential throughput: 3.95 requests per second.

### Flutter Web
- Microsoft Edge launch succeeded.
- Login screen loaded.
- Desktop layout appeared correct during manual inspection.
- Mobile-emulated layout appeared correct at approximately 390 × 844.
- Desktop screenshot: `04-flutter-web-observations/week-16-login-desktop.png`.
- Mobile screenshot: `04-flutter-web-observations/week-16-login-mobile.png`.
- Both screenshot files were verified to exist and have nonzero file sizes.
- Other screens and authenticated workflows were not covered by this observation.

### Environment
- Flutter 3.47.8 stable.
- Laravel 13.39.0.
- PHP 8.4.27.
- Local database configured on port `3308`.
- No staging or production environment was inspected.

### Health signal
- Laravel `GET /up` route exists.
- Current check returned HTTP 200.
- Continuous monitoring and database health monitoring were not established.

## 4. Outstanding evidence

- Ordinary workload test using the application workflow.
- Safe peak/concurrent workload evaluation, if appropriate.
- Database performance measurements.
- Broader Flutter Web loading and responsive checks beyond the login screen.
- Staging/production environment comparison, if those environments become available.
- Monitoring beyond the basic Laravel health endpoint.
- Application deployment rollback rehearsal.
- Regression and deployment evidence for the Week 16 tested build.

## 5. Evidence integrity rules

- Preserve original logs, CSV files, screenshots, and test reports.
- Identify the exact commit and environment used for each test.
- Do not claim local measurements establish production capacity.
- Do not present prior-week test results as new Week 16 test results.
- Do not fabricate missing screenshots, measurements, or deployment results.
- Keep credentials, tokens, and private configuration out of the repository.

## 6. Overall evidence status

Week 16 evidence is partially complete. A local health-endpoint baseline, basic login-screen observations with desktop and mobile screenshots, environment inspection, health-route check, and recovery plan have been recorded. Further workload, database, monitoring, rollback, and deployment evidence remains outstanding.

## 7. Additional screenshot evidence

| No. | Screenshot | Location | Verification |
|---|---|---|---|
| 15 | `week-16-health-endpoint.png` | `06-monitoring-and-health-checks/` | Captured; file existence and nonzero size verified |
| 16 | `week-16-performance-test-results.png` | `03-performance-evidence/` | Captured; file existence and nonzero size verified |

Both screenshots were captured on November 21, 2026. The performance screenshot documents the existing 30-request CSV/report results; it is not a separate performance test.
