#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Graceful exit function
graceful_exit() {
    echo ""
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                        👋 Thank You! 👋                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}🙏 Thank you for using Testnet Terminal's OneClick Setup!${NC}"
    echo ""
    echo -e "${YELLOW}🔗 Stay Connected:${NC}"
    echo -e "${BLUE}📱 Telegram: ${NC}https://t.me/TestnetTerminal"
    echo -e "${BLUE}🐙 GitHub: ${NC}https://github.com/TestnetTerminal" 
    echo -e "${BLUE}🐦 Twitter: ${NC}https://x.com/TestnetTerminal"
    echo -e "${BLUE}🆘 Support: ${NC}https://t.me/Amit3701"
    echo ""
    echo -e "${GREEN}✨ Happy Testing! See you next time! ✨${NC}"
    echo ""
    exit 0
}

# Set trap to catch Ctrl+C and other signals
trap 'graceful_exit' INT TERM

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

# Display main banner
show_banner() {
    clear
    echo ""
    echo -e "${BLUE}████████╗███████╗███████╗████████╗███╗   ██╗███████╗████████╗    ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗     ${NC}"
    echo -e "${BLUE}╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝████╗  ██║██╔════╝╚══██╔══╝    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║     ${NC}"
    echo -e "${BLUE}   ██║   █████╗  ███████╗   ██║   ██╔██╗ ██║█████╗     ██║          ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║     ${NC}"
    echo -e "${BLUE}   ██║   ██╔══╝  ╚════██║   ██║   ██║╚██╗██║██╔══╝     ██║          ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     ${NC}"
    echo -e "${BLUE}   ██║   ███████╗███████║   ██║   ██║ ╚████║███████╗   ██║          ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗${NC}"
    echo -e "${BLUE}   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═══╝╚══════╝   ╚═╝          ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝${NC}"
    echo ""
    echo -e "${WHITE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║              🎉 Thank you for using our One-Click Setup! 🎉       ║${NC}"
    echo -e "${WHITE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}🔗 Our Links:${NC}"
    echo -e "${YELLOW}📱 Telegram: ${NC}https://t.me/TestnetTerminal"
    echo -e "${YELLOW}🐙 GitHub: ${NC}https://github.com/TestnetTerminal"
    echo -e "${YELLOW}🐦 Twitter/X: ${NC}https://x.com/TestnetTerminal"
    echo -e "${YELLOW}🆘 Support: ${NC}https://t.me/Amit3701"
    echo ""
}

# Display menu
show_menu() {
    echo -e "${WHITE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║            🚀 Gensyn AI RL-Swarm Node OneClick Setup by Amit     ║${NC}"
    echo -e "${WHITE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Please select an option:${NC}"
    echo ""
    echo -e "${YELLOW}1. 🛠️  Install Gensyn AI Node${NC}"
    echo -e "${YELLOW}2. 🛜 Install Cloudflared and Tunnel${NC}"
    echo -e "${YELLOW}3. ⬇️  Download Swarm.pem File${NC}"
    echo -e "${PURPLE}4. 🔄 Upgrade Gensyn AI Node${NC}"
    echo -e "${PURPLE}5. 🗑️  Delete Gensyn AI Node${NC}"
    echo -e "${RED}6. ❌ Exit${NC}"
    echo ""
    echo -n -e "${WHITE}Select an option (1-6): ${NC}"
}

# System detection functions
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
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
    else
        OS="Unknown"
        DISTRO="unknown"
    fi
}

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
    else
        PKG_MANAGER="apt"
        PKG_UPDATE="apt update"
        PKG_INSTALL="apt install -y"
    fi
}

set_sudo_cmd() {
    if [[ $EUID -eq 0 ]]; then
        SUDO_CMD=""
    else
        if command -v sudo &> /dev/null; then
            SUDO_CMD="sudo"
        else
            SUDO_CMD=""
        fi
    fi
}

