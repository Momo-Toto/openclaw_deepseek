# OpenClaw DeepSeek Configuration

This repository contains Docker and OpenClaw configuration files for running OpenClaw with DeepSeek AI models.

## 📁 Files Included

### Core Configuration
- `docker-compose.yml` - Docker Compose configuration for OpenClaw
- `Dockerfile` - Docker image definition
- `openclaw.json` - OpenClaw main configuration file
- `.env.example` - Environment variables template (copy to `.env` and fill in your values)

### Security Notes
- **Never commit `.env` file** - Contains sensitive API keys and tokens
- **Never commit `device.json` with private keys** - Contains cryptographic keys
- Use `.env.example` as a template for your environment variables

## 🚀 Quick Start

### 1. Clone and Setup
```bash
git clone https://github.com/Momo-Toto/openclaw_deepseek.git
cd openclaw_deepseek
cp .env.example .env
```

### 2. Configure Environment Variables
Edit `.env` file and add your API keys:
```bash
# Discord Bot Token from Developer Portal
DISCORD_TOKEN=your_discord_bot_token_here

# Your Gateway "Master Key" (keep this secret!)
OPENCLAW_GATEWAY_TOKEN="your-secure-gateway-token-here"

# DeepSeek API Key
DEEPSEEK_API_KEY=your_deepseek_api_key_here

# GitHub token
GITHUB_TOKEN=your_github_token_here
```

### 3. Start OpenClaw
```bash
docker-compose up -d
```

### 4. Access OpenClaw
- Web UI: http://localhost:18789
- Gateway token: Use the token from your `.env` file

## 🔧 Configuration Details

### Docker Compose (`docker-compose.yml`)
- Runs OpenClaw in a secure container
- Maps port 18789 for web access
- Mounts configuration directory
- Uses environment variables from `.env` file
- Security features: no-new-privileges, dropped capabilities

### OpenClaw Configuration (`openclaw.json`)
- **Models**: Configured for DeepSeek Chat and DeepSeek Reasoner
- **Gateway**: Runs on port 18789, binds to LAN
- **Channels**: Discord integration enabled
- **Agents**: Default model set to DeepSeek Chat

### Docker Image (`Dockerfile`)
- Based on Node 24 Bookworm Slim
- Includes: git, curl, python3, scientific libraries
- Installs OpenClaw globally
- Runs as non-root `node` user for security

## 🔐 Security Considerations

### Environment Variables
- Store all sensitive data in `.env` file
- Never commit `.env` to version control
- Use different tokens for development and production

### Docker Security
- Container runs with minimal privileges
- Capabilities dropped except CHOWN, SETGID, SETUID
- No new privileges allowed
- Runs as non-root user

### OpenClaw Security
- Gateway requires authentication token
- Device pairing uses public-key cryptography
- Channel access controlled via allowlists

## 📊 Cron Jobs Configuration

The system includes automated cron jobs for:
1. **Daily Sci-Fi Novel Generation** - 13:00 UTC (7:00 AM local)
2. **Daily Neuroscience Updates** - 13:30 UTC (7:30 AM local)
3. **Daily OpenClaw Use Cases** - 12:00 UTC (6:00 AM local)

Cron jobs are configured in `cron/jobs.json` and automatically post to Discord channels.

## 🔄 Updates

To update OpenClaw:
```bash
docker-compose down
docker-compose pull
docker-compose up -d
```

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Change port in docker-compose.yml
   ports:
     - "18790:18789"  # Change first number
   ```

2. **Missing environment variables**
   - Ensure `.env` file exists and is properly formatted
   - Check all required variables are set

3. **Docker permission issues**
   ```bash
   # Add user to docker group
   sudo usermod -aG docker $USER
   ```

4. **API key errors**
   - Verify API keys are valid and have correct permissions
   - Check rate limits on DeepSeek API

## 📝 License

This configuration is provided as-is for educational and personal use.

## 🙏 Acknowledgments

- [OpenClaw](https://openclaw.ai) - Automation platform
- [DeepSeek](https://deepseek.com) - AI models
- [Docker](https://docker.com) - Container platform

---

**Maintained by**: Momo-Toto  
**Last Updated**: March 5, 2026