# Evidence Map and Build Traceability

## Tested build

**Commit:** [`f22496da0d1da97a6d8b15aa4d75615e62cb5a26`](https://github.com/cabuyadaofernand7-png/scholarship-requirement-tracker/commit/f22496da0d1da97a6d8b15aa4d75615e62cb5a26)
**Branch:** `main`
**Pushed:** Yes, to `origin/main`.
**Backend regression:** 70 tests / 179 assertions.
**Tag:** No release tag was created.

Week 17 browser screenshots were captured during the November 21–22 controlled working-tree UAT, before the commit. The application source exercised in those sessions is included in the commit. The post-storage-fix backend suite passed before the commit. No Week 18 examination performance has been recorded. On examination day, state the commit and distinguish earlier UAT dates from the live defense date.

## Map from portfolio item to proof

| Portfolio claim | Evidence location | Evidence type | Boundary |
|---|---|---|---|
| Student dashboard and own applications | `week-17/10-evidence-index/evidence/screenshots/W17-E03-01-dashboard.png`; `W17-E03-02-application-details.png` | Browser screenshots | Controlled local account, Nov 21 |
| Program browser and new draft | `W17-UAT-27-open-program-and-requirements.png`; `W17-UAT-27-draft-created.png`; draft-state JSON | Browser + isolated DB assertion | Synthetic open program |
| Already-applied behavior | `W17-UAT-27-program-list-existing-application.png`; UAT-28 row | Browser + scenario result | No duplicate created |
| Staff/reviewer workflow | `W17-UAT-24-*`, `W17-UAT-25-*`, `W17-UAT-26-*` screenshots | Browser evidence | Existing controlled accounts |
| Correction upload/resubmission | `W17-UAT-23-*` screenshots and state JSON | Browser + read-only DB assertion | User-assisted native file picker |
| Outage/recovery | `W17-UAT-20-program-load-backend-unavailable.png`; `...recovered.png` | Browser screenshots | Local API stop/restart |
| Storage failure safe response | UAT-17 initial/retest JSON and focused test output | API + regression test | No browser upload during outage |
| API route and response checks | Week 17 OpenAPI spec, live comparison, authenticated/unauthenticated JSON | Spec + HTTP evidence | Full authenticated schema comparison incomplete |
| Backend regression | `week-17/08-repository-and-maintenance/verification-20261121-role-dashboards/backend-verification-after-storage-fix-20261122.txt` | PHPUnit output | SQLite in-memory, not MariaDB |
| Flutter test/analyze/build | Week 17 frontend verification and test-output evidence | CLI records/screenshots | Prior verified run; fresh CLI attempt stalled Nov 22 |
| Responsive checks | Four UAT-19 screenshots | Browser screenshots | 950×814, 502×814, and zoom stress; not physical phones |
| Architecture and operations | Week 17 architecture comparison, limitations, maintenance plan | Decision records | Provisional; no production operation established |

The canonical filenames and descriptions are in the Week 17 [evidence index](../week-17/10-evidence-index/week-17-evidence-index.md). Resolve evidence filenames relative to that index.