# Install Gensyn AI Node
install_gensyn_node() {
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                    🛠️ Installing Gensyn AI Node 🛠️               ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    print_status "📦 Updating system and installing dependencies..."
    $SUDO_CMD $PKG_UPDATE && $SUDO_CMD $PKG_INSTALL python3 python3-venv python3-pip curl wget screen git lsof

    # Install Node.js if not installed
    if ! command -v node &>/dev/null; then
        print_status "🔧 Installing Node.js..."
        if [ "$PKG_MANAGER" = "apt" ]; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO_CMD -E bash -
            $SUDO_CMD $PKG_UPDATE && $SUDO_CMD $PKG_INSTALL nodejs
        else
            $SUDO_CMD $PKG_INSTALL nodejs npm
        fi
    else
        print_status "✅ Node.js is already installed ($(node --version))"
    fi

    # Install Yarn if not installed
    if ! command -v yarn &>/dev/null; then
        print_status "🔧 Installing Yarn..."
        if [ "$PKG_MANAGER" = "apt" ]; then
            curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | $SUDO_CMD tee /usr/share/keyrings/yarnkey.gpg >/dev/null
            echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | $SUDO_CMD tee /etc/apt/sources.list.d/yarn.list
            $SUDO_CMD $PKG_UPDATE && $SUDO_CMD $PKG_INSTALL yarn
        else
            $SUDO_CMD npm install -g yarn
        fi
    else
        print_status "✅ Yarn is already installed ($(yarn --version))"
    fi

    # Check if screen session already exists
    if screen -list | grep -q "gensyn"; then
        print_warning "Screen session 'gensyn' already exists. Terminating it..."
        screen -S gensyn -X quit 2>/dev/null || true
    fi

    print_status "🖥️ Starting screen session 'gensyn'..."

    # Create the screen session with the setup commands
    screen -S gensyn -dm bash -c "
    set -e

    echo '📁 Setting up RL-SWARM...'

    # Remove existing directory if it exists
    if [ -d 'rl-swarm' ]; then
        echo '🗑️  Removing existing rl-swarm directory...'
        rm -rf rl-swarm
    fi

    echo '📁 Cloning RL-SWARM repo...'
    git clone https://github.com/gensyn-ai/rl-swarm.git
    cd rl-swarm

    echo '🐍 Setting up Python virtual environment...'
    python3 -m venv .venv
    source .venv/bin/activate

    echo '📦 Installing Python packages...'
    pip install --upgrade pip
    pip install --force-reinstall transformers==4.51.3 trl==0.19.1

    echo '📋 Installed packages:'
    pip freeze

    echo ''
    echo '🔑 Checking for swarm.pem file...'
    if [ -f 'swarm.pem' ]; then
        echo '✅ Found swarm.pem file, proceeding with authentication...'
    else
        echo '⚠️  No swarm.pem found in the current directory.'
        echo '📂 Please copy your swarm.pem file to: \$(pwd)'
        echo '📋 Full path: \$(pwd)/swarm.pem'
        echo ''
        echo '⏳ Waiting 50 seconds for you to copy the file...'
        echo '✅ Press 1 and Enter if you have copied the file to continue immediately'
        echo '⏭️  Or wait 50 seconds to continue automatically'
        echo ''
        
        # Countdown with user input option
        for i in \$(seq 50 -1 1); do
            printf \"\\r⏰ Waiting: %02d seconds (Press 1 to continue)\" \$i
            
            # Check for user input with timeout
            if read -t 1 -n 1 user_input 2>/dev/null; then
                if [ \"\$user_input\" = \"1\" ]; then
                    echo \"\"
                    echo \"⚡ Continuing early...\"
                    break
                fi
            fi
        done
        echo \"\"
        
        # Check again for swarm.pem after the wait
        if [ -f 'swarm.pem' ]; then
            echo '✅ Great! Found swarm.pem file, proceeding with authentication...'
        else
            echo '⚠️  Still no swarm.pem found. Continuing without authentication...'
            echo '🔄 You can add it later and restart the swarm.'
        fi
    fi

    echo ''
    echo '🚀 Starting the swarm node...'
    chmod +x run_rl_swarm.sh 2>/dev/null || true

    # Run the swarm with proper error handling
    if ./run_rl_swarm.sh; then
        echo '✅ Swarm completed successfully.'
    else
        echo '❌ Swarm exited with an error or was interrupted.'
    fi

    echo ''
    echo '🔄 Swarm process ended. Screen session will remain active.'
    echo '📋 To restart the swarm, run: ./run_rl_swarm.sh'
    echo '🚪 To exit this screen session, type: exit'
    echo ''

    # Keep the screen session alive
    while true; do
        echo '⏳ Screen session active. Press Ctrl+C to exit or run commands...'
        sleep 30
    done
    "

    sleep 3

    echo ""
    print_success "✅ Gensyn AI Node setup completed!"
    echo -e "${YELLOW}🔍 To attach to the screen session: ${NC}screen -r gensyn"
    echo -e "${YELLOW}🔍 To detach from screen session: ${NC}Press Ctrl+A then D"
    echo -e "${YELLOW}🔍 To terminate the session: ${NC}screen -S gensyn -X quit"
    echo ""
    echo -e "${GREEN}📝 Next Steps:${NC}"
    echo "1. If you have a swarm.pem file, copy it to the rl-swarm directory"
    echo "2. Attach to the screen session to monitor progress: screen -r gensyn"
    echo "3. The swarm node should start automatically"
    echo ""
    
    read -p "Press Enter to return to main menu..."
}

# Install cloudflared - FIXED VERSION
install_cloudflared() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                🛜 Installing Cloudflared & Tunnel 🛜             ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    detect_os
    get_package_manager
    set_sudo_cmd

    print_status "🔍 System: $OS - $DISTRO"
    print_status "📦 Package Manager: $PKG_MANAGER"
    echo ""

    LOCAL_URL="http://localhost:3000"

    # Check port 3000 with multiple methods
    print_status "🔍 Checking if port 3000 is active..."
    PORT_3000_ACTIVE=false
    PORT_CHECK_METHOD=""
    
    # Method 1: lsof
    if command -v lsof &> /dev/null; then
        if lsof -i:3000 &> /dev/null; then
            PORT_3000_ACTIVE=true
            PORT_CHECK_METHOD="lsof"
            # Get process info
            PORT_INFO=$(lsof -i:3000 2>/dev/null | tail -n +2 | head -1)
            if [ -n "$PORT_INFO" ]; then
                PROCESS_NAME=$(echo "$PORT_INFO" | awk '{print $1}')
                PID=$(echo "$PORT_INFO" | awk '{print $2}')
            fi
        fi
    fi
    
    # Method 2: netstat (fallback)
    if [ "$PORT_3000_ACTIVE" = false ] && command -v netstat &> /dev/null; then
        if netstat -tuln 2>/dev/null | grep -q ":3000 "; then
            PORT_3000_ACTIVE=true
            PORT_CHECK_METHOD="netstat"
        fi
    fi
    
    # Method 3: ss (fallback)
    if [ "$PORT_3000_ACTIVE" = false ] && command -v ss &> /dev/null; then
        if ss -tuln 2>/dev/null | grep -q ":3000 "; then
            PORT_3000_ACTIVE=true
            PORT_CHECK_METHOD="ss"
        fi
    fi
    
    # Method 4: curl test (fallback)
    if [ "$PORT_3000_ACTIVE" = false ]; then
        if curl -s --connect-timeout 2 http://localhost:3000 &>/dev/null; then
            PORT_3000_ACTIVE=true
            PORT_CHECK_METHOD="curl"
        fi
    fi
    
    if [ "$PORT_3000_ACTIVE" = true ]; then
        print_success "✅ Port 3000 is active and ready for tunneling!"
        print_status "📋 Detection method: $PORT_CHECK_METHOD"
        if [ -n "$PROCESS_NAME" ] && [ -n "$PID" ]; then
            print_status "📋 Process: $PROCESS_NAME (PID: $PID)"
        fi
        echo ""
    else
        print_warning "⚠️ Port 3000 detection: Not active"
        print_status "💡 No application detected on port 3000"
        echo ""
    fi

    # Install required tools
    print_status "📦 Installing required tools..."
    $SUDO_CMD $PKG_UPDATE
    $SUDO_CMD $PKG_INSTALL curl wget lsof

    # Configure firewall (skip for WSL)
    if [ "$OS" != "WSL" ]; then
        print_status "🛡️ Configuring firewall..."
        if [ "$PKG_MANAGER" = "apt" ]; then
            if ! command -v ufw &> /dev/null; then
                $SUDO_CMD $PKG_INSTALL ufw
            fi
            $SUDO_CMD ufw allow 22/tcp 2>/dev/null || true
            $SUDO_CMD ufw allow 3000/tcp 2>/dev/null || true
            echo "y" | $SUDO_CMD ufw enable 2>/dev/null || true
            print_success "🛡️ UFW firewall configured!"
        else
            print_warning "⚠️ Please manually open ports 22 and 3000 in your firewall"
        fi
    else
        print_status "🖥️ WSL detected. Skipping firewall configuration."
    fi

    # Install cloudflared
    if command -v cloudflared &> /dev/null; then
        print_success "✅ Cloudflared is already installed!"
        VERSION_INFO=$(cloudflared --version 2>&1 | head -n1)
        echo -e "${GREEN}   Version: ${NC}$VERSION_INFO"
    else
        print_status "📥 Installing Cloudflared..."
        
        # Detect architecture
        ARCH=$(uname -m)
        case $ARCH in
            x86_64|amd64) ARCH_SUFFIX="amd64" ;;
            aarch64|arm64) ARCH_SUFFIX="arm64" ;;
            armv7l|armv6l) ARCH_SUFFIX="arm" ;;
            *) print_error "❌ Unsupported architecture: $ARCH"; return 1 ;;
        esac

        # Get current user's home directory
        CURRENT_USER=$(whoami)
        USER_HOME="/home/$CURRENT_USER"
        
        # FIXED: Download directly to user's home directory
        if [ "$PKG_MANAGER" = "apt" ]; then
            print_status "📥 Downloading cloudflared .deb package to $USER_HOME..."
            wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH_SUFFIX}.deb" -O "$USER_HOME/cloudflared-linux-${ARCH_SUFFIX}.deb"
            
            if [ -f "$USER_HOME/cloudflared-linux-${ARCH_SUFFIX}.deb" ]; then
                print_status "📦 Installing cloudflared package..."
                $SUDO_CMD dpkg -i "$USER_HOME/cloudflared-linux-${ARCH_SUFFIX}.deb"
                print_success "✅ Cloudflared .deb file saved to: $USER_HOME/cloudflared-linux-${ARCH_SUFFIX}.deb"
            else
                print_error "❌ Failed to download cloudflared package"
                return 1
            fi
        else
            # For non-apt systems
            print_status "📥 Downloading cloudflared binary to $USER_HOME..."
            wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH_SUFFIX}" -O "$USER_HOME/cloudflared"
            
            if [ -f "$USER_HOME/cloudflared" ]; then
                chmod +x "$USER_HOME/cloudflared"
                print_status "📦 Installing cloudflared to /usr/local/bin..."
                $SUDO_CMD cp "$USER_HOME/cloudflared" /usr/local/bin/cloudflared
                print_success "✅ Cloudflared binary saved to: $USER_HOME/cloudflared"
            else
                print_error "❌ Failed to download cloudflared binary"
                return 1
            fi
        fi

        print_success "✅ Cloudflared installed successfully!"
    fi

    # Verify installation
    if cloudflared --version &> /dev/null; then
        VERSION_INFO=$(cloudflared --version 2>&1 | head -n1)
        print_success "✅ Installation verified! Version: $VERSION_INFO"
    else
        print_error "❌ Installation verification failed"
        return 1
    fi

    echo ""
    
    # Always offer tunneling option regardless of detection
    if [ "$PORT_3000_ACTIVE" = true ]; then
        echo -e "${GREEN}🚀 Port 3000 detected as active! Ready to tunnel...${NC}"
    else
        echo -e "${YELLOW}⚠️ Port 3000 not detected, but you can still try tunneling${NC}"
        print_status "💡 Detection might be incorrect or service may be starting up"
    fi
    
    echo -e "${CYAN}💡 The tunnel will forward external traffic to localhost:3000${NC}"
    echo -e "${YELLOW}⚠️ This creates a public URL accessible from anywhere${NC}"
    echo ""
    echo -n -e "${WHITE}Start Cloudflare tunnel for localhost:3000? (Y/n): ${NC}"
    read -r confirm
    
    case "${confirm,,}" in
        n|no)
            print_warning "🚫 Tunnel cancelled by user."
            echo ""
            echo -e "${CYAN}💡 To start tunnel manually later:${NC}"
            echo -e "${GREEN}cloudflared tunnel --url ${LOCAL_URL}${NC}"
            echo ""
            if [ "$PORT_3000_ACTIVE" = false ]; then
                print_status "📝 If port 3000 is actually running:"
                echo "• Make sure Gensyn node is started (option 1)"
                echo "• Check with: lsof -i:3000 or netstat -tuln | grep 3000"
                echo "• Or simply try the tunnel anyway - it will show if connection fails"
            fi
            ;;
        *|y|yes|"")
            echo ""
            if [ "$PORT_3000_ACTIVE" = false ]; then
                print_warning "🔍 Port detection showed inactive, but proceeding with tunnel..."
                print_status "💡 If nothing is on port 3000, the tunnel will show connection errors"
            fi
            print_success "🚀 Starting Cloudflare tunnel for localhost:3000..."
            echo -e "${YELLOW}⚠️ Press Ctrl+C to stop the tunnel${NC}"
            echo -e "${CYAN}📋 The tunnel URL will appear below - use it to access your service remotely${NC}"
            echo ""
            sleep 2
            cloudflared tunnel --url ${LOCAL_URL}
            ;;
    esac
    
    echo ""
    read -p "Press Enter to return to main menu..."
}

