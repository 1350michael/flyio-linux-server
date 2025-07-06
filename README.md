# Fly.io Linux Server

A complete Ubuntu 22.04 Linux server running on Fly.io with SSH access and web server.

## Features

- **Ubuntu 22.04 LTS** base system
- **Nginx** web server on port 8080
- **SSH server** on port 22
- **Supervisor** for service management
- **Development tools**: git, nano, htop, curl, wget, Python 3, Node.js

## Quick Deploy

### Prerequisites
1. Install flyctl: `curl -L https://fly.io/install.sh | sh`
2. Sign up at fly.io: `flyctl auth signup`

### Deploy Steps
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/flyio-linux-server.git
   cd flyio-linux-server
   ```

2. Launch the app:
   ```bash
   flyctl launch
   ```
   - Choose your app name
   - Select region (ord = Chicago is good for US)
   - Don't add databases
   - Don't deploy immediately

3. Deploy:
   ```bash
   flyctl deploy
   ```

## Access Your Server

### Web Interface
Your app will be available at: `https://your-app-name.fly.dev`

### SSH Access
```bash
flyctl ssh console
```

Or connect externally:
```bash
flyctl ssh issue --agent
ssh root@your-app-name.fly.dev
```

**Default Credentials:**
- Username: `root` or `flyuser`
- Password: `flyio123`

**🚨 IMPORTANT: Change the default password immediately!**

## Post-Deploy Setup

1. SSH into your server:
   ```bash
   flyctl ssh console
   ```

2. Change passwords:
   ```bash
   passwd root
   passwd flyuser
   ```

3. Update system:
   ```bash
   apt update && apt upgrade -y
   ```

## Useful Commands

- **View logs**: `flyctl logs`
- **SSH access**: `flyctl ssh console`
- **Scale app**: `flyctl scale count 1`
- **Check status**: `flyctl status`
- **Stop app**: `flyctl apps suspend your-app-name`

## Free Tier Limits

Fly.io free tier includes:
- Up to 3 shared VMs
- 256MB RAM per VM
- 3GB persistent storage
- Automatic scaling to zero when idle

## Customization

Edit the `Dockerfile` to add packages:
```dockerfile
RUN apt-get install -y your-package-here
```

Edit `fly.toml` to change configuration like memory or regions.

## Security Notes

This setup is for **development/testing only**. For production:
- Use SSH keys instead of passwords
- Configure proper firewall rules
- Use environment variables for secrets
- Enable automatic security updates
