# Week 16 Scope and Workload Models

**Project:** Scholarship Requirement Tracker\
**Week:** 16 - Performance Reliability and Deployment Evaluation\
**CLO Alignment:** CLO5 and CLO6\
**Preparation Date:** November 21, 2026\
**Build Reference:** `week-15-hardened-build`\
**Environment:** Local development environment

## 1. Purpose

This document defines the performance evaluation scope, workload assumptions, measurement indicators, and test boundaries for the Scholarship Requirement Tracker. The evaluation will examine the behavior of the existing application under ordinary and simulated peak workloads.

Results will describe only the tested local environment and conditions. They will not be presented as proof of production capacity.

## 2. Evaluation Scope

The evaluation covers the existing bounded scholarship application workflow:

1. Application setup and access.
2. Student document submission.
3. Document validation and storage.
4. Reviewer assignment and access.
5. Application review and status updates.
6. Correction and resubmission behavior.
7. Relevant API, frontend, database, and service-health behavior.

The evaluation will also observe Flutter Web loading, responsive layouts, loading and error states, backend response behavior, and recovery procedures.

## 3. Out-of-Scope Activities

The following are outside this week's evaluation unless separately approved and safely configured:

- Production deployment or claims of production readiness.
- Testing against real student records or confidential scholarship documents.
- Uncontrolled public load testing.
- Large-scale distributed stress testing.
- External penetration testing or independent security certification.
- Real email delivery to unintended recipients.
- Destructive database recovery or migration operations.
- Features outside the existing bounded scholarship workflow.

## 4. Ordinary Workload Model

The ordinary workload represents a small, controlled local demonstration involving normal application activity.

**Proposed test scenario:**

- 1 to 3 concurrent simulated users.
- One user login or authenticated session per test flow.
- Students access application information and submit valid test documents.
- Reviewers access assigned applications and perform permitted review actions.
- Requests are executed in a controlled sequence.
- Test data is synthetic and isolated from real student information.

This model is a proposed evaluation scenario, not a measured user population.

## 5. Peak Workload Model

The peak workload represents a controlled increase in simultaneous activity to observe how the local application responds.

**Proposed test scenario:**

- 5 to 10 concurrent simulated users, only if the local environment can safely support the test.
- Multiple authenticated requests during the same test interval.
- Simulated document-submission and application-status requests using controlled test files and records.
- Gradual increase in concurrency rather than an uncontrolled traffic spike.
- Stop the test if the database, web server, or development machine becomes unstable.

This is a limited local stress scenario. It does not represent a real institution-wide peak or production capacity estimate.

## 6. Performance Indicators

The following indicators will be collected where the available tools permit:

| Indicator | Measurement |
|---|---|
| Response time | Duration of API requests, including average and observed range |
| Throughput | Number of successful requests completed per second or test interval |
| Error rate | Failed requests divided by total requests |
| CPU usage | Process or system CPU observations during testing |
| Memory usage | Process or system memory observations during testing |
| Flutter Web loading | Browser loading behavior and visible completion observations |
| Database behavior | Query or connection errors and observed response issues |
| Recovery behavior | Whether the application returns to a usable state after a controlled failure |

Missing measurements will be recorded as unavailable rather than estimated or invented.

## 7. Test Environment

The evaluation will use the existing local development setup:

- Flutter Web frontend.
- Laravel 13.39.0 backend.
- MySQL/MariaDB database through the configured local test environment.
- Windows development machine.
- Supported desktop browser.
- Synthetic test accounts and test documents.

The exact machine specifications, browser version, database port, application configuration, and test duration will be recorded in the environment and test-result documents before interpreting measurements.

## 8. Proposed Evaluation Criteria

The following are evaluation targets, not previously measured results:

- Required application APIs respond without unexpected server errors during the ordinary workload.
- Valid requests complete successfully.
- Invalid and unauthorized requests remain safely rejected.
- Performance measurements include workload size, environment, and test duration.
- Any increase in response time or errors under the peak scenario is recorded.
- Monitoring and health signals provide useful information about service availability.
- Recovery instructions can be followed without damaging the original database or protected files.
- Flutter Web remains usable at the tested viewport sizes.

No production-readiness conclusion will be made from local measurements alone.

## 9. Limitations

The workload sizes are controlled test assumptions. The local machine, network, browser, database configuration, and development-server settings can affect the results.

The evaluation does not establish how the application would behave under a real institution-wide workload, production hosting conditions, distributed traffic, or long-duration operation.

## 10. Evidence to Be Collected

The following evidence will support this evaluation:

- Workload and test-condition records.
- API response-time and throughput results.
- Error counts and observed failure behavior.
- CPU and memory observations.
- Flutter Web loading and responsive-layout screenshots.
- Environment and configuration comparison.
- Monitoring and health-check results.
- Rollback or recovery rehearsal record.
- Regression test results and final conditional readiness recommendation.
