# Disable Windows Update Service
Stop-Service -Name wuauserv -Force
Set-Service -Name wuauserv -StartupType Disabled

# Disable Windows Update Medic Service
Stop-Service -Name WaaSMedicSvc -Force
Set-Service -Name WaaSMedicSvc -StartupType Disabled

# Disable Update Orchestrator Service
Stop-Service -Name UsoSvc -Force
Set-Service -Name UsoSvc -StartupType Disabled

# Disable Windows Update Scheduler Service
Stop-Service -Name WaaSMedicSvc -Force
Set-Service -Name WaaSMedicSvc -StartupType Disabled

# Block Windows Update from Group Policy
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f

# Block Windows Update from Task Scheduler
$tasks = @(
    "Microsoft\Windows\UpdateOrchestrator\Schedule Scan",
    "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_Display",
    "Microsoft\Windows\UpdateOrchestrator\Reboot",
    "Microsoft\Windows\UpdateOrchestrator\Reboot_AC",
    "Microsoft\Windows\UpdateOrchestrator\Reboot_Battery",
    "Microsoft\Windows\UpdateOrchestrator\Policy Install",
    "Microsoft\Windows\UpdateOrchestrator\Policy Install - AC",
    "Microsoft\Windows\WindowsUpdate\sih",
    "Microsoft\Windows\WindowsUpdate\sihboot"
)

foreach ($task in $tasks) {
    schtasks /change /tn $task /disable
}

Write-Output "Windows Update services and tasks have been disabled."


# Stop the Windows Update service
Stop-Service -Name wuauserv -Force

# Set the Windows Update service to manual start
Set-Service -Name wuauserv -StartupType Manual

# Configure Windows Update settings to notify for download and notify for install
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 2

# Stop and restart the Windows Update service to apply the changes
Stop-Service -Name wuauserv -Force
Start-Service -Name wuauserv
