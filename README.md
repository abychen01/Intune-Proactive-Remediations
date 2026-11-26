# Microsoft Intune Proactive Remediations

A collection of production-ready PowerShell detection and remediation scripts designed to automate endpoint self-healing, enforce compliance, and reduce Tier 1/2 support tickets across Windows 10/11 fleets.

## Available Remediations

| Script Package | Category | Description |
| :--- | :--- | :--- |
| [`Operations-Service-Auto-Heal`](./Operations-Service-Auto-Heal) | Operations | Automatically detects stopped critical services (`wuauserv`), resets startup type to `Automatic`, and restarts them. |

## Engineering Standards
* **Explicit Exit Codes:** Uses `Exit 0` (Compliant) and `Exit 1` (Non-Compliant) for accurate Intune reporting and remediation triggers.
* **Portal Telemetry:** Outputs clean status messages via `Write-Output` for Intune's Pre- and Post-remediation device status columns.
* **SYSTEM Context:** Built and tested to execute silently under `NT AUTHORITY\SYSTEM` in 64-bit PowerShell.
