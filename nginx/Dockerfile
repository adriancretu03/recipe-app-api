FROM nginx:alpine

# Install OpenSSL and dos2unix
RUN apk add --no-cache openssl dos2unix

# Create the mini vm's config directory
RUN mkdir -p /etc/nginx/app

# Copy our config to new directory
COPY nginx.conf /etc/nginx/nginx.conf

# Set the working directory to that same config directory
WORKDIR /etc/nginx/app

# Copy the config into the container's working directory
COPY . .

#  Make the script file executable
RUN chmod +x entrypoint.sh

# Convert file from DOS/Windows format (CRLF) to Unix/Linux format (LF).
RUN dos2unix entrypoint.sh

EXPOSE 80 443

# Execute script when container run
CMD ./entrypoint.sh
