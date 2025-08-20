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

# Detect OS and Distribution
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Check if running in WSL
        if grep -qi microsoft /proc/version 2>/dev/null || grep -qi wsl /proc/version 2>/dev/null; then
            OS="WSL"
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                DISTRO=$ID
            else
                DISTRO="unknown"
            fi
        elif [ -f /etc/os-release ]; then
            . /etc/os-release
            OS="Linux"
            DISTRO=$ID
        else
            OS="Linux"
            DISTRO="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
        DISTRO="macos"
    else
        OS="Unknown"
        DISTRO="unknown"
    fi
}

# Get package manager
get_package_manager() {
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        PKG_UPDATE="apt update"
        PKG_INSTALL="apt install -y"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        PKG_UPDATE="yum update -y"
        PKG_INSTALL="yum install -y"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        PKG_UPDATE="dnf update -y"
        PKG_INSTALL="dnf install -y"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        PKG_UPDATE="pacman -Sy"
        PKG_INSTALL="pacman -S --noconfirm"
    elif command -v zypper &> /dev/null; then
        PKG_MANAGER="zypper"
        PKG_UPDATE="zypper refresh"
        PKG_INSTALL="zypper install -y"
    elif command -v apk &> /dev/null; then
        PKG_MANAGER="apk"
        PKG_UPDATE="apk update"
        PKG_INSTALL="apk add"
    else
        PKG_MANAGER="unknown"
    fi
}

# Set sudo command based on user
set_sudo_cmd() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "⚠️  Running as root user."
        SUDO_CMD=""
    else
        if command -v sudo &> /dev/null; then
            SUDO_CMD="sudo"
        elif command -v doas &> /dev/null; then
            SUDO_CMD="doas"
        else
            print_warning "⚠️  No sudo/doas found. Some commands may fail."
            SUDO_CMD=""
        fi
    fi
}

# Install wget/curl if missing
install_download_tools() {
    local tools_needed=()
    
    if ! command -v wget &> /dev/null; then
        tools_needed+=("wget")
    fi
    
    if ! command -v curl &> /dev/null; then
        tools_needed+=("curl")
    fi
    
    if [ ${#tools_needed[@]} -gt 0 ]; then
        print_status "📦 Installing required tools: ${tools_needed[*]}"
        $SUDO_CMD $PKG_UPDATE
        for tool in "${tools_needed[@]}"; do
            $SUDO_CMD $PKG_INSTALL $tool
        done
    fi
}

# Install firewall based on distribution
install_firewall() {
    case $DISTRO in
        ubuntu|debian)
            if ! command -v ufw &> /dev/null; then
                print_status "📦 Installing UFW firewall..."
                $SUDO_CMD $PKG_UPDATE
                $SUDO_CMD $PKG_INSTALL ufw
            fi
            FIREWALL_CMD="ufw"
            ;;
        centos|rhel|fedora|rocky|almalinux)
            if ! command -v firewall-cmd &> /dev/null; then
                print_status "📦 Installing firewalld..."
                $SUDO_CMD $PKG_INSTALL firewalld
                $SUDO_CMD systemctl enable firewalld
                $SUDO_CMD systemctl start firewalld
            fi
            FIREWALL_CMD="firewalld"
            ;;
        arch|manjaro)
            if ! command -v ufw &> /dev/null; then
                print_status "📦 Installing UFW firewall..."
                $SUDO_CMD $PKG_INSTALL ufw
            fi
            FIREWALL_CMD="ufw"
            ;;
        opensuse*|sles)
            if ! command -v firewall-cmd &> /dev/null; then
                print_status "📦 Installing firewalld..."
                $SUDO_CMD $PKG_INSTALL firewalld
                $SUDO_CMD systemctl enable firewalld
                $SUDO_CMD systemctl start firewalld
            fi
            FIREWALL_CMD="firewalld"
            ;;
        alpine)
            if ! command -v iptables &> /dev/null; then
                print_status "📦 Installing iptables..."
                $SUDO_CMD $PKG_INSTALL iptables
            fi
            FIREWALL_CMD="iptables"
            ;;
        *)
            print_warning "⚠️  Unknown distribution. Skipping firewall setup."
            FIREWALL_CMD="none"
            ;;
    esac
}

