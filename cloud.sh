#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${CYAN}[SUCCESS]${NC} $1"
}

# Display banner
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                 🌐 CLOUDFLARE TUNNEL SETUP 🌐                  ║${NC}"
echo -e "${BLUE}║              Access localhost:3000 from anywhere!             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
    exit 1
fi

# Check for sudo privileges
if ! sudo -n true 2>/dev/null; then
    print_status "This script requires sudo privileges. You may be prompted for your password."
fi

print_status "🔥 Setting up firewall rules..."

# Install UFW if not already installed
if ! command -v ufw &> /dev/null; then
    print_status "📦 Installing UFW (Uncomplicated Firewall)..."
    sudo apt update && sudo apt install ufw -y
else
    print_status "✅ UFW is already installed"
fi

# Configure firewall rules
print_status "🛡️  Configuring firewall rules..."
sudo ufw allow 22/tcp comment 'SSH' 2>/dev/null || true
sudo ufw allow 3000/tcp comment 'Local App Port' 2>/dev/null || true

# Enable UFW if not already enabled
if ! sudo ufw status | grep -q "Status: active"; then
    print_warning "🔐 Enabling UFW firewall..."
    echo "y" | sudo ufw enable
    print_success "🛡️  UFW firewall enabled successfully!"
else
    print_status "✅ UFW firewall is already active"
fi

# Show firewall status
print_status "📋 Current firewall rules:"
sudo ufw status numbered

echo ""
print_status "☁️  Setting up Cloudflare Tunnel..."

# Check if cloudflared is already installed
if command -v cloudflared &> /dev/null; then
    print_success "✅ Cloudflared is already installed!"
    CURRENT_VERSION=$(cloudflared --version 2>&1 | head -n1 || echo "Unknown version")
    echo -e "${GREEN}   Current version: ${NC}$CURRENT_VERSION"
else
    print_status "📥 Installing Cloudflared..."
    
    # Create temporary directory for download
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Download cloudflared
    print_status "⬇️  Downloading cloudflared..."
    if wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb; then
        print_status "📦 Installing cloudflared package..."
        sudo dpkg -i cloudflared-linux-amd64.deb
        print_success "✅ Cloudflared installed successfully!"
    else
        print_error "❌ Failed to download cloudflared"
        exit 1
    fi
    
    # Clean up
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
fi

# Verify installation
print_status "🔍 Verifying cloudflared installation..."
if cloudflared --version &> /dev/null; then
    VERSION_INFO=$(cloudflared --version 2>&1 | head -n1)
    print_success "✅ Cloudflared verification successful!"
    echo -e "${GREEN}   Version: ${NC}$VERSION_INFO"
else
    print_error "❌ Cloudflared installation verification failed"
    exit 1
fi

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                        🚀 READY TO TUNNEL! 🚀                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

print_status "🎯 Setup completed! Here's what to do next:"
echo ""
echo -e "${YELLOW}📋 NEXT STEPS:${NC}"
echo -e "${CYAN}1.${NC} Make sure your application is running on ${YELLOW}localhost:3000${NC}"
echo -e "${CYAN}2.${NC} Run the tunnel command below:"
echo ""
echo -e "${GREEN}   cloudflared tunnel --url http://localhost:3000${NC}"
echo ""
echo -e "${CYAN}3.${NC} Copy the generated tunnel URL (looks like: ${YELLOW}https://xxxx.trycloudflare.com${NC})"
echo -e "${CYAN}4.${NC} Open that URL in your browser from anywhere in the world!"
echo ""

# Check if port 3000 is currently in use
print_status "🔍 Checking if port 3000 is currently in use..."
if lsof -i:3000 &> /dev/null; then
    print_success "✅ Port 3000 is active! You can start the tunnel now."
    echo ""
    echo -e "${GREEN}🚀 Starting Cloudflare tunnel automatically...${NC}"
    echo -e "${YELLOW}⚠️  Press Ctrl+C to stop the tunnel when done${NC}"
    echo ""
    
    # Start the tunnel
    cloudflared tunnel --url http://localhost:3000
else
    print_warning "⚠️  Port 3000 is not currently in use."
    echo -e "${YELLOW}   Make sure your application is running first, then run:${NC}"
    echo -e "${GREEN}   cloudflared tunnel --url http://localhost:3000${NC}"
fi

echo ""
echo -e "${BLUE}💡 Pro Tips:${NC}"
echo -e "${CYAN}•${NC} The tunnel URL changes each time you restart cloudflared"
echo -e "${CYAN}•${NC} Keep the terminal open to maintain the tunnel"
echo -e "${CYAN}•${NC} You can tunnel any local port by changing the URL"
echo -e "${CYAN}•${NC} No need to configure DNS or SSL certificates!"
echo ""
echo -e "${GREEN}🌐 Telegram: https://t.me/TestnetTerminal${NC}"
echo -e "${GREEN}🐦 Twitter/X: https://x.com/TestnetTerminal${NC}"
echo -e "${GREEN}📞 Need Help?: https://t.me/Amit3701${NC}"
