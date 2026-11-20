param(
    [int]$RequestCount = 30,
    [string]$Url = "http://127.0.0.1:8000/up"
)

$ErrorActionPreference = "Stop"
$folder = $PSScriptRoot
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$csvPath = Join-Path $folder "health-check-$timestamp.csv"
$reportPath = Join-Path $folder "health-check-$timestamp.md"

$results = [System.Collections.Generic.List[object]]::new()
$overall = [System.Diagnostics.Stopwatch]::StartNew()

$phpBefore = @(Get-Process -Name php -ErrorAction SilentlyContinue)
$phpCpuBefore = ($phpBefore | Measure-Object -Property CPU -Sum).Sum
$phpMemoryBefore = ($phpBefore | Measure-Object -Property WorkingSet64 -Sum).Sum

Write-Host "Testing $Url"
Write-Host "Requests: $RequestCount"
Write-Host ""

for ($i = 1; $i -le $RequestCount; $i++) {
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $status = 0
    $errorMessage = ""

    try {
        $response = Invoke-WebRequest -Uri $Url -Method GET -UseBasicParsing -TimeoutSec 10
        $status = [int]$response.StatusCode
    }
    catch {
        $errorMessage = $_.Exception.Message
    }

    $timer.Stop()

    $results.Add([PSCustomObject]@{
        RequestNumber = $i
        StatusCode    = $status
        ResponseMs    = [math]::Round($timer.Elapsed.TotalMilliseconds, 2)
        Success       = ($status -ge 200 -and $status -lt 400)
        Error         = $errorMessage
    })

    Write-Host ("Request {0}/{1}: HTTP {2}, {3} ms" -f `
        $i, $RequestCount, $status, [math]::Round($timer.Elapsed.TotalMilliseconds, 2))
}

$overall.Stop()

$phpAfter = @(Get-Process -Name php -ErrorAction SilentlyContinue)
$phpCpuAfter = ($phpAfter | Measure-Object -Property CPU -Sum).Sum
$phpMemoryAfter = ($phpAfter | Measure-Object -Property WorkingSet64 -Sum).Sum

$successful = @($results | Where-Object Success)
$failed = @($results | Where-Object { -not $_.Success })
$times = @($results | ForEach-Object { $_.ResponseMs } | Sort-Object)

$average = 0
$median = 0
$p95 = 0

if ($times.Count -gt 0) {
    $average = [math]::Round(($times | Measure-Object -Average).Average, 2)
    $middle = [math]::Floor($times.Count / 2)

    if ($times.Count % 2 -eq 0) {
        $median = [math]::Round(($times[$middle - 1] + $times[$middle]) / 2, 2)
    } else {
        $median = $times[$middle]
    }

    $p95Index = [math]::Max(0, [math]::Ceiling($times.Count * 0.95) - 1)
    $p95 = $times[$p95Index]
}

$throughput = 0
if ($overall.Elapsed.TotalSeconds -gt 0) {
    $throughput = [math]::Round($successful.Count / $overall.Elapsed.TotalSeconds, 2)
}

$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

$commit = (& git -C (Join-Path $folder "..\..\..\backend") rev-parse --short HEAD 2>$null)
if (-not $commit) { $commit = "Not available" }

$phpVersion = (& php -v 2>$null | Select-Object -First 1)
$os = [System.Environment]::OSVersion.VersionString
$memoryBeforeMB = [math]::Round(($phpMemoryBefore / 1MB), 2)
$memoryAfterMB = [math]::Round(($phpMemoryAfter / 1MB), 2)

$report = @(
"# Local Laravel Health Endpoint Measurement"
""
"- Test date/time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
"- Endpoint: $Url"
"- Method: GET"
"- Requests attempted: $RequestCount"
"- Successful requests: $($successful.Count)"
"- Failed requests: $($failed.Count)"
"- Total elapsed time: $([math]::Round($overall.Elapsed.TotalSeconds, 2)) seconds"
"- Average response time: $average ms"
"- Median response time: $median ms"
"- 95th percentile response time: $p95 ms"
"- Successful-request throughput: $throughput requests/second"
"- Tested Git commit: $commit"
"- PHP: $phpVersion"
"- Operating system: $os"
""
"## PHP process observations"
""
"- PHP processes before test: $($phpBefore.Count)"
"- PHP processes after test: $($phpAfter.Count)"
"- Combined PHP working set before: $memoryBeforeMB MB"
"- Combined PHP working set after: $memoryAfterMB MB"
"- Combined PHP CPU time before: $phpCpuBefore seconds"
"- Combined PHP CPU time after: $phpCpuAfter seconds"
""
"## Result interpretation"
""
"This was a sequential local health-endpoint check. It did not simulate concurrent users and does not establish production capacity, database performance, or full application workflow performance."
""
"PHP process memory and CPU observations are process-level snapshots, not isolated per-request resource measurements."
""
"The first failed request, if any, is recorded as a failed request. Do not remove failed results from the CSV."
""
"## Files"
""
"- Detailed measurements: $(Split-Path -Leaf $csvPath)"
) -join [Environment]::NewLine

Set-Content -Path $reportPath -Value $report -Encoding UTF8

Write-Host "`n===== MEASUREMENT SUMMARY ====="
Write-Host "Successful: $($successful.Count)"
Write-Host "Failed: $($failed.Count)"
Write-Host "Average: $average ms"
Write-Host "Median: $median ms"
Write-Host "P95: $p95 ms"
Write-Host "Throughput: $throughput successful requests/second"
Write-Host "CSV: $csvPath"
Write-Host "Report: $reportPath"
