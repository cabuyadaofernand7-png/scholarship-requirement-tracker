# Week 16 Performance Evidence

**Status:** PARTIALLY COMPLETED — local health-endpoint baseline measured; workload, concurrent-load, frontend, and database performance evaluations remain pending.

## 1. Test identification

| Field | Actual value |
|---|---|
| Test date/time | November 21, 2026, 02:06:58 |
| Build/tag | Working tree at commit `945e04c`; not the `week-15-hardened-build` tag target |
| Commit | `945e04c` |
| Environment | Local Windows development environment |
| Browser | Not used for this HTTP measurement |
| Backend URL | `http://127.0.0.1:8000/up` |
| Database environment/port | Laravel health endpoint test; database performance not measured |
| Test duration | 7.59 seconds |
| Measurement tool | PowerShell `Invoke-WebRequest` and `Stopwatch` |
| PHP version | PHP 8.4.27 CLI |
| Operating system | Microsoft Windows NT 10.0.26300.0 |

## 2. Workload results

| Scenario | Planned workload | Actual workload | Duration | Result |
|---|---:|---:|---|---|
| Sequential health baseline | 30 sequential requests | 30 requests; one at a time | 7.59 seconds | 30 successful responses |
| Ordinary application workload | 1–3 simulated users | Not tested | Pending | Pending |
| Simulated peak workload | Up to 5–10, only if safe | Not tested | Pending | Pending |

The 30 sequential requests are endpoint availability samples, not 30 simulated users.

## 3. Response time

| Request/test | Samples | Minimum | Average | Median | P95 | Maximum | Status |
|---|---:|---:|---:|---:|---:|---:|---|
| `GET /up` Laravel health endpoint | 30 | 180.02 ms | 250.45 ms | 220.80 ms | 432.11 ms | 467.59 ms | 30 HTTP 200 responses |

Measurement method: each request was timed independently using PowerShell `System.Diagnostics.Stopwatch`. Requests were sent sequentially to the local Laravel health endpoint.

The P95 value is the nearest-rank 95th percentile calculated from the sorted 30 response-time samples.

Laravel's health page also displayed a rendered response time of 238 ms during an earlier single successful check. That observation is separate from the 30-request measurement.

## 4. Throughput and errors

| Metric | Result |
|---|---:|
| Total requests | 30 |
| Successful requests | 30 |
| Failed requests | 0 |
| Error rate | 0% |
| Total test duration | 7.59 seconds |
| Successful requests per second | 3.95 |

Formula: error rate = failed requests / total requests × 100.

Throughput represents successful sequential health requests divided by the overall measured test duration. It is not concurrent-user throughput.

An earlier health check failed because the backend was not reachable at that moment. A later check returned HTTP 200. That initial connection failure occurred before this 30-request measurement and is not included in its CSV or 30-request error rate.

## 5. Resource observations

| Resource | Before | After | Tool / interval |
|---|---:|---:|---|
| PHP process count | 2 | 2 | PowerShell `Get-Process` snapshots |
| Combined PHP working set | 79.30 MB | 89.06 MB | PowerShell `Get-Process` snapshots |
| Combined PHP CPU time | 0.71875 seconds | 7.671875 seconds | PowerShell `Get-Process` snapshots |
| Database process | Not measured | Not measured | Pending |

These are combined PHP process snapshots taken immediately before and after the test. They are not isolated per-request resource measurements and do not establish peak CPU or memory use during individual requests.

## 6. Findings

**Observed behavior:**
- All 30 sequential requests to `GET /up` returned HTTP 200.
- No request failures occurred during the recorded 30-request run.
- Average response time was 250.45 ms.
- Maximum observed response time was 467.59 ms.
- PHP process count remained at two in the before/after snapshots.

**Errors or anomalies:**
- One earlier connection attempt failed before the backend became reachable.
- The recorded 30-request run had zero failed requests.
- Response times varied between 180.02 ms and 467.59 ms.

**Changes under simulated peak conditions:** Not tested.

**Evidence filenames:**
- `health-check-20261121-020650.csv`
- `health-check-20261121-020650.md`
- `measure-local-health.ps1`

## 7. Limitations

This evaluation uses a local development environment. Results are affected by the machine, server configuration, local networking, background processes, and test method.

The health endpoint measurement does not establish:
- Concurrent-user capacity or peak-load behavior.
- Database query performance or database resource consumption.
- Full application workflow response times.
- Flutter Web loading or responsive-layout performance.
- Production capacity, institution-wide capacity, or long-duration reliability.

Ordinary and peak workload tests, browser observations, database measurements, and production-environment comparisons remain pending.

No production-readiness claim is made from this baseline measurement.

## 8. Screenshot evidence

- `week-16-performance-test-results.png` — PowerShell output showing the recorded 30-request sequential health-check results.
- Location: `documentation/week-16/03-performance-evidence/`
- Screenshot supports the existing CSV and measurement report; it does not represent a separate test run.
- File existence and nonzero size verified on November 21, 2026.
