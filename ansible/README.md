# 🏠 Homelab Ansible Configuration

This directory contains Ansible playbooks and roles for managing homelab infrastructure.

## 📁 Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── inventory/
│   └── hosts.yml           # Infrastructure inventory
├── playbooks/
│   ├── proxmox.yml         # Proxmox VE configuration
│   └── site.yml            # Master playbook
├── roles/
│   └── proxmox/            # Proxmox VE role
├── run.ps1                 # PowerShell execution helper
├── run.sh                  # Bash execution helper
└── requirements.txt        # Python dependencies
```

## 🚀 Quick Start

1. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

2. **Configure Inventory**:
   Edit `inventory/hosts.yml` with your server details:
   ```yaml
   proxmox:
     hosts:
       pve1:
         ansible_host: 192.168.1.100
         ansible_user: root
   ```

3. **Test Connectivity**:
   ```bash
   # PowerShell
   .\run.ps1 check
   
   # Bash
   ./run.sh check
   ```

4. **Run Configuration**:
   ```bash
   # PowerShell
   .\run.ps1 proxmox --check --diff  # Dry run
   .\run.ps1 proxmox                 # Apply changes
   
   # Bash  
   ./run.sh proxmox --check --diff   # Dry run
   ./run.sh proxmox                  # Apply changes
   ```

## 📋 Available Roles

### Proxmox
Configures Proxmox VE hosts for homelab usage:
- Disables enterprise repository
- Enables no-subscription repository
- Removes subscription notifications from Web UI
- System optimization for homelab use

## 🎯 Tags

Use tags to run specific parts of playbooks:

```bash
# Only repository configuration
.\run.ps1 proxmox --tags "repositories"

# Only web UI modifications
.\run.ps1 proxmox --tags "ui_modifications"

# Skip backups
.\run.ps1 proxmox --skip-tags "backup"
```

## 🔧 Configuration

### Default Behavior
The roles use sensible defaults for homelab usage. Key defaults:
- `proxmox_disable_enterprise_repo: true`
- `proxmox_enable_no_subscription_repo: true`
- `proxmox_disable_subscription_nag: true`

### Overriding Defaults
Override variables in your inventory or playbook:
```yaml
proxmox:
  hosts:
    pve1:
      ansible_host: 192.168.1.100
      proxmox_upgrade_packages: true  # Enable automatic upgrades
```

## 🛡️ Security

- SSH key-based authentication recommended
- Use Ansible Vault for sensitive data
- Test in non-production first

## 📚 Reference

This configuration is based on proven Ansible patterns and best practices, adapted specifically for homelab usage.