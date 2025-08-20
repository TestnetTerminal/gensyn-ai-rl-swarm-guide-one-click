#!/bin/bash

set -e

echo "📦 Updating system and installing dependencies..."
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof

if ! command -v node &>/dev/null; then
    echo "🔧 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt update && sudo apt install -y nodejs
fi

if ! command -v yarn &>/dev/null; then
    echo "🔧 Installing Yarn..."
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null
    sudo apt update && sudo apt install -y yarn
fi

echo "🖥️ Starting screen session 'gensyn'..."
screen -S gensyn -dm bash -c '

set -e

echo "📁 Cloning RL-SWARM repo..."
git clone https://github.com/gensyn-ai/rl-swarm.git
cd rl-swarm

echo "🐍 Setting up Python virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

echo "📦 Installing Python packages..."
pip install --force-reinstall transformers==4.51.3 trl==0.19.1

pip freeze

echo ""
echo "⚠️  Do you want to import swarm.pem? (y/n)"
while true; do
    read -p "➡️ Enter your choice: " choice
    case "$choice" in
        [Yy]* )
            echo "📂 Please copy your swarm.pem file to the rl-swarm directory."
            echo "✅ After that, type y again to continue."
            while true; do
                read -p "➡️ Press y to confirm swarm.pem is imported: " confirm
                case "$confirm" in
                    [Yy]* )
                        echo "🚀 Running the swarm node..."
                        ./run_rl_swarm.sh
                        break 2
                        ;;
                    * )
                        echo "⏳ Waiting for confirmation..."
                        ;;
                esac
            done
            ;;
        [Nn]* )
            read -p "❗ Are you sure you want to continue without swarm.pem? (y/n): " confirm_no
            case "$confirm_no" in
                [Yy]* )
                    echo "🚀 Running the swarm node without swarm.pem..."
                    ./run_rl_swarm.sh
                    break
                    ;;
                * )
                    echo "⏳ Going back to the import prompt..."
                    ;;
            esac
            ;;
        * )
            echo "❌ Please enter y or n."
            ;;
    esac
done

'
# 9️⃣ Big ASCII Banner
echo ""
echo "████████╗███████╗███████╗████████╗███╗   ██╗███████╗████████╗    ████████╗███████╗██████╗ ███╗   ███╗██╗███╗   ██╗ █████╗ ██╗     "
echo "╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝████╗  ██║██╔════╝╚══██╔══╝    ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║████╗  ██║██╔══██╗██║     "
echo "   ██║   █████╗  ███████╗   ██║   ██╔██╗ ██║█████╗     ██║          ██║   █████╗  ██████╔╝██╔████╔██║██║██╔██╗ ██║███████║██║     "
echo "   ██║   ██╔══╝  ╚════██║   ██║   ██║╚██╗██║██╔══╝     ██║          ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     "
echo "   ██║   ███████╗███████║   ██║   ██║ ╚████║███████╗   ██║          ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗"
echo "   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═══╝╚══════╝   ╚═╝          ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝"
echo ""
echo "🌐 Telegram: https://t.me/TestnetTerminal"
echo "🌐 Twitter/X: https://x.com/TestnetTerminal"
echo "📞 Need Help?: https://t.me/Amit3701"

echo "✅ Setup running in screen session named 'gensyn'."
echo "🔍 To attach to the screen: run → screen -r gensyn"
echo ""
