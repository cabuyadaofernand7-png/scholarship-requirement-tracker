# Week 13 – Incomplete Application Submission Test

## Test Information

- **Method:** POST
- **Endpoint:** `/api/applications/1/submit`
- **Application ID:** 1
- **Required Documents:** 4
- **Uploaded Documents:** 1

## Expected Result

The backend should reject the submission and identify all missing required documents.

## Actual Result

- Submission was rejected.
- Response: `success: false`
- Message: The application cannot be submitted because required documents are missing.
- Missing documents:
    - Latest Grades
    - Certificate of Indigency
    - Parent or Guardian Information

## Conclusion

The backend correctly prevented an incomplete application from being submitted and returned the names of the missing required documents.

**Test Status:** PASSED