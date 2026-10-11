$dir = "D:\emulators\vita3k"   # your portable folder
$url = "https://github.com/Vita3K/Vita3K/releases/download/continuous/windows-latest.zip"
$zip = Join-Path $env:TEMP "vita3k.zip"

if (Get-Process Vita3K -ErrorAction SilentlyContinue) {
    Write-Host "Close Vita3K first."; exit
}

# Only download if the remote build changed since last time
$stamp = Join-Path $dir ".last_update"
$remote = (Invoke-WebRequest $url -Method Head -UseBasicParsing).Headers["Last-Modified"]
if ((Test-Path $stamp) -and (Get-Content $stamp) -eq "$remote") {
    Write-Host "Already up to date."
} else {
    Invoke-WebRequest $url -OutFile $zip
    Expand-Archive $zip -DestinationPath $dir -Force
    Remove-Item $zip
    Set-Content $stamp "$remote"
    Write-Host "Updated."
}

Start-Process (Join-Path $dir "Vita3K.exe")