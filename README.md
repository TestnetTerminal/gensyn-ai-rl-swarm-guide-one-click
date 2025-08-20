# Gensyn Ai RL-SWARM One-Click Installer

This repository provides a **one-click installation and setup script** for running a Gensyn RL-SWARM node on Linux or WSL.


🧰 Requirements

- Linux VPS or WSL (Windows Subsystem for Linux)
- sudo privileges

---

## ⚡ Quick Start

> 🚀 To install and run everything automatically:

```bash
bash <(curl -s https://raw.githubusercontent.com/TestnetTerminal/gensyn-ai-rl-swarm-guide-one-click/main/setup.sh)
```

📦 What This Script Does

1. Installs required dependencies:
- Python 3
- Node.js 20.x
- Yarn
- Git, Screen, curl, etc.

2. Clones the Gensyn RL-SWARM repo

3. Creates and activates a Python virtual environment

4. Installs required Python packages:
- transformers==4.51.3
- trl==0.19.1

5. Prompts you to import your swarm.pem file if needed
6. Runs the swarm node (./run_rl_swarm.sh) once setup is complete

--

🔐 Swarm Key (swarm.pem)

After the environment is set up, the script will pause and ask if you want to import your swarm.pem key if u want to run your old.

If you choose `yes`, place your swarm.pem file into the rl-swarm directory, then press `y` again to continue.

If you choose `no`, node will start and create a new swarm.pem file 

--

🖥️ Accessing the Node Session

The script runs everything inside a detached screen session named gensyn.

To reattach to it at any time:
```bash
screen -r gensyn
```
---

## 🌍 Connect With Us

Telegram: [https://t.me/TestnetTerminal](https://t.me/TestnetTerminal)  
X/Twitter: [https://x.com/TestnetTerminal](https://x.com/TestnetTerminal)
Github: [https://https://github.com/TestnetTerminal](https://github.com/TestnetTerminal)
