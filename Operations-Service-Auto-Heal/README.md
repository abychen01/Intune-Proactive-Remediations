# Auto-Heal Critical Windows Services (Intune Remediation)

## Overview
This Intune Proactive Remediation detects if a critical Windows service (such as the Windows Update service `wuauserv`) has stopped or been disabled, and restores both its startup configuration and running state automatically.

## Real-World Use Case
When essential background services (`wuauserv`, `BITS`, `Spooler`, or endpoint security agents) stop or get disabled, endpoints miss security patches and fail compliance checks. Instead of generating Tier 1/2 support tickets, Intune proactively detects the stopped service and restores it on a recurring schedule.

## Intune Deployment Settings
* **Detection script:** `Detect-ServiceHealth.ps1`
* **Remediation script:** `Remediate-ServiceHealth.ps1`
* **Run this script using the logged-on credentials:** `No` (`SYSTEM` context)
* **Enforce script signature check:** `No`
* **Run script in 64-bit PowerShell:** `Yes`
* **Recommended Schedule:** Daily (or Hourly for critical update/security services)
