$delegationEvents = @(
    "RegisterDelegatedAdministrator",
    "DeregisterDelegatedAdministrator"
)

foreach ($event in $delegationEvents) {
    Write-Host "Event: $event"
    $events = aws cloudtrail lookup-events `
        --lookup-attributes AttributeKey=EventName,AttributeValue=$event `
        --max-results 10 `
        --query 'Events[*].{Time:EventTime,User:Username,IP:SourceIPAddress}' `
        --output json | ConvertFrom-Json

    foreach ($e in $events) {
        try {
            $epoch = [double]$e.Time
            $humanTime = [DateTimeOffset]::FromUnixTimeSeconds($epoch).ToLocalTime()
        } catch {
            $humanTime = "N/A"
        }
        Write-Host "  Time: $humanTime | User: $($e.User) | IP: $($e.IP)"
    }
}
