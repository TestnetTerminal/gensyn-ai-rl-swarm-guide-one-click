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
    echo -e "${GREEN}1. 🛠️  Install Gensyn AI Node${NC}"
    echo -e "${BLUE}2. 🛜 Install Cloudflared and Tunnel${NC}"
    echo -e "${YELLOW}3. ⬇️  Download Swarm.pem File${NC}"
    echo -e "${RED}4. ❌ Exit${NC}"
    echo ""
    echo -n -e "${WHITE}Select an option (1-4): ${NC}"
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

# Install Cloudflared and Tunnel
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

        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"

        if [ "$PKG_MANAGER" = "apt" ]; then
            wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH_SUFFIX}.deb"
            $SUDO_CMD dpkg -i "cloudflared-linux-${ARCH_SUFFIX}.deb"
        else
            wget -q "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH_SUFFIX}" -O cloudflared
            chmod +x cloudflared
            $SUDO_CMD mv cloudflared /usr/local/bin/cloudflared
        fi

        cd - > /dev/null
        rm -rf "$TEMP_DIR"
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
    print_status "🔍 Checking if port 3000 is active..."
    
    if command -v lsof &> /dev/null && lsof -i:3000 &> /dev/null; then
        print_success "✅ Port 3000 is active!"
        
        echo ""
        echo -e "${YELLOW}⚠️ Are you sure you want to tunnel localhost:3000? ${NC}"
        echo -e "${CYAN}This will create a public URL accessible from anywhere.${NC}"
        echo ""
        echo -n -e "${WHITE}Continue? (Y/n/Enter=Yes): ${NC}"
        read -r confirm
        
        case "${confirm,,}" in
            n|no)
                print_warning "🚫 Tunnel cancelled by user."
                ;;
            *|y|yes|"")
                echo ""
                print_success "🚀 Starting Cloudflare tunnel..."
                echo -e "${YELLOW}⚠️ Press Ctrl+C to stop the tunnel${NC}"
                echo ""
                sleep 2
                cloudflared tunnel --url http://localhost:3000
                ;;
        esac
    else
        print_warning "⚠️ Port 3000 is not active."
        echo -e "${YELLOW}Start your application on port 3000 first, then run:${NC}"
        echo -e "${GREEN}cloudflared tunnel --url http://localhost:3000${NC}"
    fi
    
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
        
        # Ask if user wants to tunnel the file for download
        echo -n -e "${WHITE}Do you want to create a tunnel to download this file? (y/N): ${NC}"
        read -r tunnel_choice
        
        case "${tunnel_choice,,}" in
            y|yes)
                print_status "🌐 Setting up HTTP server for swarm.pem download..."
                
                # Change to rl-swarm directory
                cd "$RL_SWARM_DIR"
                
                # Create a simple HTML page for download
                cat > index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Swarm.pem Download - Testnet Terminal</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            text-align: center; 
            padding: 50px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; 
            min-height: 100vh;
            margin: 0;
        }
        .container { 
            max-width: 600px; 
            margin: 0 auto; 
            background: rgba(255,255,255,0.1);
            padding: 40px;
            border-radius: 20px;
            backdrop-filter: blur(10px);
        }
        .download-btn { 
            background: linear-gradient(45deg, #4CAF50, #45a049);
            color: white; 
            padding: 15px 30px; 
            text-decoration: none; 
            border-radius: 10px; 
            font-size: 18px; 
            display: inline-block;
            margin: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .download-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }
        .info-box { 
            background: rgba(255,255,255,0.2); 
            padding: 20px; 
            border-radius: 10px; 
            margin: 20px 0; 
            border-left: 4px solid #4CAF50;
        }
        .logo { font-size: 3em; margin-bottom: 20px; }
        .warning {
            background: rgba(255,193,7,0.2);
            border-left: 4px solid #ffc107;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🔐</div>
        <h1>Swarm.pem Download</h1>
        <h3>Testnet Terminal - Gensyn AI</h3>
        
        <div class="info-box">
            <h3>📄 File Ready for Download</h3>
            <p><strong>File:</strong> swarm.pem</p>
            <p><strong>Location:</strong> $SWARM_PEM_PATH</p>
            <p><strong>User:</strong> $CURRENT_USER</p>
        </div>
        
        <a href="swarm.pem" download="swarm.pem" class="download-btn">
            📥 Download swarm.pem
        </a>
        
        <div class="warning">
            <h4>⚠️ Security Notice</h4>
            <p>Keep your swarm.pem file secure and don't share it publicly!</p>
        </div>
        
        <p>🌐 <a href="https://t.me/TestnetTerminal" target="_blank" style="color: #fff;">Testnet Terminal</a></p>
    </div>
</body>
</html>
EOF

                print_status "🚀 Starting HTTP server on port 3000..."
                echo -e "${YELLOW}⚠️ Press Ctrl+C to stop the server${NC}"
                echo ""
                
                if command -v python3 &> /dev/null; then
                    python3 -m http.server 3000 &
                    SERVER_PID=$!
                    sleep 2
                    
                    if command -v cloudflared &> /dev/null; then
                        print_success "🌐 Starting Cloudflare tunnel..."
                        echo -e "${CYAN}📋 The tunnel will provide a public URL to download your swarm.pem${NC}"
                        echo ""
                        cloudflared tunnel --url http://localhost:3000
                        kill $SERVER_PID 2>/dev/null || true
                    else
                        print_warning "⚠️ Cloudflared not found. Server running on localhost:3000"
                        echo "Install cloudflared first using option 2, then try again."
                        kill $SERVER_PID 2>/dev/null || true
                    fi
                    
                    # Clean up HTML file
                    rm -f index.html
                else
                    print_error "❌ Python3 not found. Cannot start HTTP server."
                fi
                ;;
            *)
                print_status "📁 swarm.pem is ready at: $SWARM_PEM_PATH"
                echo "You can copy or use this file as needed."
                ;;
        esac
        
    else
        print_error "❌ swarm.pem not found at: $SWARM_PEM_PATH"
        echo ""
        echo -e "${YELLOW}💡 To get your swarm.pem file:${NC}"
        echo "1. Make sure you've run option 1 (Install Gensyn AI Node) first"
        echo "2. Copy your swarm.pem file to: $RL_SWARM_DIR/"
        echo "3. Get your swarm.pem from: https://app.gensyn.ai/"
        echo ""
        echo -e "${CYAN}📋 Current rl-swarm directory contents:${NC}"
        if [ -d "$RL_SWARM_DIR" ]; then
            ls -la "$RL_SWARM_DIR" | head -10
        fi
    fi
    
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
