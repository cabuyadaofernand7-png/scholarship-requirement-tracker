# Week 13 – Submission Status Verification

## Test Information

- **Application ID:** 1
- **Test:** Verify application status after an incomplete submission attempt.

## Expected Result

The application should remain in Draft status, and its submission timestamp should remain empty.

## Actual Result

```text
id: 1
status: draft
submitted_at: null
```

## Conclusion

The database confirmed that the incomplete submission attempt did not change the application's status or set a submission timestamp.

**Test Status:** PASSED