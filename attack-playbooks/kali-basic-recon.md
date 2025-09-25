# Kali Basic Recon Playbook

⚠️ This playbook is for educational use only. Run only inside an isolated lab environment.

---

## 1. Ping sweep (find live hosts)

```bash
nmap -sn 192.168.1.104/29
```

## 2. Full TCP scan (all ports, service detection)

```bash
nmap -sS -sV -p- 192.168.1.105-110 -oA scans/full_tcp
```

## 3. SMB enumeration

```bash
enum4linux -a 192.168.1.106
```

```bash
smbclient -L //192.168.1.106 -U 'guest'
```

## 4. LDAP enumeration

```bash
ldapsearch -x -h 192.168.1.106 -b "dc=lab,dc=local"
```

## 5. Password spraying (lab-only)

```bash
hydra -L users.txt -P passwords.txt 192.168.1.106 smb
```
