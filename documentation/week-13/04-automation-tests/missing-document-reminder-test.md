# Week 13 – Missing Document Reminder Test

## Test Information

- **Application ID:** 2
- **Endpoint:** `POST /api/applications/2/check-missing-documents`
- **HTTP Status:** 200 OK

## Expected Result

The system should identify all missing required documents and create an in-app reminder.

## Actual Result

- API request successful.
- Four missing documents identified.
- `reminder_created` returned `true`.
- An in-app reminder was created.

## Missing Documents

1. Certificate of Registration
2. Latest Grades
3. Certificate of Indigency
4. Parent or Guardian Information

## Conclusion

The automation correctly identified missing requirements and created a reminder notification for the test application.

**Test Status:** PASSED