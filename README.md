# Cyber Home Lab 🕵️ — pfSense + Windows Server 2022 + Windows 10 + Kali

### Goal:
Reproducible, isolated home cyber lab for learning defensive and offensive techniques. Primary VMs:

* **pfSense —** virtual router/firewall (LAN = isolated lab network; WAN = NAT or bridged to host)

* **Security Software**

* **Windows Server 2022 —** Active Directory Domain Controller (AD DS), DNS optional

* **Windows 10 —** domain-joined workstation

* **Kali Ubuntu —** Server hosting Splunk SIEM tool and Wireshark

* **Kali Linux —** attacker machine on isolated attacker VLAN

## Planned next steps: 
* Sysmon (host EDR telemetry), Wireshark, Snort/Suricata, and controlled attacks from Kali to exercise detections


## Table of Contents
- [VirtualBox Setup](vbox-setup.md)
- [pfSense Setup](pfSense-setup.md)
- [Active Directory Deployment](ad-deploy.ps1)
- [Observability (Sysmon + Wazuh)](observability/agent-installation.md)
- [Attack Playbooks (Kali Recon)](attack-playbooks/kali-basic-recon.md)
- [Security Disclaimer](SECURITY.md)
- [Screenshots](docs)
