# =============================================================================
# HOMELAB ANSIBLE SETUP SCRIPT (PowerShell)
# =============================================================================
# Quick setup script for running Ansible playbooks on Windows

param(
    [Parameter(Position=0)]
    [ValidateSet("proxmox", "site", "check", "facts", "help")]
    [string]$Command = "help",
    
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$RemainingArgs
)

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green" 
    Yellow = "Yellow"
    Blue = "Cyan"
}

function Write-ColoredOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Colors[$Color]
}

Write-ColoredOutput "🏠 Homelab Ansible Configuration" "Blue"
Write-ColoredOutput "=================================" "Blue"

# Check if ansible is installed
try {
    ansible --version | Out-Null
    Write-ColoredOutput "✅ Ansible is installed" "Green"
} catch {
    Write-ColoredOutput "❌ Ansible is not installed. Please install it first." "Red"
    exit 1
}

# Check if inventory is configured
$inventoryContent = Get-Content "inventory/hosts.yml" -Raw
if ($inventoryContent -notmatch "ansible_host") {
    Write-ColoredOutput "⚠️  Please configure your hosts in inventory/hosts.yml first" "Yellow"
    Write-ColoredOutput "   Uncomment and update the host entries with your Proxmox server IPs" "Yellow"
    exit 1
}

Write-ColoredOutput "✅ Inventory appears to be configured" "Green"

# Function to run playbook
function Invoke-Playbook {
    param([string]$PlaybookName, [string[]]$Args)
    
    Write-ColoredOutput "`n🚀 Running playbook: $PlaybookName" "Blue"
    $argList = @("-i", "inventory/hosts.yml", "playbooks/$PlaybookName") + $Args
    & ansible-playbook @argList
}

# Main command logic
switch ($Command) {
    "proxmox" {
        Invoke-Playbook "proxmox.yml" $RemainingArgs
    }
    "site" {
        Invoke-Playbook "site.yml" $RemainingArgs
    }
    "check" {
        Write-ColoredOutput "`n🔍 Running connectivity check..." "Blue"
        ansible -i inventory/hosts.yml all -m ping
    }
    "facts" {
        Write-ColoredOutput "`n📊 Gathering system facts..." "Blue"
        ansible -i inventory/hosts.yml all -m setup
    }
    default {
        Write-ColoredOutput "`nUsage: .\run.ps1 {proxmox|site|check|facts}" "Yellow"
        Write-ColoredOutput "Commands:" "Yellow"
        Write-ColoredOutput "  proxmox  - Configure Proxmox hosts"
        Write-ColoredOutput "  site     - Run all playbooks"
        Write-ColoredOutput "  check    - Test connectivity to hosts"
        Write-ColoredOutput "  facts    - Gather system information"
        Write-ColoredOutput "`nExample: .\run.ps1 proxmox --check --diff" "Yellow"
    }
}