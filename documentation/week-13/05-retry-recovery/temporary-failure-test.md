# Week 13 – Temporary Failure Test

## Test Objective
Verify that a temporary notification delivery failure is detected and scheduled for retry.

## Test Data
- Notification ID: 2
- Application ID: 2
- Maximum attempts: 3

## Actual Result
- First attempt: Failed
- Error: Simulated temporary delivery failure.
- Notification status: pending
- Attempts: 1
- Retry delay: 1 minute
- Next retry: Recorded in the database

**Verification Status: PASSED**