## Sysmon (Windows clients)
**Goal:** collect detailed Windows process, network, and file/registry telemetry for detection.

**Actions**
1. Download Sysmon from Microsoft Sysinternals:
   - https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon

2. Download a hardened configuration (we used [SwiftOnSecurity’s Sysmon config].

3. Extract the Sysmon zip and place both files in `C:\Tools\Sysmon`.

```powershell
.\Sysmon64.exe -i sysmon-config.xml -accepteula
```

4. **Update config later**

```powershell
.\Sysmon64.exe -c sysmon-config.xml
```

Example minimal config (sysmon-config.xml):

```powershell
<Sysmon schemaversion="4.50">
  <EventFiltering>
    <ProcessCreate onmatch="include" />
    <NetworkConnect onmatch="include" />
    <ImageLoad onmatch="include" />
    <FileCreateTime onmatch="exclude" />
  </EventFiltering>
</Sysmon>
```

### 5. **Verify Sysmon is running**

* **On the Windows client**

```powershell
Get-Service -Name Sysmon64
```
* **Check recent Sysmon events:**

```powershell
Get-WinEvent -ProviderName "Microsoft-Windows-Sysmon"
```

### Sysmon events should now appear in:

Event Viewer → Applications and Services Logs → Microsoft → Windows → Sysmon → Operational


* **Goal:** centralize logs (Sysmon, Windows event logs, endpoint alerts) and visualize via Splunk SIEM Tool.
  
---

## Important (Before you Proceed to Next Steps):

* Refer to **Virtual Box Setup** in "Index" for guidence on Linux (Ubuntu 22.04 or similar) and Splunk installation.

---

## Download the Splunk Universal Forwarder:
1. https://www.splunk.com/en_us/download/universal-forwarder.html (or follow path in official site)

2. Place the installer in C:\Temp.

3. Run the following PowerShell command (as Administrator) to install silently:
   
```powershell
msiexec.exe /i "C:\Temp\splunkforwarder.msi" AGREETOLICENSE=Yes LAUNCHSPLUNK=0 /qn
```

4. Add your Splunk Indexer (Ubuntu) as the receiving server using FQDN:

```powershell
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" add forward-server (Ubuntu FQDN):9997 -auth admin:(Admin Username)
```
5. Enable Windows Event Logs and Sysmon forwarding:

```powershell
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" add monitor "C:\Windows\System32\winevt\Logs\Security.evtx"
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" add monitor "C:\Windows\System32\winevt\Logs\System.evtx"
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" add monitor "C:\Windows\System32\winevt\Logs\Application.evtx"
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" add monitor "C:\Windows\System32\winevt\Logs\Microsoft-Windows-Sysmon%4Operational.evtx"
```

6. Restart the forwarder service:

```powershell
Restart-Service splunkforwarder
```

7. Verify that the connection to the Splunk Indexer is active:

```powershell
& "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" list forward-server
```

8. You should see:

```powershell
Active forwards:
  (Ubuntu Linux FQDN):9997
```

## Validation in Splunk (on Ubuntu Indexer)

1. **Log into Splunk Web UI:**
   http://(Your Ubuntu LAN IP):8000

2. **Go to Search & Reporting → Search and run:**
   index=wineventlog OR index=sysmon

3. **Verify that your Windows 10 and Windows Server 2022 logs are appearing.**

## Notes:

### Sysmon config (SwiftOnSecurity) filters out benign noise and focuses on:

- Process creation and parent-child relationships

- Command-line arguments

- Network connections

- Registry modifications

- File creation time anomalies

**Ensure NTP (Network Time Protocol) is enabled on all systems for accurate timestamps:**

- Ubuntu uses: sudo timedatectl set-ntp on

- Windows uses: w32tm /resync

### Wireshark / Packet capture — TODO

**Goal:** capture network traffic for deep packet inspection and detection tuning.

**Planned actions**

* Use Wireshark on host for GUI analysis.

* Use pfSense Diagnostics → Packet Capture for targeted capture on WAN/LAN interfaces.

* Save PCAP files and open in Wireshark for analysis.

## Commands / steps

* From pfSense WebGUI: Diagnostics → Packet Capture → choose interface (em0/em1), filter (optional), start → download .pcap.

* On host, open .pcap in Wireshark.

* Verify

* Ensure captured traffic contains DNS, SMB, Kerberos, or other protocols expected from the lab.

**Example quick tcpdump (on Linux host / if available):**
# capture 1000 packets to file on host (replace interface name)

```bash
tcpdump -i eth0 -c 1000 -w lab_capture.pcap
```

### TODO Notes

* Decide if permanent remote packet capture (pcap pipeline) is needed for SIEM ingestion.

* Add write-up of common Wireshark filters used in lab (e.g., smb kerberos dns).

* Implementation checklist (for each TODO)

* Capture pcap from pfSense and analyze in Wireshark

* Tune Splunk detection rules and validate with Kali test cases