# Download Swarm.pem file
download_swarm_pem() {
    echo ""
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                    ⬇️ Download Swarm.pem File ⬇️                 ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Get the current username
    CURRENT_USER=$(whoami)
    
    # Define the rl-swarm directory path
    RL_SWARM_DIR="/home/$CURRENT_USER/rl-swarm"
    SWARM_PEM_PATH="$RL_SWARM_DIR/swarm.pem"
    
    print_status "🔍 Checking for swarm.pem file..."
    echo -e "${CYAN}📂 Looking in: ${NC}$RL_SWARM_DIR"
    echo ""
    
    # Check if rl-swarm directory exists
    if [ ! -d "$RL_SWARM_DIR" ]; then
        print_error "❌ rl-swarm directory not found at: $RL_SWARM_DIR"
        echo ""
        echo -e "${YELLOW}💡 Possible solutions:${NC}"
        echo "1. Run option 1 first to install Gensyn AI Node"
        echo "2. Make sure you're in the correct user account"
        echo "3. Check if rl-swarm is installed in a different location"
        echo ""
        read -p "Press Enter to return to main menu..."
        return
    fi
    
    # Check if swarm.pem exists
    if [ -f "$SWARM_PEM_PATH" ]; then
        print_success "✅ swarm.pem found at: $SWARM_PEM_PATH"
        
        # Show file info
        FILE_SIZE=$(du -h "$SWARM_PEM_PATH" | cut -f1)
        FILE_DATE=$(ls -la "$SWARM_PEM_PATH" | awk '{print $6, $7, $8}')
        
        echo ""
        echo -e "${CYAN}📄 File Information:${NC}"
        echo -e "${CYAN}   Size: ${NC}$FILE_SIZE"
        echo -e "${CYAN}   Modified: ${NC}$FILE_DATE"
        echo -e "${CYAN}   Location: ${NC}$SWARM_PEM_PATH"
        echo ""
        
        # Ask if user wants to create a download server for the file
        echo -n -e "${WHITE}Do you want to create a download server for swarm.pem? (y/N): ${NC}"
        read -r download_choice
        
        case "${download_choice,,}" in
            y|yes)
                print_status "🌐 Setting up download server for swarm.pem..."
                
                # Find an available port (try 8080, 8081, 8082, etc.)
                DOWNLOAD_PORT=8080
                while lsof -i:$DOWNLOAD_PORT &>/dev/null; do
                    ((DOWNLOAD_PORT++))
                    if [ $DOWNLOAD_PORT -gt 8090 ]; then
                        print_error "❌ No available ports found between 8080-8090"
                        return
                    fi
                done
                
                print_status "🔍 Using port: $DOWNLOAD_PORT"
                
                # Create a temporary directory for the download server
                TEMP_DOWNLOAD_DIR=$(mktemp -d)
                cd "$TEMP_DOWNLOAD_DIR"
                
                # Copy the swarm.pem file to temp directory
                cp "$SWARM_PEM_PATH" "./swarm.pem"
                
                # Create a download page
                cat > index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Download swarm.pem - Testnet Terminal</title>
    <meta http-equiv="refresh" content="3;url=swarm.pem">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            text-align: center; 
            padding: 20px; 
            background: #080c14;
            color: #19c1ff; 
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }
        
        /* Animated background particles */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
        }
        
        .particle {
            position: absolute;
            width: 2px;
            height: 2px;
            background: #19c1ff;
            border-radius: 50%;
            opacity: 0.6;
            animation: float 8s infinite ease-in-out;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) translateX(0px); opacity: 0.6; }
            50% { transform: translateY(-20px) translateX(10px); opacity: 1; }
        }
        
        /* Watermark */
        .watermark {
            position: fixed;
            bottom: 10px;
            right: 10px;
            font-size: 10px;
            color: rgba(25, 193, 255, 0.3);
            z-index: 1000;
            font-weight: bold;
        }
        
        .container { 
            max-width: 90%;
            width: 500px;
            margin: 0 auto; 
            background: rgba(25, 193, 255, 0.05);
            padding: 30px 20px;
            border-radius: 15px;
            border: 1px solid rgba(25, 193, 255, 0.2);
            box-shadow: 0 8px 32px rgba(25, 193, 255, 0.1);
            backdrop-filter: blur(10px);
            position: relative;
            z-index: 10;
        }
        
        .logo { 
            font-size: 4em; 
            margin-bottom: 20px;
            background: linear-gradient(45deg, #19c1ff, #0066cc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            filter: drop-shadow(0 0 10px rgba(25, 193, 255, 0.3));
        }
        
        h1 {
            color: #19c1ff;
            margin-bottom: 10px;
            font-size: 1.8em;
            font-weight: 600;
        }
        
        h3 {
            color: rgba(25, 193, 255, 0.8);
            margin-bottom: 30px;
            font-weight: 400;
        }
        
        .download-btn { 
            background: linear-gradient(45deg, #19c1ff, #0066cc);
            color: #080c14; 
            padding: 15px 30px; 
            text-decoration: none; 
            border-radius: 25px; 
            font-size: 16px; 
            font-weight: 600;
            display: inline-block;
            margin: 20px 0;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(25, 193, 255, 0.3);
            border: none;
            cursor: pointer;
        }
        
        .download-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(25, 193, 255, 0.5);
            background: linear-gradient(45deg, #0066cc, #19c1ff);
        }
        
        .info-box { 
            background: rgba(25, 193, 255, 0.08); 
            padding: 20px; 
            border-radius: 10px; 
            margin: 20px 0; 
            border-left: 3px solid #19c1ff;
            text-align: left;
        }
        
        .info-box h4 {
            color: #19c1ff;
            margin-bottom: 10px;
            font-size: 1.1em;
        }
        
        .info-box p {
            color: rgba(25, 193, 255, 0.9);
            line-height: 1.6;
            margin-bottom: 8px;
        }
        
        .warning {
            background: rgba(255, 193, 7, 0.1);
            border-left: 3px solid #ffc107;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
        }
        
        .warning h4 {
            color: #ffc107;
            margin-bottom: 10px;
        }
        
        .warning p {
            color: rgba(255, 193, 7, 0.9);
            line-height: 1.5;
        }
        
        .countdown {
            font-size: 1.8em;
            color: #19c1ff;
            font-weight: bold;
            text-shadow: 0 0 10px rgba(25, 193, 255, 0.5);
        }
        
        .status-message {
            color: #19c1ff;
            font-size: 1.1em;
            margin: 20px 0;
            padding: 15px;
            background: rgba(25, 193, 255, 0.05);
            border-radius: 8px;
            border: 1px solid rgba(25, 193, 255, 0.2);
        }
        
        .social-links {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(25, 193, 255, 0.2);
        }
        
        .social-links a {
            color: #19c1ff;
            text-decoration: none;
            margin: 0 10px;
            padding: 8px 15px;
            border: 1px solid rgba(25, 193, 255, 0.3);
            border-radius: 20px;
            display: inline-block;
            margin: 5px;
            transition: all 0.3s ease;
            font-size: 0.9em;
        }
        
        .social-links a:hover {
            background: rgba(25, 193, 255, 0.1);
            border-color: #19c1ff;
            transform: translateY(-1px);
        }
        
        /* Mobile responsiveness */
        @media (max-width: 768px) {
            body { padding: 10px; }
            .container { 
                padding: 20px 15px; 
                width: 95%;
                margin-top: 20px;
            }
            .logo { font-size: 3em; }
            h1 { font-size: 1.5em; }
            .download-btn { 
                padding: 12px 25px; 
                font-size: 15px; 
                width: 90%;
            }
            .info-box, .warning { 
                padding: 15px; 
                margin: 15px 0; 
            }
            .countdown { font-size: 1.5em; }
        }
        
        @media (max-width: 480px) {
            .container { width: 98%; }
            .logo { font-size: 2.5em; }
            h1 { font-size: 1.3em; }
            .download-btn { width: 100%; }
        }
    </style>
    <script>
        // Create animated background particles
        function createParticles() {
            const bgAnimation = document.querySelector('.bg-animation');
            for (let i = 0; i < 50; i++) {
                const particle = document.createElement('div');
                particle.className = 'particle';
                particle.style.left = Math.random() * 100 + '%';
                particle.style.top = Math.random() * 100 + '%';
                particle.style.animationDelay = Math.random() * 8 + 's';
                particle.style.animationDuration = (Math.random() * 4 + 6) + 's';
                bgAnimation.appendChild(particle);
            }
        }
        
        let countdown = 3;
        function updateCountdown() {
            const countdownEl = document.getElementById('countdown');
            const messageEl = document.getElementById('message');
            
            if (countdownEl) {
                countdownEl.textContent = countdown;
            }
            
            if (countdown > 0) {
                countdown--;
                setTimeout(updateCountdown, 1000);
            } else {
                if (messageEl) {
                    messageEl.innerHTML = '<div class="status-message">🚀 Download Starting...</div>';
                }
                // Trigger download
                window.location.href = 'swarm.pem';
            }
        }
        
        window.onload = function() {
            createParticles();
            updateCountdown();
        };
    </script>
</head>
<body>
    <div class="bg-animation"></div>
    
    <div class="watermark">
        Testnet Terminal © 2025
    </div>
    
    <div class="container">
        <div class="logo">🔐</div>
        <h1>Swarm.pem Ready for Download</h1>
        <h3>Testnet Terminal - Gensyn AI</h3>
        
        <div class="info-box">
            <h4>📄 File Information</h4>
            <p><strong>File:</strong> swarm.pem</p>
            <p><strong>Source:</strong> $SWARM_PEM_PATH</p>
            <p><strong>Size:</strong> $FILE_SIZE</p>
            <p><strong>Modified:</strong> $FILE_DATE</p>
        </div>
        
        <div id="message">
            <div class="status-message">Download will start automatically in <span id="countdown" class="countdown">3</span> seconds...</div>
        </div>
        
        <a href="swarm.pem" download="swarm.pem" class="download-btn">
            📥 Click Here to Download Now
        </a>
        
        <div class="warning">
            <h4>⚠️ Security Notice</h4>
            <p>Keep your swarm.pem file secure and don't share it publicly!</p>
            <p>This download server is temporary and will close when you stop it.</p>
        </div>
        
        <div class="info-box">
            <h4>📋 After downloading:</h4>
            <p>1. Save the file securely on your local machine</p>
            <p>2. Use it in your local rl-swarm setup when needed</p>
            <p>3. Never share this file with anyone</p>
        </div>
        
        <div class="social-links">
            <a href="https://t.me/TestnetTerminal" target="_blank">📱 Telegram</a>
            <a href="https://github.com/TestnetTerminal" target="_blank">🐙 GitHub</a>
            <a href="https://x.com/TestnetTerminal" target="_blank">🐦 Twitter</a>
        </div>
    </div>
</body>
</html>
EOF

                print_success "🚀 Starting download server on port $DOWNLOAD_PORT..."
                print_status "📥 Server will serve your swarm.pem file for download"
                echo -e "${YELLOW}⚠️ Press Ctrl+C to stop the server${NC}"
                echo ""
                
                if command -v python3 &> /dev/null; then
                    # Start Python HTTP server in background
                    python3 -m http.server $DOWNLOAD_PORT > /dev/null 2>&1 &
                    SERVER_PID=$!
                    sleep 2
                    
                    # Check if server started successfully
                    if kill -0 $SERVER_PID 2>/dev/null; then
                        if command -v cloudflared &> /dev/null; then
                            print_success "🌐 Starting Cloudflare tunnel for swarm.pem download..."
                            echo -e "${CYAN}📋 The tunnel will provide a secure download link${NC}"
                            echo -e "${GREEN}💡 Open the tunnel URL in your browser to download swarm.pem${NC}"
                            echo ""
                            
                            # Start cloudflared tunnel pointing to our download server
                            cloudflared tunnel --url http://localhost:$DOWNLOAD_PORT
                            
                            # Clean up when tunnel stops
                            kill $SERVER_PID 2>/dev/null || true
                        else
                            print_warning "⚠️ Cloudflared not found. Server running locally on port $DOWNLOAD_PORT"
                            echo "Install cloudflared first using option 2 for external access."
                            echo -e "${CYAN}📋 Local access: ${NC}http://localhost:$DOWNLOAD_PORT"
                            echo -e "${CYAN}📋 Direct file: ${NC}http://localhost:$DOWNLOAD_PORT/swarm.pem"
                            echo ""
                            echo "Press Ctrl+C to stop the server..."
                            wait $SERVER_PID
                        fi
                    else
                        print_error "❌ Failed to start HTTP server"
                    fi
                else
                    print_error "❌ Python3 not found. Cannot start download server."
                    echo ""
                    print_status "📁 Alternative methods to get your file:"
                    echo -e "${CYAN}1. SCP: ${NC}scp user@yourserver:$SWARM_PEM_PATH ./swarm.pem"
                    echo -e "${CYAN}2. Cat and copy: ${NC}cat $SWARM_PEM_PATH"
                    echo -e "${CYAN}3. Base64 encode: ${NC}base64 $SWARM_PEM_PATH"
                fi
                
                # Clean up temporary directory
                cd "$RL_SWARM_DIR"
                rm -rf "$TEMP_DOWNLOAD_DIR"
                ;;
            *)
                print_status "📁 swarm.pem is available at: $SWARM_PEM_PATH"
                echo ""
                echo -e "${YELLOW}💡 Alternative download methods:${NC}"
                echo -e "${CYAN}1. SCP Command: ${NC}"
                echo "   scp $CURRENT_USER@YOUR_SERVER_IP:$SWARM_PEM_PATH ./swarm.pem"
                echo ""
                echo -e "${CYAN}2. Display file content (copy manually): ${NC}"
                echo -n -e "${WHITE}Show file content? (y/N): ${NC}"
                read -r show_content
                if [[ "${show_content,,}" == "y" || "${show_content,,}" == "yes" ]]; then
                    echo ""
                    echo -e "${YELLOW}📄 swarm.pem content:${NC}"
                    echo -e "${CYAN}════════════════════════════════════════${NC}"
                    cat "$SWARM_PEM_PATH"
                    echo -e "${CYAN}════════════════════════════════════════${NC}"
                    echo -e "${GREEN}💡 Copy the above content and save as 'swarm.pem' on your local machine${NC}"
                fi
                ;;
        esac
        
    else
        print_error "❌ swarm.pem not found at: $SWARM_PEM_PATH"
        echo ""
        echo -e "${YELLOW}💡 To get your swarm.pem file:${NC}"
        echo "1. Make sure you've run option 1 (Install Gensyn AI Node) first"
        echo "2. Copy your swarm.pem file to: $RL_SWARM_DIR/"
        echo "3. Download your swarm.pem from: https://app.gensyn.ai/"
        echo ""
        echo -e "${CYAN}📋 Current rl-swarm directory contents:${NC}"
        if [ -d "$RL_SWARM_DIR" ]; then
            ls -la "$RL_SWARM_DIR" | head -10
        fi
    fi
    
    echo ""
    read -p "Press Enter to return to main menu..."
}

