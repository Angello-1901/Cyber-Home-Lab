# pfSense Setup Guide

## Console: assign interfaces & set LAN IP

1. Boot pfSense from ISO, complete installation.
2. On first boot console, choose:
   - `1) Assign Interfaces` → map em0 = WAN, em1 = LAN
3. Set LAN IP:
   - Menu → `2) Set interface(s) IP address` → choose `LAN`
   - Configure IPv4 via DHCP? → `n`
   - Enter LAN IPv4 address: `192.168.1.105`
   - Subnet bit count: `29`
   - Upstream gateway: press Enter (none)
4. Set WAN to DHCP if desired:
   - Menu → `2) Set interface(s) IP address` → choose `WAN`
   - Configure IPv4 via DHCP? → `y`
5. Verify:
```bash
ifconfig
```

Useful pfSense shell commands:
```bash
ifconfig
```

```bash
ping 8.8.8.8
```

```bash
pfctl -sr
```

---

## WebGUI Essentials

Access the pfSense WebGUI from a browser **on a VM connected to the LabNet** or from the host (if the host can reach the VM network):

- **URL (lab-only):** `https://192.168.1.105`  
  *Or use the hostname if you configured DNS: `https://pfsense-lab.local`*  
  > Note: This address is reachable **only inside the lab network**. If you browse to the URL you will likely get a certificate warning (pfSense uses a self-signed cert by default) — proceed only if you recognize the device.

- **Username:** `admin`  
- **Password:** `pfsense` *(change immediately after first login)*

**Security notes**
- Never enable the web GUI on the WAN interface unless you intentionally secure and restrict it.  
- To minimize risk, restrict admin access to specific IPs: Firewall → Rules → WAN (allow only your host IP) or better, administer via the LAN only.
- Keep WebGUI set to **HTTPS** (do not revert to HTTP).
  

---

### System → General Setup
- Hostname: `pfsense-lab`
- Domain: `lab.local`
- DNS Servers: `8.8.8.8`, `1.1.1.1`
- Uncheck: *Allow DNS server list to be overridden by DHCP/PPP on WAN*

---

### Services → DHCP Server → LAN
- Enable DHCP server on LAN
- Range: `192.168.1.106 – 192.168.1.110`
- DNS servers: leave blank (default = pfSense) or set `8.8.8.8`

---

### Services → DNS Resolver
- Enable DNSSEC
- (Optional) Enable DNS over TLS
- Save & restart

---

### Diagnostics → Packet Capture
- Select `WAN` or `LAN` interface
- Start capture
- Download `.pcap` and open in Wireshark
