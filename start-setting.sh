#!/bin/bash
# Check if the entry exists
echo -e "\nAdding entry 127.0.0.1 registry.local to /etc/hosts\n"
if ! grep -q "127.0.0.1 registry.local" /etc/hosts; then
    # Entry not found, adding it
    echo "127.0.0.1 registry.local" | sudo tee -a /etc/hosts
    echo "Entry successfully added to /etc/hosts!"
else
    echo "Entry '127.0.0.1 registry.local' already exists in /etc/hosts."
fi

mkdir data-registrymy \
      -p security-settings/auth

echo "Please enter your login:"
read user
echo "please enter your password:"
read -s password

docker run \
    --entrypoint htpasswd \
    httpd:2 -Bbn $user $password > security-settings/auth/htpasswd

echo "Creating self-signed certificate"
mkdir -p security-settings/certs
openssl genrsa -out security-settings/certs/registry.local.key 2048
openssl req -new -key security-settings/certs/registry.local.key -out security-settings/certs/registry.local.csr -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Company/OU=Department/CN=registry.local"
openssl x509 -req -days 365 -in security-settings/certs/registry.local.csr -signkey security-settings/certs/registry.local.key -out security-settings/certs/registry.local.crt

echo "Creating directory for certificate"
sudo mkdir -p /etc/docker/certs.d/registry.local

echo "Adding certificates to the system store"
sudo cp security-settings/certs/registry.local.crt /etc/docker/certs.d/registry.local/

echo "Creating symbolic link"
current_dir=$(pwd)

if [[ "$current_dir" == *"/home/"* ]]; then
    
    user=$(echo "$current_dir" | awk -F'/home/' '{print $2}' | awk -F'/' '{print $1}')
    users="/home/$user"
else
    users="/root"
fi
mkdir -p /home/$users/.docker
cd /etc/docker/certs.d/registry.local
sudo ln -s /etc/docker/certs.d/registry.local/registry.local.crt $users/.docker/ca.pem

echo "Restart Docker"
sudo systemctl restart docker

echo "Start Registry"
docker compose up -d