# Upgrade Gensyn AI Node
upgrade_gensyn_node() {
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                    🔄 Upgrading Gensyn AI Node 🔄                ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Get current user and check for rl-swarm directory
    CURRENT_USER=$(whoami)
    RL_SWARM_DIR="/home/$CURRENT_USER/rl-swarm"
    
    # Check if rl-swarm directory exists
    if [ ! -d "$RL_SWARM_DIR" ]; then
        print_error "❌ rl-swarm directory not found at: $RL_SWARM_DIR"
        echo ""
        print_status "💡 Please run option 1 first to install Gensyn AI Node"
        echo ""
        read -p "Press Enter to return to main menu..."
        return
    fi
    
    # Check if screen session exists
    if ! screen -list | grep -q "gensyn"; then
        print_warning "⚠️ Gensyn screen session not found"
        print_status "💡 The node might not be running or using a different session name"
        echo ""
    else
        print_success "✅ Found Gensyn screen session"
    fi
    
    print_status "📁 Found rl-swarm directory: $RL_SWARM_DIR"
    echo ""
    
    print_status "🔄 Upgrade process will:"
    echo "1. Stop the current Gensyn node (if running)"
    echo "2. Pull the latest updates from GitHub"
    echo "3. Clean and reset the repository"
    echo "4. Restart the node with latest version"
    echo ""
    
    print_warning "⚠️ This will interrupt any running training/tasks"
    echo ""
    echo -n -e "${WHITE}Continue with upgrade? (Y/n): ${NC}"
    read -r confirm
    
    case "${confirm,,}" in
        n|no)
            print_warning "🚫 Upgrade cancelled by user."
            echo ""
            read -p "Press Enter to return to main menu..."
            return
            ;;
        *|y|yes|"")
            ;;
    esac
    
    echo ""
    print_status "🔄 Starting upgrade process..."
    
    # Step 1: Stop the screen session if it exists
    if screen -list | grep -q "gensyn"; then
        print_status "🛑 Stopping Gensyn screen session..."
        screen -S gensyn -X stuff "^C"  # Send Ctrl+C to the screen session
        sleep 3
        screen -S gensyn -X quit 2>/dev/null || true
        print_success "✅ Screen session stopped"
    else
        print_status "ℹ️ No active screen session to stop"
    fi
    
    # Step 2: Navigate to directory and update
    print_status "📁 Navigating to rl-swarm directory..."
    cd "$RL_SWARM_DIR" || {
        print_error "❌ Failed to access rl-swarm directory"
        return 1
    }
    
    print_status "🔄 Updating repository..."
    echo ""
    
    # Check if we're in a git repository
    if [ ! -d ".git" ]; then
        print_error "❌ Not a git repository. Please reinstall using option 1."
        echo ""
        read -p "Press Enter to return to main menu..."
        return
    fi
    
    # Show current version/commit before upgrade
    print_status "📋 Current version:"
    git log --oneline -1 2>/dev/null || echo "Unable to get current version"
    echo ""
    
    # Perform the upgrade commands
    print_status "🔄 Switching to main branch..."
    if git switch main 2>/dev/null; then
        print_success "✅ Switched to main branch"
    else
        print_warning "⚠️ Switch to main failed, trying checkout..."
        git checkout main 2>/dev/null || {
            print_error "❌ Failed to switch to main branch"
            echo ""
            read -p "Press Enter to return to main menu..."
            return
        }
    fi
    
    print_status "🔄 Resetting repository state..."
    git reset --hard
    print_success "✅ Repository reset complete"
    
    print_status "🔄 Cleaning repository..."
    git clean -fd
    print_success "✅ Repository cleaned"
    
    print_status "📥 Pulling latest updates..."
    if git pull origin main; then
        print_success "✅ Updates pulled successfully"
    else
        print_error "❌ Failed to pull updates"
        echo ""
        print_status "💡 Check your internet connection and try again"
        read -p "Press Enter to return to main menu..."
        return
    fi
    
    echo ""
    
    # Show new version after upgrade
    print_status "📋 New version:"
    git log --oneline -1 2>/dev/null || echo "Unable to get new version"
    echo ""
    
    # Check for swarm.pem file
    if [ -f "swarm.pem" ]; then
        print_success "✅ swarm.pem file found"
    else
        print_warning "⚠️ swarm.pem file not found"
        print_status "💡 You may need to copy your swarm.pem file back to this directory"
    fi
    
    echo ""
    print_status "🚀 Starting upgraded Gensyn node..."
    
    # Start new screen session with upgraded node
    screen -S gensyn -dm bash -c "
    set -e
    cd '$RL_SWARM_DIR'
    
    echo '🔄 Starting upgraded Gensyn AI Node...'
    echo '📁 Working directory: \$(pwd)'
    echo '📋 Git version: \$(git log --oneline -1 2>/dev/null || echo \"Unknown\")'
    echo ''
    
    # Activate virtual environment
    if [ -d '.venv' ]; then
        echo '🐍 Activating Python virtual environment...'
        source .venv/bin/activate
        echo '✅ Virtual environment activated'
    else
        echo '⚠️ Virtual environment not found, creating new one...'
        python3 -m venv .venv
        source .venv/bin/activate
        pip install --upgrade pip
        pip install --force-reinstall transformers==4.51.3 trl==0.19.1
    fi
    
    echo ''
    echo '🔑 Checking for swarm.pem file...'
    if [ -f 'swarm.pem' ]; then
        echo '✅ Found swarm.pem file, proceeding with authentication...'
    else
        echo '⚠️ No swarm.pem found in the current directory.'
        echo '📂 Please copy your swarm.pem file to: \$(pwd)'
        echo ''
        echo '⏳ Waiting 30 seconds for you to copy the file...'
        echo '✅ Press 1 and Enter if you have copied the file to continue immediately'
        
        # Countdown with user input option
        for i in \$(seq 30 -1 1); do
            printf \"\\r⏰ Waiting: %02d seconds (Press 1 to continue)\" \$i
            
            if read -t 1 -n 1 user_input 2>/dev/null; then
                if [ \"\$user_input\" = \"1\" ]; then
                    echo \"\"
                    echo \"⚡ Continuing...\"
                    break
                fi
            fi
        done
        echo \"\"
    fi
    
    echo ''
    echo '🚀 Starting the upgraded swarm node...'
    chmod +x run_rl_swarm.sh 2>/dev/null || true
    
    if ./run_rl_swarm.sh; then
        echo '✅ Swarm completed successfully.'
    else
        echo '❌ Swarm exited with an error or was interrupted.'
    fi
    
    echo ''
    echo '🔄 Swarm process ended. Screen session will remain active.'
    echo '📋 To restart the swarm, run: ./run_rl_swarm.sh'
    echo '🚪 To exit this screen session, type: exit'
    echo ''
    
    # Keep the screen session alive
    while true; do
        echo '⏳ Screen session active. Press Ctrl+C to exit or run commands...'
        sleep 30
    done
    "
    
    sleep 3
    
    echo ""
    print_success "✅ Gensyn AI Node upgrade completed!"
    echo ""
    echo -e "${CYAN}📋 Upgrade Summary:${NC}"
    echo "• Repository updated to latest version"
    echo "• Node restarted with new code"
    echo "• Screen session 'gensyn' is active"
    echo ""
    echo -e "${YELLOW}🔍 Next steps:${NC}"
    echo -e "${GREEN}screen -r gensyn${NC}          # Attach to node session to check status"
    echo -e "${GREEN}screen -list${NC}              # List all screen sessions"
    echo -e "${GREEN}Ctrl+A then D${NC}            # Detach from screen session"
    echo ""
    print_status "🚪 Exiting script so you can check your upgraded node..."
    echo -e "${CYAN}💡 Run: screen -r gensyn to attach to your node${NC}"
    echo ""
    
    # Show exit message and exit script
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                        👋 Thank You! 👋                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}🙏 Thank you for using Testnet Terminal's OneClick Setup!${NC}"
    echo ""
    echo -e "${YELLOW}🔗 Stay Connected:${NC}"
    echo -e "${BLUE}📱 Telegram: ${NC}https://t.me/TestnetTerminal"
    echo -e "${BLUE}🐙 GitHub: ${NC}https://github.com/TestnetTerminal" 
    echo -e "${BLUE}🐦 Twitter: ${NC}https://x.com/TestnetTerminal"
    echo -e "${BLUE}🆘 Support: ${NC}https://t.me/Amit3701"
    echo ""
    echo -e "${GREEN}✨ Your node has been upgraded! Check it with: screen -r gensyn ✨${NC}"
    echo ""
    exit 0
}

