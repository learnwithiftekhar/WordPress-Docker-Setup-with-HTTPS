#!/bin/bash

# Create SSL directory
mkdir -p ssl

# Generate self-signed SSL certificate for localhost
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ssl/localhost.key \
    -out ssl/localhost.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

# Set appropriate permissions
chmod 600 ssl/localhost.key
chmod 644 ssl/localhost.crt

echo "SSL certificates generated successfully!"
echo "Key file: ssl/localhost.key"
echo "Certificate file: ssl/localhost.crt"