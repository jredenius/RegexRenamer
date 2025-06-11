# RegexRenamer-ContextMenu.ps1
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Add", "Remove")]
    [string]$Action,

    [string]$ExecutablePath = "$PSScriptRoot\RegexRenamer.exe"
)

$menuKey      = "Registry::HKEY_CLASSES_ROOT\Folder\shell\RegexRenamer"
$commandKey   = "$menuKey\command"

if ($Action -eq "Add") {
    try {
        # Create the menu key and set its default value
        if (-not (Test-Path $menuKey)) {
            New-Item -Path $menuKey -Force | Out-Null
        }
        Set-ItemProperty -Path $menuKey -Name "(default)" -Value "Rename using RegexRenamer"

        # Create the command key and set its default value
        if (-not (Test-Path $commandKey)) {
            New-Item -Path $commandKey -Force | Out-Null
        }
        Set-ItemProperty -Path $commandKey -Name "(default)" -Value "`"$ExecutablePath`" `"%L`""

        Write-Host "Context menu entry added."
    } catch {
        Write-Error "Failed to add context menu entry: $_"
    }
}
elseif ($Action -eq "Remove") {
    try {
        if (Test-Path $menuKey) {
            Remove-Item -Path $menuKey -Recurse -Force
            Write-Host "Context menu entry removed."
        } else {
            Write-Host "Context menu entry does not exist."
        }
    } catch {
        Write-Error "Failed to remove context menu entry: $_"
    }
}