# Configure firewall rules
configure_firewall() {
    if [ "$OS" = "WSL" ]; then
        print_warning "🖥️  WSL detected. Skipping firewall configuration (Windows firewall handles this)."
        return
    fi

    case $FIREWALL_CMD in
        ufw)
            print_status "🛡️  Configuring UFW firewall..."
            $SUDO_CMD ufw allow 22/tcp comment 'SSH' 2>/dev/null || true
            $SUDO_CMD ufw allow 3000/tcp comment 'Local App Port' 2>/dev/null || true
            
            if ! $SUDO_CMD ufw status | grep -q "Status: active"; then
                print_warning "🔐 Enabling UFW firewall..."
                echo "y" | $SUDO_CMD ufw enable || true
                print_success "🛡️  UFW firewall enabled!"
            fi
            $SUDO_CMD ufw status numbered
            ;;
        firewalld)
            print_status "🛡️  Configuring firewalld..."
            $SUDO_CMD firewall-cmd --permanent --add-port=22/tcp 2>/dev/null || true
            $SUDO_CMD firewall-cmd --permanent --add-port=3000/tcp 2>/dev/null || true
            $SUDO_CMD firewall-cmd --reload 2>/dev/null || true
            print_success "🛡️  Firewalld configured!"
            $SUDO_CMD firewall-cmd --list-ports || true
            ;;
        iptables)
            print_status "🛡️  Configuring iptables..."
            $SUDO_CMD iptables -A INPUT -p tcp --dport 22 -j ACCEPT 2>/dev/null || true
            $SUDO_CMD iptables -A INPUT -p tcp --dport 3000 -j ACCEPT 2>/dev/null || true
            print_success "🛡️  Iptables configured!"
            ;;
        none)
            print_warning "⚠️  No firewall configured. Please manually open ports 22 and 3000."
            ;;
    esac
}

# Download and install cloudflared
install_cloudflared() {
    if command -v cloudflared &> /dev/null; then
        print_success "✅ Cloudflared is already installed!"
        CURRENT_VERSION=$(cloudflared --version 2>&1 | head -n1 || echo "Unknown version")
        echo -e "${GREEN}   Current version: ${NC}$CURRENT_VERSION"
        return
    fi

    print_status "📥 Installing Cloudflared..."
    
    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64|amd64)
            ARCH_SUFFIX="amd64"
            ;;
        aarch64|arm64)
            ARCH_SUFFIX="arm64"
            ;;
        armv7l|armv6l)
            ARCH_SUFFIX="arm"
            ;;
        *)
            print_error "❌ Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    case $DISTRO in
        ubuntu|debian)
            print_status "⬇️  Downloading cloudflared (.deb package)..."
            if wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH_SUFFIX}.deb"; then
                $SUDO_CMD dpkg -i "cloudflared-linux-${ARCH_SUFFIX}.deb"
            else
                print_error "❌ Failed to download cloudflared .deb package"
                exit 1
            fi
            ;;
        centos|rhel|fedora|rocky|almalinux)
            print_status "⬇️  Downloading cloudflared (.rpm package)..."
            if wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH_SUFFIX}.rpm"; then
                $SUDO_CMD rpm -i "cloudflared-linux-${ARCH_SUFFIX}.rpm" || $SUDO_CMD dnf install -y "cloudflared-linux-${ARCH_SUFFIX}.rpm"
            else
                print_error "❌ Failed to download cloudflared .rpm package"
                exit 1
            fi
            ;;
        *)
            # Generic binary installation for other distributions
            print_status "⬇️  Downloading cloudflared binary..."
            if wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH_SUFFIX}" -O cloudflared; then
                chmod +x cloudflared
                $SUDO_CMD mv cloudflared /usr/local/bin/cloudflared
            else
                print_error "❌ Failed to download cloudflared binary"
                exit 1
            fi
            ;;
    esac

    # Clean up
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    
    print_success "✅ Cloudflared installed successfully!"
}