# Delete Gensyn Node completely
delete_gensyn_node() {
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                    🗑️ Delete Gensyn AI Node 🗑️                   ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Get current user
    CURRENT_USER=$(whoami)
    RL_SWARM_DIR="/home/$CURRENT_USER/rl-swarm"
    
    print_warning "⚠️ This will completely remove Gensyn AI Node from your system!"
    echo ""
    echo -e "${YELLOW}📋 What will be deleted:${NC}"
    echo "• rl-swarm directory and all contents"
    echo "• Screen session 'gensyn' (if running)"
    echo "• Python virtual environment"
    echo "• All downloaded files and configurations"
    echo ""
    
    # First confirmation
    echo -n -e "${WHITE}❓ Are you sure you want to delete Gensyn AI Node? (y/N/ENTER): ${NC}"
    read -r first_confirm
    
    case "${first_confirm,,}" in
        y|yes|"")
            ;;
        *)
            print_status "✅ Deletion cancelled. Your Gensyn AI Node is safe!"
            echo ""
            read -p "Press Enter to return to main menu..."
            return
            ;;
    esac
    
    echo ""
    print_warning "🚨 FINAL WARNING - BACKUP YOUR swarm.pem FILE!"
    echo ""
    echo -e "${RED}⚠️ Before I delete everything, have you saved your swarm.pem file?${NC}"
    echo -e "${YELLOW}📄 Note: Once deleted, your swarm.pem cannot be recovered!${NC}"
    echo ""
    
    # Second confirmation - more specific about swarm.pem
    echo -n -e "${WHITE}❓ Have you backed up your swarm.pem? Still want to delete? (y/N/ENTER): ${NC}"
    read -r second_confirm
    
    case "${second_confirm,,}" in
        y|yes|"")
            ;;
        *)
            print_status "✅ Deletion cancelled. Please backup your swarm.pem first!"
            echo ""
            if [ -f "$RL_SWARM_DIR/swarm.pem" ]; then
                echo -e "${GREEN}💡 You can use Option 3 to download your swarm.pem file${NC}"
            fi
            echo ""
            read -p "Press Enter to return to main menu..."
            return
            ;;
    esac
    
    echo ""
    print_error "🔥 FINAL CONFIRMATION - THIS IS IRREVERSIBLE!"
    echo -e "${RED}This will permanently delete ALL Gensyn AI Node data!${NC}"
    echo ""
    
    # Third and final confirmation
    echo -n -e "${WHITE}❓ Type 'DELETE' to confirm permanent deletion: ${NC}"
    read -r final_confirm
    
    if [ "$final_confirm" != "DELETE" ]; then
        print_status "✅ Deletion cancelled. Incorrect confirmation text."
        echo ""
        read -p "Press Enter to return to main menu..."
        return
    fi
    
    echo ""
    print_status "🗑️ Starting deletion process..."
    
    # Stop screen session if running
    if screen -list | grep -q "gensyn"; then
        print_status "🔄 Stopping Gensyn screen session..."
        screen -S gensyn -X quit 2>/dev/null || true
        print_success "✅ Screen session stopped"
    fi
    
    # Delete rl-swarm directory
    if [ -d "$RL_SWARM_DIR" ]; then
        print_status "📁 Removing rl-swarm directory..."
        rm -rf "$RL_SWARM_DIR"
        print_success "✅ rl-swarm directory deleted"
    else
        print_warning "⚠️ rl-swarm directory not found (already deleted?)"
    fi
    
    # Clean up any remaining processes
    print_status "🔍 Cleaning up any remaining processes..."
    pkill -f "run_rl_swarm" 2>/dev/null || true
    pkill -f "rl-swarm" 2>/dev/null || true
    
    # Remove any systemd services if they were created
    if [ -f "/etc/systemd/system/gensyn.service" ]; then
        print_status "🔄 Removing systemd service..."
        $SUDO_CMD systemctl stop gensyn.service 2>/dev/null || true
        $SUDO_CMD systemctl disable gensyn.service 2>/dev/null || true
        $SUDO_CMD rm -f /etc/systemd/system/gensyn.service
        $SUDO_CMD systemctl daemon-reload
        print_success "✅ Systemd service removed"
    fi
    
    # Clean up any cron jobs (if any were set)
    print_status "🔄 Checking for scheduled tasks..."
    (crontab -l 2>/dev/null | grep -v "gensyn\|rl-swarm" | crontab -) 2>/dev/null || true
    
    sleep 2
    
    # Display completion banner
    clear
    echo ""
    echo -e "${BLUE}████████╗███████╗███████╗████████╗███╗   ██╗███████╗████████╗    ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗     ${NC}"
    echo -e "${BLUE}╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝████╗  ██║██╔════╝╚══██╔══╝    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║     ${NC}"
    echo -e "${BLUE}   ██║   █████╗  ███████╗   ██║   ██╔██╗ ██║█████╗     ██║          ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║     ${NC}"
    echo -e "${BLUE}   ██║   ██╔══╝  ╚════██║   ██║   ██║╚██╗██║██╔══╝     ██║          ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     ${NC}"
    echo -e "${BLUE}   ██║   ███████╗███████║   ██║   ██║ ╚████║███████╗   ██║          ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗${NC}"
    echo -e "${BLUE}   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═══╝╚══════╝   ╚═╝          ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝${NC}"
    echo ""
    echo -e "${WHITE}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${WHITE}║                    🗑️ DELETION COMPLETED 🗑️                     ║${NC}"
    echo -e "${WHITE}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}✅ All things related to Gensyn & RL-Swarm have been deleted from your system!${NC}"
    echo ""
    echo -e "${CYAN}📋 What was removed:${NC}"
    echo -e "${YELLOW}   • ${NC}rl-swarm directory: $RL_SWARM_DIR"
    echo -e "${YELLOW}   • ${NC}Screen session: gensyn"
    echo -e "${YELLOW}   • ${NC}All configuration files"
    echo -e "${YELLOW}   • ${NC}Python virtual environment"
    echo -e "${YELLOW}   • ${NC}All downloaded repositories"
    echo ""
    echo -e "${PURPLE}🙏 Thank you for using Testnet Terminal's OneClick Setup!${NC}"
    echo ""
    echo -e "${CYAN}🔗 Stay Connected:${NC}"
    echo -e "${YELLOW}📱 Telegram: ${NC}https://t.me/TestnetTerminal"
    echo -e "${YELLOW}🐙 GitHub: ${NC}https://github.com/TestnetTerminal" 
    echo -e "${YELLOW}🐦 Twitter: ${NC}https://x.com/TestnetTerminal"
    echo -e "${YELLOW}🆘 Support: ${NC}https://t.me/Amit3701"
    echo ""
    echo -e "${GREEN}💡 You can reinstall anytime by running this script again!${NC}"
    echo ""
    
    read -p "Press Enter to return to main menu..."
}

