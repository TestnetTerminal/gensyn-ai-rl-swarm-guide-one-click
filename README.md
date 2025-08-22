# 🚀 Gensyn AI RL-Swarm Node OneClick Setup

<div align="center">

![Gensyn AI](https://img.shields.io/badge/Gensyn-AI%20Node-blue?style=for-the-badge)
![Bash](https://img.shields.io/badge/Bash-Script-green?style=for-the-badge)
![Linux](https://img.shields.io/badge/Linux-Compatible-orange?style=for-the-badge)

**Automated installation script for Gensyn AI RL-Swarm Node with tunnel support**

</div>

---

## ⚡ Quick Start

```bash
bash <(curl -s https://raw.githubusercontent.com/TestnetTerminal/gensyn-ai-rl-swarm-guide-one-click/main/setup.sh)
```

**That's it! One command installs everything automatically** 🚀

---

## 📋 Menu Options

### **1. 🛠️ Install Gensyn AI Node**
**What happens when you press 1:**
- ✅ Installs Python 3, Node.js, Yarn
- ✅ Clones Gensyn RL-Swarm repository  
- ✅ Sets up virtual environment
- ✅ Installs required packages (transformers, trl)
- ✅ Starts node in screen session called `gensyn`
- ✅ Waits 50 sec till then import your old swarm.pem in to rl-swarm directory or press `1`  
- ✅ Runs the RL-Swarm node automatically

**After installation:**
- View logs: `screen -r gensyn`
- Detach from screen: `Ctrl+A then D`
- Stop node: `screen -S gensyn -X quit`

### **2. 🛜 Install Cloudflared and Tunnel**
**What happens when you press 2:**
- ✅ Installs Cloudflared tunnel software
- ✅ Configures firewall (opens ports 22, 3000)
- ✅ Checks if port 3000 is active
- ✅ Creates secure tunnel for localhost:3000
- ✅ Gives you public URL to access your app

**Use this when:**
- when it say failed to open localhost:3000
- use this simultaneously in new tab
- to temporary access the url from your local system  

### **3. ⬇️ Download Swarm.pem File**
**What happens when you press 3:**
- ✅ Locates your swarm.pem file in `/home/user/rl-swarm/`
- ✅ Shows file information (size, date)
- ✅ Creates beautiful download server on port 8080+
- ✅ Generates Cloudflare tunnel for secure download
- ✅ Provides direct download link
- ✅ Auto-downloads file when you open the link

**Alternative methods if tunnel fails:**
- Shows SCP command for manual download
- Displays file content for copy-paste

### **4. ❌ Exit**
**What happens when you press 4:**
- ✅ Shows thank you message
- ✅ Displays all our social links
- ✅ Exits the script cleanly

---

## 🛠️ System Requirements

- **RAM**: Minimum 32GB recommended
- **Storage**: Minimum 50GB free space
- **Network**: Internet connection required
- **Permissions**: Root/sudo access

---

## 🚨 Important Notes

- **Screen Session**: Node runs in background, server restarts won't stop it
- **Security**: Never share your swarm.pem file publicly
- **Monitoring**: Use `screen -r gensyn` to check node status

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| `curl: command not found` | `sudo apt install curl` or `sudo yum install curl` |
| Script permission denied | Run the curl command again |
| Node not starting | Check `screen -r gensyn` for errors |
| Port 3000 occupied | Stop other services or use different port |

---

## 🔗 Links

- 📱 **Telegram**: [https://t.me/TestnetTerminal](https://t.me/TestnetTerminal)
- 🐙 **GitHub**: [https://github.com/TestnetTerminal](https://github.com/TestnetTerminal)
- 🐦 **Twitter/X**: [https://x.com/TestnetTerminal](https://x.com/TestnetTerminal)
- 🆘 **Support**: [https://t.me/Amit3701](https://t.me/Amit3701)

---

<div align="center">

**Made with ❤️ by [Testnet Terminal](https://t.me/TestnetTerminal)**

⭐ **Star this repo if it helped you!** ⭐

</div>
