## Observability — Planned installs & TODOs (add now, implement later)

> NOTE: The steps below document what I'll install and how to verify it. These are intended as a reproducible checklist to implement and test in the lab. They are safe to keep in the repo as documentation (no secrets).

---

### Sysmon (Windows clients) — TODO
**Goal:** collect detailed Windows process, network, and file/registry telemetry for detection.

**Planned actions**
1. Download Sysmon from Microsoft Sysinternals:
   - https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon

2. Place a hardened config file `sysmon-config.xml` in a repo folder (example provided below). Install on each Windows client in an elevated PowerShell session:

# run on Windows client (elevated)

```powershell
.\Sysmon64.exe -i sysmon-config.xml -accepteula
```
# update config later

```powershell
.\Sysmon64.exe -c sysmon-config.xml
```

Example minimal config (sysmon-config.xml):
<Sysmon schemaversion="4.50">
  <EventFiltering>
    <ProcessCreate onmatch="include" />
    <NetworkConnect onmatch="include" />
    <ImageLoad onmatch="include" />
    <FileCreateTime onmatch="exclude" />
  </EventFiltering>
</Sysmon>

Verify Sysmon is running

# On the Windows client

```powershell
Get-Service -Name Sysmon64
```
# Check recent Sysmon events:

```powershell
Get-WinEvent -ProviderName "Microsoft-Windows-Sysmon"
```

### TODO Notes

Harden the sysmon-config.xml rules before deployment (reduce noise, add exclusions).

Add instructions to deploy remotely (PowerShell remoting, Group Policy, or Wazuh).

Wazuh (SIEM / agent) — TODO

Goal: centralize logs (Sysmon, Windows event logs, endpoint alerts) and visualize via Wazuh manager.

Planned actions

Provision a Linux VM for Wazuh manager (Ubuntu 22.04 or similar).

Follow Wazuh manager installation docs (manager + Kibana/OpenSearch stack).

https://documentation.wazuh.com/

## Install agent on Windows clients (example command):

```powershell
msiexec /i wazuh-agent-x.y.z.msi /qn WAZUH_MANAGER=192.168.1.200 WAZUH_AGENT_NAME=win10-client
```
On the manager, accept/register the agent.

Verify

On manager: check agents list and status in Wazuh UI.

On client: confirm agent service running:

```powershell
Get-Service -Name wazuh-agent
```
TODO Notes

Prepare manager install playbook.

Store manager IP and registration keys in secure vault (don’t commit to repo).

Configure Wazuh rules to ingest Sysmon events.

Wireshark / Packet capture — TODO

Goal: capture network traffic for deep packet inspection and detection tuning.

Planned actions

Use Wireshark on host for GUI analysis.

Use pfSense Diagnostics → Packet Capture for targeted capture on WAN/LAN interfaces.

Save PCAP files and open in Wireshark for analysis.

Commands / steps

From pfSense WebGUI: Diagnostics → Packet Capture → choose interface (em0/em1), filter (optional), start → download .pcap.

On host, open .pcap in Wireshark.

Verify

Ensure captured traffic contains DNS, SMB, Kerberos, or other protocols expected from the lab.

Example quick tcpdump (on Linux host / if available):
# capture 1000 packets to file on host (replace interface name)

```bash
tcpdump -i eth0 -c 1000 -w lab_capture.pcap
```

TODO Notes

Decide if permanent remote packet capture (pcap pipeline) is needed for SIEM ingestion.

Add write-up of common Wireshark filters used in lab (e.g., smb kerberos dns).

Implementation checklist (for each TODO)

 Build Wazuh manager VM

 Harden sysmon-config.xml and add to repo

 Deploy Sysmon to Windows clients (manual / GPO / script)

 Install Wazuh agents and register them

 Validate agent telemetry in Wazuh UI

 Capture pcap from pfSense and analyze in Wireshark

 Tune Wazuh detection rules and validate with Kali test cases

Helpful links

Sysmon: https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon

Wazuh docs: https://documentation.wazuh.com/

pfSense packet capture docs: https://docs.netgate.com/pfsense/en/latest/diagnostics/packet-capture.html
