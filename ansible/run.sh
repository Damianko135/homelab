#!/bin/bash
# =============================================================================
# HOMELAB ANSIBLE SETUP SCRIPT
# =============================================================================
# Quick setup script for running Ansible playbooks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏠 Homelab Ansible Configuration${NC}"
echo -e "${BLUE}=================================${NC}"

# Check if ansible is installed
if ! command -v ansible &> /dev/null; then
    echo -e "${RED}❌ Ansible is not installed. Please install it first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Ansible is installed${NC}"

# Check if inventory is configured
if ! grep -q "ansible_host" inventory/hosts.yml; then
    echo -e "${YELLOW}⚠️  Please configure your hosts in inventory/hosts.yml first${NC}"
    echo -e "${YELLOW}   Uncomment and update the host entries with your Proxmox server IPs${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Inventory appears to be configured${NC}"

# Function to run playbook
run_playbook() {
    local playbook=$1
    echo -e "\n${BLUE}🚀 Running playbook: ${playbook}${NC}"
    ansible-playbook -i inventory/hosts.yml playbooks/${playbook} "$@"
}

# Check what to run
case "${1:-help}" in
    "proxmox")
        run_playbook "proxmox.yml" "${@:2}"
        ;;
    "site")
        run_playbook "site.yml" "${@:2}"
        ;;
    "check")
        echo -e "\n${BLUE}🔍 Running connectivity check...${NC}"
        ansible -i inventory/hosts.yml all -m ping
        ;;
    "facts")
        echo -e "\n${BLUE}📊 Gathering system facts...${NC}"
        ansible -i inventory/hosts.yml all -m setup
        ;;
    *)
        echo -e "\n${YELLOW}Usage: $0 {proxmox|site|check|facts}${NC}"
        echo -e "${YELLOW}Commands:${NC}"
        echo -e "  proxmox  - Configure Proxmox hosts"
        echo -e "  site     - Run all playbooks"
        echo -e "  check    - Test connectivity to hosts"
        echo -e "  facts    - Gather system information"
        echo -e "\n${YELLOW}Example: $0 proxmox --check --diff${NC}"
        ;;
esac