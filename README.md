# Scholarship Requirement Tracker

**IT Free Elective final project**

A Flutter Web client and Laravel REST API for a scholarship application workflow. Students can browse open programs, create and manage applications, upload required documents, and submit them for review. Staff can view applications and assign reviewers. Reviewers can access assigned applications, download documents, and record review outcomes.

This repository contains an academic prototype and its development, testing, UAT, and defense records. It is not approved or configured for production deployment.

## Project layout

| Path | Contents |
|---|---|
| `backend/` | Laravel API, database migrations, authorization, document handling, automation, and backend tests |
| `frontend/` | Flutter Web application for student, staff, and reviewer workflows |
| `documentation/` | Weekly plans, design decisions, test records, UAT evidence, known limitations, and final portfolio |
| `database/` | Database notes and supporting files |

## Technology

- **Frontend:** Flutter Web, Dart, `http`, and `file_picker`
- **Backend:** PHP 8.3+, Laravel 13, Laravel Sanctum, and PHPUnit
- **Database:** MySQL/MariaDB for local integration; PHPUnit tests use an in-memory SQLite database
- **File storage:** Laravel local private storage in the documented local configuration

## Local development setup

Run the API and Flutter client in separate terminals. The Flutter API client currently targets `http://127.0.0.1:8000/api`; keep the backend on that address and port unless you also change `frontend/lib/services/api_service.dart`.

### 1. Configure and start the backend

Requirements: PHP 8.3 or newer, Composer, and a running MySQL or MariaDB server. Create an empty local database (the example name is `scholarship_requirement_tracker`). From the repository root, run in PowerShell:

```powershell
Set-Location backend
composer install
Copy-Item .env.example .env
```

Edit `backend/.env` with the local database name, username, and password. Then run:

```powershell
php artisan key:generate
php artisan migrate --seed
php artisan serve --host=127.0.0.1 --port=8000
```

The seeder creates role records; it does not create ready-to-use student, staff, or reviewer accounts. Use approved local test accounts and never put passwords or tokens in source control or documentation.

### 2. Start the Flutter Web client

In another terminal, from the repository root:

```powershell
Set-Location frontend
flutter pub get
flutter run -d edge
```

If Edge is unavailable as a Flutter device, run `flutter devices` and choose a supported browser device. Sign in with an account for the role you want to demonstrate.

## Useful checks

Run backend tests from `backend/`:

```powershell
php artisan test
```

Run Flutter checks from `frontend/`:

```powershell
flutter test
flutter analyze
flutter build web --release
```

The recorded Week 17 backend result was **70 tests and 179 assertions passed**. Week 17 Flutter test, analysis, and release-build evidence is documented in the portfolio. These historical results describe the recorded build; they do not guarantee a fresh run on every machine.

## API and workflow reference

The API uses Sanctum bearer tokens for protected routes. Its documented operations include authentication, student program and application workflows, document upload and authorized download, staff queues and reviewer assignment, reviewer queues and status updates, notifications, and deadline checks.

- OpenAPI specification: [`documentation/week-17/07-openapi-documentation/openapi.yaml`](documentation/week-17/07-openapi-documentation/openapi.yaml)
- Week 17 API review and live comparison: [`documentation/week-17/07-openapi-documentation/`](documentation/week-17/07-openapi-documentation/)
- Backend route definitions: [`backend/routes/api.php`](backend/routes/api.php)

The Flutter client currently has a fixed localhost API address. Configure that address for any other environment before use. The OpenAPI review notes document remaining authenticated response-schema comparison work.

## Security and data handling

- Use synthetic or explicitly approved data in development and demonstrations.
- Keep `.env`, credentials, tokens, and private keys out of Git.
- Do not expose uploaded documents through a public web directory. The documented local setup uses Laravel local storage and is not a highly available storage service.
- Authentication and role checks protect the API workflows; local prototype evidence does not establish production security readiness.
- Do not run destructive migration commands against a database that contains data you need. `php artisan migrate:fresh` deletes existing tables and data.

## Documentation and evidence

The [Week 17 portfolio](documentation/week-17/README.md) contains the UAT plan and results, API specification, architecture comparison, repository checks, evidence index, and known limitations. The [Week 18 portfolio](documentation/week-18/README.md) contains the final-exam overview, workflow and architecture summary, evidence map, demonstration plan, maintenance evaluation, contribution reflection draft, checklist, and viva questions.

Screenshots and test-output files are evidence for the specific builds and environments recorded with them. Review each evidence index for dates, scope, and limitations before relying on a result.

## Known limitations

- The API address is fixed to localhost in the Flutter client.
- Local file storage and the basic health endpoint are not production-grade availability or monitoring solutions.
- Production deployment, load capacity, backup and restore procedures, operational monitoring, and a maintenance team have not been established.
- Responsive evidence covers recorded browser-window sizes; it does not establish compatibility with all devices or browsers.
- Passing automated tests and UAT does not authorize production deployment.

See [`documentation/week-17/09-known-limitations-and-final-recommendation/known-limitations.md`](documentation/week-17/09-known-limitations-and-final-recommendation/known-limitations.md) for the detailed evidence boundaries and recommended next work.

## License

No project-specific license has been declared. Do not assume this repository is licensed for reuse or redistribution.