# Check if lsof is available and install if needed
ensure_lsof() {
    if ! command -v lsof &> /dev/null; then
        print_status "📦 Installing lsof for port checking..."
        $SUDO_CMD $PKG_UPDATE
        case $PKG_MANAGER in
            apt)
                $SUDO_CMD $PKG_INSTALL lsof
                ;;
            yum|dnf)
                $SUDO_CMD $PKG_INSTALL lsof
                ;;
            pacman)
                $SUDO_CMD $PKG_INSTALL lsof
                ;;
            zypper)
                $SUDO_CMD $PKG_INSTALL lsof
                ;;
            apk)
                $SUDO_CMD $PKG_INSTALL lsof
                ;;
        esac
    fi
}

# Main execution
main() {
    # Display banner
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                 🌐 UNIVERSAL TUNNEL SETUP 🌐                  ║${NC}"
    echo -e "${BLUE}║           Works on ANY Linux/WSL/VPS Distribution!             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Detect system
    detect_os
    get_package_manager
    set_sudo_cmd

    print_status "🔍 System Detection:"
    echo -e "${CYAN}   OS: ${NC}$OS"
    echo -e "${CYAN}   Distribution: ${NC}$DISTRO"
    echo -e "${CYAN}   Package Manager: ${NC}$PKG_MANAGER"
    echo ""

    # Handle unknown package managers
    if [ "$PKG_MANAGER" = "unknown" ]; then
        print_error "❌ Unsupported package manager. Please install cloudflared manually."
        echo "Visit: https://github.com/cloudflare/cloudflared"
        exit 1
    fi

    # Install required tools
    install_download_tools

    # Configure firewall (skip for WSL)
    install_firewall
    configure_firewall

    # Install cloudflared
    install_cloudflared

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
    echo -e "${BLUE}║                        🚀 READY TO TUNNEL! 🚀                 ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    print_status "🎯 Setup completed! Here's what to do next:"
    echo ""
    echo -e "${YELLOW}📋 NEXT STEPS:${NC}"
    echo -e "${CYAN}1.${NC} Make sure your application is running on ${YELLOW}localhost:3000${NC}"
    echo -e "${CYAN}2.${NC} Run the tunnel command:"
    echo ""
    echo -e "${GREEN}   cloudflared tunnel --url http://localhost:3000${NC}"
    echo ""
    echo -e "${CYAN}3.${NC} Copy the generated URL and open it in your browser!"
    echo ""

    # Check if port 3000 is in use (if lsof is available)
    ensure_lsof
    if command -v lsof &> /dev/null; then
        print_status "🔍 Checking if port 3000 is currently in use..."
        if lsof -i:3000 &> /dev/null; then
            print_success "✅ Port 3000 is active! Starting tunnel automatically..."
            echo -e "${YELLOW}⚠️  Press Ctrl+C to stop the tunnel when done${NC}"
            echo ""
            sleep 2
            cloudflared tunnel --url http://localhost:3000
        else
            print_warning "⚠️  Port 3000 is not currently in use."
            echo -e "${YELLOW}   Start your application first, then run the tunnel command above.${NC}"
        fi
    else
        print_warning "⚠️  Cannot check port status. Run the tunnel command when your app is ready."
    fi

    echo ""
    echo -e "${BLUE}💡 Pro Tips:${NC}"
    echo -e "${CYAN}•${NC} Works on Ubuntu, Debian, CentOS, RHEL, Fedora, Arch, openSUSE, Alpine"
    echo -e "${CYAN}•${NC} Works on WSL (Windows Subsystem for Linux)"
    echo -e "${CYAN}•${NC} Works on any VPS provider (DigitalOcean, AWS, Google Cloud, etc.)"
    echo -e "${CYAN}•${NC} Automatically detects your system and uses appropriate package manager"
    echo ""
    echo -e "${GREEN}🌐 Telegram: https://t.me/TestnetTerminal${NC}"
    echo -e "${GREEN}🐦 Twitter/X: https://x.com/TestnetTerminal${NC}"
    echo -e "${GREEN}📞 Need Help?: https://t.me/Amit3701${NC}"
}

# Run main function
main "$@"
