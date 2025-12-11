# Minecraft Server on Oracle Cloud Infrastructure

A Terraform project that deploys a Minecraft server on Oracle Cloud Infrastructure (OCI) using a free-tier eligible VM.

## What This Creates

- Ubuntu instance (VM.Standard.E5.Flex with 2 OCPUs, 16GB RAM)
- Virtual Cloud Network (VCN) with public subnet
- Internet Gateway for external connectivity
- Security rules for SSH and Minecraft 
- Apache web server with welcome page
- PaperMC Minecraft server (current version 1.21.10)

## Prerequisites

- Oracle Cloud account
- Terraform installed
- SSH key pair generated
- OCI CLI configured 

## Configuration

1. Copy `terraform.tfvars.example` to `terraform.tfvars` (if provided)
2. Update variables with your values:
   - `compartment_id`: Your OCI compartment OCID
   - `comp_source_id`: Ubuntu image OCID for your region
   - `ssh_key_path`: Path to your public SSH key
   - `comp_display_name`: Display name for your instance


```
## Connecting

**SSH Access:**
```bash
ssh ubuntu@<instance_public_ip>
```

**Minecraft Server:**
- Connect using: `<instance_public_ip>:25565` in Minecraft multiplayer
- Default port 25565 can be omitted: `<instance_public_ip>`

## Server Management

Check Minecraft server status:
```bash
sudo systemctl status minecraft
```

View server logs:
```bash
sudo journalctl -u minecraft -f
```

Restart server:
```bash
sudo systemctl restart minecraft
```

## Firewall Configuration

Security is managed at two levels:
1. **OCI Security Lists** (primary): Controls traffic at the VCN level
2. **iptables** (cleared): Default Oracle iptables rules are flushed during setup

## Cost Considerations

This configuration uses OCI Free Tier eligible resources:
- VM.Standard.E5.Flex (2 OCPUs, 16GB RAM)
- VCN and networking components (free)
- Public IP address (limited free tier quota)

## Notes

- The Minecraft server is configured with 8GB RAM allocation
- Server runs as systemd service `minecraft`
- Boot volume is not preserved on instance termination
- First boot takes a few minutes to complete setup script

## Troubleshooting

**Can't connect via SSH:**
- Verify security list is attached to subnet
- Check route table is configured
- Confirm public IP is assigned

**Minecraft server won't start:**
- Check logs: `sudo journalctl -u minecraft -xe`
- Verify Java installation: `java -version`
- Check EULA acceptance in `/home/minecraft/minecraft_server/eula.txt`

**Web page doesn't load:**
- Verify Apache is running: `sudo systemctl status apache2`
- Check iptables rules are cleared: `sudo iptables -L -n`
