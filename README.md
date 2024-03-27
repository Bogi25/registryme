Проект локального сховища DockerHub.

Проект зроблено для спільного використання з проектом https://github.com/Bogi25/gitLocal-DH

Він створює два локальних сховища за адресами:
registry.local:5000  (laravel-dock-php-one) та 
registry.local:5100  (laravel-dock-node-t).

Для запуску необхідно скачати проект
git clon https://github.com/Bogi25/registryme.git

В папці з проектом запустити bash скрипт start-setting.sh з правами адміністратора.
sudo ./start-setting.sh 

Скрипт потребує прав адміністратора.
Створює усі необхідні папки.
Додає запис 127.0.0.1 registry.local в /etc/hosts.
Записує та шифрує логін та пароль, за допомогою htpasswd, секретів DOCKER_USERNAME_LOCAL та DOCKER_PASSWORD_LOCAL які були додані в GitHub.
Створює два самопідписані сертифікати. Та додає їх до Docker щоб той їм довіряв.

У скрипті інтерактивно треба буде ввести три параметри: логін - який є вашим DOCKER_USERNAME_LOCAL доданим до секрету в GitHub.
-пароль який є вашим паролем доданним в секрет DOCKER_PASSWORD_LOCAL в GitHub.
-ім'я вашого користувача для визначення робочої папки користувача під яким ви використовуєте docker.



