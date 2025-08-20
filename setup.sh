#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root. Please run as a regular user with sudo privileges."
    exit 1
fi

# Check for sudo privileges
if ! sudo -n true 2>/dev/null; then
    print_status "This script requires sudo privileges. You may be prompted for your password."
fi

print_status "📦 Updating system and installing dependencies..."
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof

# Install Node.js if not installed
if ! command -v node &>/dev/null; then
    print_status "🔧 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt update && sudo apt install -y nodejs
else
    print_status "✅ Node.js is already installed ($(node --version))"
fi

# Install Yarn using modern method
if ! command -v yarn &>/dev/null; then
    print_status "🔧 Installing Yarn..."
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install -y yarn
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

# Wait a moment for screen to start
sleep 2

# Display the banner
echo ""
echo "████████╗███████╗███████╗████████╗███╗   ██╗███████╗████████╗    ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗     "
echo "╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝████╗  ██║██╔════╝╚══██╔══╝    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║     "
echo "   ██║   █████╗  ███████╗   ██║   ██╔██╗ ██║█████╗     ██║          ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║     "
echo "   ██║   ██╔══╝  ╚════██║   ██║   ██║╚██╗██║██╔══╝     ██║          ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     "
echo "   ██║   ███████╗███████║   ██║   ██║ ╚████║███████╗   ██║          ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗"
echo "   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═══╝╚══════╝   ╚═╝          ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝"
echo ""
echo -e "${BLUE}🌐 Telegram: https://t.me/TestnetTerminal${NC}"
echo -e "${BLUE}🌐 Twitter/X: https://x.com/TestnetTerminal${NC}"
echo -e "${BLUE}📞 Need Help?: https://t.me/Amit3701${NC}"
echo ""
echo -e "${GREEN}✅ Setup completed! Screen session 'gensyn' is now running.${NC}"
echo -e "${YELLOW}🔍 To attach to the screen session: ${NC}screen -r gensyn"
echo -e "${YELLOW}🔍 To detach from screen session: ${NC}Press Ctrl+A then D"
echo -e "${YELLOW}🔍 To list screen sessions: ${NC}screen -list"
echo -e "${YELLOW}🔍 To terminate the session: ${NC}screen -S gensyn -X quit"
echo ""
echo -e "${GREEN}📝 Next Steps:${NC}"
echo "1. If you have a swarm.pem file, copy it to the rl-swarm directory"
echo "2. Attach to the screen session to monitor progress: screen -r gensyn"
echo "3. The swarm node should start automatically"
echo ""

# Check if screen session is actually running
if screen -list | grep -q "gensyn"; then
    print_status "🎉 Screen session 'gensyn' is running successfully!"
else
    print_error "❌ Failed to start screen session. Please check for errors above."
    exit 1
fi
