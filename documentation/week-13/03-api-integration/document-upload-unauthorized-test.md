# Week 13 – Document Upload Unauthorized Test

## Test Information

- **Method:** POST
- **Endpoint:** `/api/applications/1/documents`
- **Environment:** Local Laravel development server
- **Authentication:** No authentication credentials provided

## Expected Result

The API should reject the request because the document upload endpoint requires authentication.

## Actual Result

- Request was rejected.
- HTTP status: `401 Unauthorized`
- Error message: `The remote server returned an error: (401) Unauthorized.`
- No document was uploaded.

## Conclusion

The document upload endpoint correctly rejected an unauthenticated request through Laravel's Sanctum authentication middleware.

**Test Status:** PASSED