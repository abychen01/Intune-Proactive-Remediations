# Intune Remediation: Proactive Low Storage Recovery

This repository contains an enterprise-ready **Microsoft Intune Remediation script package** designed to proactively monitor system disk space and automatically trigger advanced background cleanup tasks when storage falls below a critical threshold.

## ❓ Why Use a Remediation Script?
Intune has **zero native configuration profile settings** to monitor disk metrics or dynamically execute file optimization routines. While native settings exist to delete user profiles older than X days, they frequently fail if files are locked by active system services or security scanners. 

This solution uses safe, low-level OS utilities (`DISM`, `cleanmgr.exe`, and `CIM/WMI` methods) to aggressively reclaim space safely in the background without affecting end-user workflows.

---

## 🛠️ How It Works

1. **The Detection Script (`Detect-LowStorage.ps1`)** 
   Queries the `Win32_LogicalDisk` object to inspect the primary system partition (`C:`). It flags the device as **Non-Compliant** (Exit Code `1`) if free space drops below **15 GB** OR if the available capacity drops below **10%** of the drive's total size.
2. **The Remediation Script (`Remediate-LowStorage.ps1`)** 
   If triggered by a non-compliant flag, this script runs silently under the `SYSTEM` context to:
   * Perform a component cleanup via `DISM` to compress and purge superseded Windows Updates.
   * Headlessly execute the native Windows Disk Cleanup (`cleanmgr.exe`) engine using automated registry flags.
   * Wipe out stale logs and temporary system data from `C:\Windows\Temp`.

---

## 🚀 Intune Deployment Configuration

To successfully deploy this script package in the **Microsoft Intune Admin Center**, use the following environmental configurations:

1. Navigate to **Devices** > **Remediations** > **Create script package**.
2. Upload the scripts to their respective **Detection script file** and **Remediation script file** slots.
3. Configure the **Settings** blade exactly as follows:

| Setting | Configuration | Reason |
| :--- | :--- | :--- |
| **Run this script using the logged-on credentials** | **No** | Must run as `NT AUTHORITY\SYSTEM` to manipulate protected Windows paths and execute system cleanups. |
| **Enforce script signature check** | **No** | Unless your organization explicitly code-signs internal administrative scripts. |
| **Run script in 64-bit PowerShell** | **Yes** | Prevents the 32-bit Windows-on-Windows (WoW64) subsystem redirect from breaking native binary calls to `DISM` and `cleanmgr`. |

### 📅 Suggested Schedule
* **Frequency:** Daily or every 3 days.
* **Targeting:** Assign to a dynamic device group consisting of all corporate Windows workstations.

---

## 🔍 How to Monitor Output
You can read live logs and confirmation output (the strings inside `Write-Output`) using the following methods:

* **In the Cloud:** Intune Admin Center > **Devices** > **Remediations** > *[Your Script Package]* > **Device status**. Scroll right to view the full text inside the **Detection output** and **Remediation output** columns.
* **Locally (For Troubleshooting):** Open the local client log file at `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\IntuneManagementExtension.log` using a utility like CMTrace or Notepad. Search for the keyword `AgentExecutor` to view real-time text output and execution status codes.
