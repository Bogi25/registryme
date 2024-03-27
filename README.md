Проект локального сховища DockerHub.
Він створює два локальних сховища за адресами:
registry.local:5000  (laravel-dock-php-one)
registry.local:5100  (laravel-dock-node-t).

Для запуску необхідно скачати проект
git clon 

В папці з проектом запустити bash скрипт start-setting.sh

Скрипт потребує прав адміністратора.
Записує та шифрує логін та пароль, за допомогою htpasswd, секретів DOCKER_USERNAME_LOCAL та DOCKER_PASSWORD_LOCAL які були додані в GitHub.

Створює два самопідписані сертифікати. Та додає їх до Docker щоб той їм довіряв.

