# Week 13 – Successful Document Upload Test

## Test Information

- **Method:** POST
- **Endpoint:** `/api/applications/1/documents`
- **Application ID:** 1
- **Required Document ID:** 1
- **Test File:** week13_dummy_document.pdf

## Expected Result

Laravel should validate the PDF, store it, save its metadata, and return a successful JSON response.

## Actual Result

- Response message: `Document uploaded successfully.`
- Document ID: 1
- Application ID: 1
- Required Document ID: 1
- Original filename: `week13_dummy_document.pdf`
- MIME type: `application/pdf`
- File size: 26,672 bytes
- Document status: `pending`

## Conclusion

The authenticated document upload request succeeded. Laravel accepted the dummy PDF and returned its document metadata.

**Test Status:** PASSED