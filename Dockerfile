# Use Ubuntu 22.04 as base
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    nginx \
    openssh-server \
    curl \
    wget \
    nano \
    htop \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir /var/run/sshd
RUN echo 'root:flyio123' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create a non-root user
RUN useradd -m -s /bin/bash flyuser && echo 'flyuser:flyio123' | chpasswd
RUN usermod -aG sudo flyuser

# Configure Nginx
COPY nginx.conf /etc/nginx/sites-available/default
RUN echo '<!DOCTYPE html><html><head><title>Fly.io Linux Server</title></head><body><h1>🪰 Fly.io Linux Server Running!</h1><p>Your Ubuntu server is live on Fly.io</p><p>SSH as root or flyuser with password: flyio123</p><p>Change this password immediately!</p></body></html>' > /var/www/html/index.html

# Configure Supervisor to manage services
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create startup script
RUN echo '#!/bin/bash\n\
echo "Starting Fly.io Linux Server..."\n\
echo "SSH Password: flyio123"\n\
echo "Web server on port $PORT"\n\
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf\n\
' > /start.sh && chmod +x /start.sh

# Expose ports
EXPOSE 8080 22

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Start services
CMD ["/start.sh"]
