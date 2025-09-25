# VirtualBox VM settings:
- pfSense VM

Name: pfSense

Type: Other / Other BSD (or BSD)

Memory: 3072 MB (recommended)

CPUs: 2

Disk: 19 GB (VDI or VHD)

Storage: Attach pfSense CE ISO to Optical Drive (IDE controller if you saw install issues)

Network:

Adapter 1 (WAN)

Attached to: NAT (install); after install you may switch to Bridged Adapter

Name (if bridged): MediaTek Wi-Fi 6 MT7921 (or your host Wi-Fi NIC)

Adapter Type: Intel PRO/1000 MT Server

Promiscuous Mode: Allow All

Cable Connected: checked

Adapter 2 (LAN)

Attached to: Internal Network

Name: LabNet

Adapter Type: Intel PRO/1000 MT Server

Promiscuous Mode: Allow All

Cable Connected: checked

Windows Server 2022 VM

Memory: 4096 MB (or what you can spare)

Disk: 40+ GB

Network:

Adapter 1 → Internal Network → Name LabNet

Adapter Type: Intel PRO/1000 MT Server

Promiscuous Mode: Allow All (optional)

Windows 10 VM

Network (same as Server): Internal Network → LabNet

Kali VM

Adapter 1 → Internal Network → KaliNet (attacker VLAN)

Adapter 2 → NAT (or Bridged) for internet-only access

Promiscuous Mode = Allow All (if sniffing / IDS involved)

VBoxManage useful commands

List VMs:
```bash
VBoxManage list vms
```

Show VM info (including NIC mapping):
```bash
VBoxManage showvminfo "pfSense" --details
```

Start VM headless:
```bash
VBoxManage startvm "pfSense" --type headless
```

Attach an ISO to optical drive:
```bash
VBoxManage storageattach "pfSense" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium /path/to/pfSense-CE.iso
```
