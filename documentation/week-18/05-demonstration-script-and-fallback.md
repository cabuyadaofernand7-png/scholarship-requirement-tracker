# Demonstration Script and Fallback

## Eight-minute walkthrough

### Before the examiner arrives

- Verify commit `f22496da0d1da97a6d8b15aa4d75615e62cb5a26` on `main`.
- Confirm the API uses the isolated UAT database, not a production or recovery database. Do not run `migrate:fresh`, seeders, or resets.
- Start Laravel and Flutter from the repository README. Confirm the API and Flutter page load before signing in.
- Use the controlled student account. Never put a password or bearer token in slides, screenshots, logs, or chat.
- Confirm the synthetic open program and draft with four required documents still exist. If not, use saved UAT-27 evidence instead of creating data under exam pressure.
- Keep an approved, non-confidential sample PDF ready.

### Talk track

| Time | Action | Explain |
|---|---|---|
| 0:00–0:40 | State project goal, scope, commit, and local environment | Bounded academic prototype; no production deployment claim |
| 0:40–1:40 | Show student dashboard and application list | API returns only the authenticated student's records |
| 1:40–3:00 | Open New Application and inspect program requirements | Programs are filtered by active state and dates; show types and size |
| 3:00–4:30 | Open the prepared draft; demonstrate sample upload if picker works | Show loading/success and requirement checklist |
| 4:30–5:10 | Submit only if all required test documents are present | Show validation; use API UAT-07 as missing-document fallback |
| 5:10–6:35 | Show saved staff assignment/reviewer workflow evidence | Explain role gate, assignment, authorized download, and status history |
| 6:35–7:20 | Show safe backend outage and recovery evidence | UI Retry recovered after restart; storage outage returned generic 503 |
| 7:20–8:00 | Present test/UAT counts and limitations | 70 backend tests/179 assertions; 28 UAT scenarios; state device/schema limits |

Do not move an application to an unintended final state. Use only named isolated UAT data for demonstration mutations. Do not delete or reset data during the examination.

## Fallback path

If the backend or browser fails:

1. State the exact failure and environment; do not describe a screenshot as a live run.
2. Use UAT-27 screenshots and its state record for program discovery and draft creation.
3. Use UAT-20 screenshots for safe failure and retry recovery.
4. Use UAT-17 JSON and regression output for the HTTP 503 storage path.
5. Use UAT-23 screenshots and state record for correction upload/resubmission; explain native file selection was user-assisted.
6. Open the scenario catalogue and evidence index so each claim is traceable.

The fallback evidence is genuine and dated November 21–22, 2026. It is not a recording of the December 5 examination. Capture new live screenshots only during the exam and record their real timestamp and tested commit.
