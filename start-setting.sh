#!/bin/bash
# Перевірка наявності запису
echo -e "\nдодаємо запис 127.0.0.1 registry.local в /etc/hosts\n"
if ! grep -q "127.0.0.1 registry.local" /etc/hosts; then
  # Запис не знайдено, додаємо його
  echo "127.0.0.1 registry.local" | sudo tee -a /etc/hosts

  # Повідомлення про успішне додавання
  echo "Запис успішно додано до /etc/hosts!"
else
  # Запис вже існує
  echo "Запис '127.0.0.1 registry.local' вже існує в /etc/hosts."
fi

mkdir data-registrymy
mkdir data-registrymy1

mkdir -p path/auth

echo "Введіть ваш логін:"
read testuser
echo "Введіть пароль:"
read testpassword

docker run \
  --entrypoint htpasswd \
  httpd:2 -Bbn $testuser $testpassword > path/auth/htpasswd


echo "створюємо самопідписані сертифікати"

echo "Створення першого сертифікату"
mkdir -p path/certs
openssl genrsa -out path/certs/mykey.key 2048
openssl req -new -key path/certs/mykey.key -out path/certs/mycert.csr -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Company/OU=Department/CN=registry.local"
openssl x509 -req -days 365 -in path/certs/mycert.csr -signkey path/certs/mykey.key -out path/certs/mycert.crt

echo "Створення другого сертифікату"
mkdir -p path/certs1
openssl genrsa -out path/certs1/mykey1.key 2048
openssl req -new -key path/certs1/mykey1.key -out path/certs1/mycert1.csr -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Company/OU=Department/CN=registry.local"
openssl x509 -req -days 365 -in path/certs1/mycert1.csr -signkey path/certs1/mykey1.key -out path/certs1/mycert1.crt


echo "Створення директорії для сертифікатів"
sudo mkdir -p /etc/docker/certs.d/registry.local

echo "Додавання сертифікатів до системного сховища"
sudo cp path/certs/mycert.crt /etc/docker/certs.d/registry.local/
sudo cp path/certs1/mycert1.crt /etc/docker/certs.d/registry.local/

echo "Cтворення символічних посилань"

# Отримати список користувачів з домашніми папками в /home
users=$(awk -F':' '/\/home\// {print $1}' /etc/passwd)

# Ввести ім'я користувача
while true; do
  echo -n -e "Введіть ім'я користувача де знахидоться проект Registry: \n"
  awk -F':' '/\/home\// {print $1}' /etc/passwd
  read username

  # Перевірити, чи введений користувач є в списку
  if [[ "$users" =~ (^|,)"$username"($|,) ]]; then
    break
  else
    echo "Невірне ім'я користувача!"
  fi
done

mkdir -p /home/$username/.docker

cd /etc/docker/certs.d/registry.local
sudo ln -s /etc/docker/certs.d/registry.local/mycert.crt /home/$username/.docker/ca.pem
sudo ln -s /etc/docker/certs.d/registry.local/mycert1.crt /home/$username/.docker/ca1.pem

echo "Перезавантаження Docker для застосування змін"
sudo systemctl restart docker