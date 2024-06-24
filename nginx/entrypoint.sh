#!/bin/sh

# Define the marker file path
MARKER_FILE="/etc/nginx/ssl/.ssl_setup_done"

# Check if the marker file exists
if [ ! -f "$MARKER_FILE" ]; then
  echo "Running initial setup..."
    #Create directories for SSL certificates if they don't exist
    test -d /etc/nginx/ssl || mkdir -p /etc/nginx/ssl

    # Generate a 2048-bit RSA private key
    openssl genpkey -algorithm RSA -out /etc/nginx/ssl/self.key -pass pass:examplepass

    # Create a Certificate Signing Request (CSR)
    openssl req -new -key /etc/nginx/ssl/self.key -out /etc/nginx/ssl/self.csr -passin pass:examplepass -subj "/CN=app.com"

    # Generate a Self-Signed Certificate valid for 365 days
    openssl x509 -req -days 365 -in /etc/nginx/ssl/self.csr -signkey /etc/nginx/ssl/self.key -out /etc/nginx/ssl/self.crt -passin pass:examplepass

    # Generate DH parameters (2048 bits)
    echo "Waiting for Diffie-Hellman (DH) parameters to generate..."
    openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

    echo "Process complete."
    touch "$MARKER_FILE"
else
    echo "Initial setup already done. Skipping..."
fi

# Replace placeholders in nginx template with environment variable values
envsubst '\$PORT' < /etc/nginx/app/sites-available/my_app.conf > /etc/nginx/conf.d/default.conf

# Start Nginx
nginx -g 'daemon off;'