# Exit function
exit_script() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                        👋 Thank You! 👋                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}🙏 Thank you for using Testnet Terminal's OneClick Setup!${NC}"
    echo ""
    echo -e "${YELLOW}🔗 Stay Connected:${NC}"
    echo -e "${BLUE}📱 Telegram: ${NC}https://t.me/TestnetTerminal"
    echo -e "${BLUE}🐙 GitHub: ${NC}https://github.com/TestnetTerminal" 
    echo -e "${BLUE}🐦 Twitter: ${NC}https://x.com/TestnetTerminal"
    echo -e "${BLUE}🆘 Support: ${NC}https://t.me/Amit3701"
    echo ""
    echo -e "${GREEN}✨ Happy Testing! See you next time! ✨${NC}"
    echo ""
    exit 0
}

# Main menu loop
main() {
    while true; do
        show_banner
        show_menu
        
        read -r choice
        
        case $choice in
            1)
                install_gensyn_node
                ;;
            2)
                install_cloudflared
                ;;
            3)
                download_swarm_pem
                ;;
            4)
                upgrade_gensyn_node
                ;;
            5)
                delete_gensyn_node
                ;;
            6)
                exit_script
                ;;
            *)
                echo ""
                print_error "❌ Invalid option. Please select 1-4."
                echo ""
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Initialize and run
detect_os
get_package_manager  
set_sudo_cmd
main "$@"
