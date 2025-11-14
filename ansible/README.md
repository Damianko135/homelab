# 🏠 Homelab Ansible Configuration

Ansible playbooks and roles for managing homelab infrastructure, specifically focused on Proxmox VE configuration.

## 📁 Directory Structure

```
ansible/
├── ansible.cfg                 # Ansible configuration
├── inventory/
│   └── hosts.yml              # Infrastructure inventory
├── playbooks/
│   ├── proxmox.yml            # Proxmox VE configuration
│   └── site.yml               # Master playbook (imports all)
├── roles/
│   └── proxmox/               # Proxmox VE role
├── group_vars/
│   ├── all/
│   │   ├── vault.yml          # Encrypted passwords
│   │   └── vault.yml.template # Vault template
│   └── proxmox.yml            # Proxmox group variables
├── .vault_pass                # Vault password file (gitignored)
├── requirements.txt           # Python dependencies
└── requirements.yml           # Ansible collections
```

## 🚀 Quick Setup

### 1. Install Dependencies

```bash
# Python packages
pip install -r requirements.txt

# Ansible collections and roles  
ansible-galaxy install -r requirements.yml

# SSH password authentication tool
sudo apt install sshpass        # Debian/Ubuntu
# brew install hudochenkov/sshpass/sshpass  # macOS
```

### 2. Configure Inventory

Edit `inventory/hosts.yml` with your actual Proxmox hosts:

```yaml
proxmox:
  hosts:
    pve1:
      ansible_host: 192.168.178.5  # Your Proxmox IP
      ansible_user: root
    # pve2:
    #   ansible_host: 192.168.178.6
    #   ansible_user: root
```

### 3. Set Up Vault (Secure Password Storage)


```bash
# Create vault password file
echo "your_vault_password_here" > .vault_pass
chmod 600 .vault_pass

# Create encrypted vault file
ansible-vault create group_vars/all/vault.yml --vault-password-file .vault_pass
```

Add to vault file:
```yaml
---
vault_ssh_password: "your_actual_ssh_password"
vault_sudo_password: "your_actual_sudo_password"
```

## 🔧 Command Cheatsheet

### Basic Ansible Commands

```bash
# Test connectivity to all hosts
ansible all -m ping --vault-password-file .vault_pass

# Test connectivity to Proxmox hosts only
ansible proxmox -m ping --vault-password-file .vault_pass

# Gather system facts from all hosts
ansible all -m setup --vault-password-file .vault_pass

# Run ad-hoc command on all Proxmox hosts
ansible proxmox -a "uptime" --vault-password-file .vault_pass
```

### Playbook Execution

```bash
# Run Proxmox configuration (dry-run)
ansible-playbook playbooks/site.yml --tags proxmox --vault-password-file .vault_pass --check --diff

# Run Proxmox configuration (apply changes)
ansible-playbook playbooks/site.yml --tags proxmox --vault-password-file .vault_pass

# Run all playbooks
ansible-playbook playbooks/site.yml --vault-password-file .vault_pass

# Run with specific inventory
ansible-playbook -i inventory/hosts.yml playbooks/proxmox.yml --vault-password-file .vault_pass

# Run with extra verbosity (debug)
ansible-playbook playbooks/site.yml --tags proxmox --vault-password-file .vault_pass -vvv
```

### Vault Management

```bash
# Edit vault file
ansible-vault edit group_vars/all/vault.yml --vault-password-file .vault_pass

# View vault contents
ansible-vault view group_vars/all/vault.yml --vault-password-file .vault_pass

# Change vault password
ansible-vault rekey group_vars/all/vault.yml --vault-password-file .vault_pass

# Encrypt existing file
ansible-vault encrypt group_vars/all/secrets.yml --vault-password-file .vault_pass

# Decrypt vault file
ansible-vault decrypt group_vars/all/vault.yml --vault-password-file .vault_pass
```

### Inventory Management

```bash
# List all hosts in inventory
ansible-inventory --list

# Show host variables
ansible-inventory --host pve1

# Validate inventory syntax
ansible-inventory --list > /dev/null && echo "Inventory OK"

# List hosts in specific group
ansible-inventory --list --yaml | grep -A 10 proxmox
```



## 🏷️ Available Tags

```bash
# Run only specific components
--tags proxmox              # All Proxmox tasks
--tags virtualization       # Virtualization-related tasks  
--tags hypervisor           # Hypervisor configuration
--tags repositories         # Repository management
--tags system               # System configuration
--tags web_ui               # Web interface configuration

# Skip specific components
--skip-tags enterprise      # Skip enterprise repo changes
--skip-tags subscription    # Skip subscription modifications
```

## �️ Common Use Cases

### First-Time Proxmox Setup
```bash
# Check what would be changed (safe)
ansible-playbook playbooks/site.yml --tags proxmox --vault-password-file .vault_pass --check --diff

# Apply configuration
ansible-playbook playbooks/site.yml --tags proxmox --vault-password-file .vault_pass
```

### Update Repository Configuration
```bash
# Only update repositories
ansible-playbook playbooks/site.yml --tags repositories --vault-password-file .vault_pass
```

### Troubleshooting Connection Issues
```bash
# Test with maximum verbosity
ansible pve1 -m ping --vault-password-file .vault_pass -vvvv

# Test with different user
ansible pve1 -m ping -u root --ask-pass

# Check SSH connection manually
ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no root@192.168.178.5
```

### Validate Configuration Before Changes
```bash
# Syntax check
ansible-playbook playbooks/site.yml --syntax-check

# List tasks that would run
ansible-playbook playbooks/site.yml --tags proxmox --list-tasks

# List hosts that would be affected
ansible-playbook playbooks/site.yml --list-hosts
```

## 📋 What This Configuration Does

### Proxmox VE Configuration
- ✅ Disables enterprise repositories (requires subscription)
- ✅ Enables no-subscription repositories (free updates)
- ✅ Disables subscription notification popups
- ✅ Updates package cache
- ✅ Restarts necessary services
- ✅ Provides configuration summary

### Security Features
- 🔐 Encrypted password storage with Ansible Vault
- 🔐 Secure SSH authentication
- 🔐 No hardcoded credentials in files
- 🔐 Vault password file excluded from version control

## 🚨 Important Notes

- **Backup First**: Always backup your Proxmox configuration before running playbooks
- **Test Mode**: Use `--check` flag for dry-run before making actual changes  
- **Vault Security**: Keep your `.vault_pass` file secure and never commit it

- **SSH Access**: Ensure SSH password authentication is enabled on target hosts

## 🆘 Troubleshooting


