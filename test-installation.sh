#!/bin/bash

# OpenClaw Installation Test Script
# This script tests if OpenClaw is properly installed and running

echo "========================================="
echo "OpenClaw Installation Test"
echo "========================================="
echo ""

# Check if in correct directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Error: Run this script from the openclaw_deepseek directory"
    exit 1
fi

echo "🔍 Testing Docker installation..."
if command -v docker &> /dev/null; then
    echo "✅ Docker is installed: $(docker --version)"
else
    echo "❌ Docker is not installed"
    exit 1
fi

if command -v docker-compose &> /dev/null; then
    echo "✅ Docker Compose is installed: $(docker-compose --version)"
else
    echo "❌ Docker Compose is not installed"
    exit 1
fi

echo ""
echo "🔍 Testing Docker service..."
if sudo systemctl is-active --quiet docker; then
    echo "✅ Docker service is running"
else
    echo "❌ Docker service is not running"
    echo "   Start with: sudo systemctl start docker"
    exit 1
fi

echo ""
echo "🔍 Testing OpenClaw containers..."
if docker-compose ps | grep -q "Up"; then
    echo "✅ OpenClaw containers are running"
    
    # Get container status
    echo ""
    echo "Container Status:"
    docker-compose ps
else
    echo "⚠️  OpenClaw containers are not running"
    echo "   Start with: docker-compose up -d"
    
    # Try to start containers
    read -p "Start OpenClaw containers now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose up -d
        sleep 10
    else
        exit 1
    fi
fi

echo ""
echo "🔍 Testing OpenClaw gateway..."
if curl -s http://localhost:18789 > /dev/null; then
    echo "✅ OpenClaw gateway is accessible"
else
    echo "❌ OpenClaw gateway is not accessible"
    echo "   Check if port 18789 is open and not blocked by firewall"
fi

echo ""
echo "🔍 Testing environment configuration..."
if [ -f ".env" ]; then
    echo "✅ .env file exists"
    
    # Check for required variables
    REQUIRED_VARS=("DISCORD_TOKEN" "OPENCLAW_GATEWAY_TOKEN" "DEEPSEEK_API_KEY")
    MISSING_VARS=()
    
    for var in "${REQUIRED_VARS[@]}"; do
        if ! grep -q "^$var=" .env; then
            MISSING_VARS+=("$var")
        fi
    done
    
    if [ ${#MISSING_VARS[@]} -eq 0 ]; then
        echo "✅ All required environment variables are set"
    else
        echo "⚠️  Missing environment variables: ${MISSING_VARS[*]}"
        echo "   Update your .env file"
    fi
else
    echo "❌ .env file not found"
    echo "   Create from template: cp .env.example .env"
    exit 1
fi

echo ""
echo "🔍 Testing OpenClaw configuration..."
if [ -f "openclaw.json" ]; then
    echo "✅ openclaw.json configuration file exists"
    
    # Check if Discord is enabled
    if grep -q '"enabled": true' openclaw.json; then
        echo "✅ Discord integration is enabled in configuration"
    else
        echo "⚠️  Discord integration may not be enabled"
    fi
else
    echo "❌ openclaw.json not found"
    exit 1
fi

echo ""
echo "🔍 Testing Docker image..."
if docker images | grep -q "openclaw-sandbox"; then
    echo "✅ OpenClaw Docker image exists"
else
    echo "⚠️  OpenClaw Docker image not found"
    echo "   Build with: docker-compose build"
fi

echo ""
echo "========================================="
echo "Test Results Summary"
echo "========================================="
echo ""
echo "📊 Installation Status:"
echo "----------------------"
echo "• Docker: $(if command -v docker &> /dev/null; then echo "✅ Installed"; else echo "❌ Missing"; fi)"
echo "• Docker Compose: $(if command -v docker-compose &> /dev/null; then echo "✅ Installed"; else echo "❌ Missing"; fi)"
echo "• Docker Service: $(if sudo systemctl is-active --quiet docker; then echo "✅ Running"; else echo "❌ Stopped"; fi)"
echo "• OpenClaw Containers: $(if docker-compose ps | grep -q "Up"; then echo "✅ Running"; else echo "❌ Stopped"; fi)"
echo "• OpenClaw Gateway: $(if curl -s http://localhost:18789 > /dev/null; then echo "✅ Accessible"; else echo "❌ Not accessible"; fi)"
echo "• Configuration Files: $(if [ -f ".env" ] && [ -f "openclaw.json" ]; then echo "✅ Complete"; else echo "❌ Incomplete"; fi)"
echo ""
echo "🚀 Next Steps:"
echo "-------------"
if docker-compose ps | grep -q "Up" && curl -s http://localhost:18789 > /dev/null; then
    echo "1. Open browser to: http://localhost:18789"
    echo "2. Enter gateway token from .env file"
    echo "3. Configure Discord bot in your server"
    echo "4. Test by sending a message in Discord"
else
    echo "1. Fix any issues shown above"
    echo "2. Run: docker-compose up -d"
    echo "3. Wait 30 seconds for containers to start"
    echo "4. Run this test script again"
fi
echo ""
echo "🛠️  Useful Commands:"
echo "------------------"
echo "• View logs: docker-compose logs -f"
echo "• Restart: docker-compose restart"
echo "• Stop: docker-compose down"
echo "• Update: docker-compose pull"
echo ""
echo "📚 Documentation:"
echo "---------------"
echo "• Ubuntu Installation: README.md or ./install-ubuntu.sh"
echo "• Discord Setup: DISCORD_SETUP.md"
echo "• OpenClaw Docs: https://docs.openclaw.ai"
echo ""
echo "========================================="
echo "Test completed at: $(date)"
echo "========================================="