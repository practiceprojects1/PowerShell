# Define the path for the output EVTX file
#$evtxFilePath = "EventsLastMinute.evtx"
$csvFilePath = "\EventsLastMinute2.csv"

# Define the event log source
$logName = "Security"  # Change to the desired log name, e.g., "System" or "Security"

# Get the current time
$now = Get-Date


# Calculate the time 1 minute ago
$startTime = $now.AddMinutes(-100)

# Create a filter for events that occurred within the last minute
$filter = @{
    LogName   = $logName
    StartTime = $startTime
    EndTime   = $now
}

# Use Get-WinEvent to query events from the log
try {
    # Query the events
    $events = Get-WinEvent -FilterHashtable $filter

    # Check if any events were retrieved
    if ($events) {
        # Convert events to a format suitable for CSV export
        $events | Select-Object TimeCreated, Id, LevelDisplayName, Message | Export-Csv -Path $csvFilePath -NoTypeInformation
        Write-Output "Successfully exported events to $csvFilePath"
    } else {
        Write-Output "No events found for the specified time range."
    }
}
catch {
    Write-Error "Failed to export events: $_"
}
