# Cyber Home Lab 🕵️ — pfSense + Windows Server 2022 + Windows 10 + Kali

### Goal:
Reproducible, isolated home cyber lab for learning defensive and offensive techniques. Primary VMs:

* **pfSense —** Virtual router/firewall (LAN = isolated lab network; WAN = NAT or bridged to host)

* **Windows Server 2022 —** Active Directory Domain Controller (AD DS), DNS optional

* **Windows 10 —** Domain-joined workstation

* **Kali Ubuntu —** Server hosting Splunk SIEM tool and Wireshark

* **Kali Linux —** Attacker machine on isolated attacker VLAN

* **Security Software -** Applicable to all endpoints within the LAN Network:
  - Installation and configuration of Suricata (IDS/IPS) on pfSense using open Emerging Threats Open (ET Open) ruleset
  - Installation and configuration of Sismon on endpoints for advanced log analysis (Windows Server 2022 and Windows 10)
  - Installation and configuration of Splunk UF for log forwarding to Splunk SIEM (hosted in Ubuntu Linux)
  - Enabling NTP for time synchorization on all endpoints for log tracking accuracy 

## Planned next steps: 
* Wireshark, Snort/Suricata, and controlled attacks from Kali to exercise detections


## Table of Contents
- [VirtualBox Setup](vbox-setup.md)
- [pfSense Setup](pfSense-setup.md)
- [Active Directory Deployment](ad-deploy.ps1)
- [Observability (Sysmon + Wazuh)](observability/agent-installation.md)
- [Attack Playbooks (Kali Recon)](attack-playbooks/kali-basic-recon.md)
- [Security Disclaimer](SECURITY.md)
- [Screenshots](docs)
