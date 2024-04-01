# DockerHub local repository project.
[![license](https://img.shields.io/github/license/dec0dOS/amazing-github-template.svg?style=flat-square)](LICENSE)

## The project was created to be shared with the project
[gitLocal-DH](https://github.com/Bogi25/gitLocal-DH)

## It creates a local repository on the:
- _registry.local:5000  (php-composer)_

## Installation
Download the project
```sh
git clon https://github.com/Bogi25/registryme.git
```

Run a bash script in the folder with the project start-setting.sh :
```sh
cd registryme
./start-setting.sh 
```
### That's what this bash script does:

<table>
<tr>
<td>
<strong>Importantly.</strong> Some commands require administrator rights.

--- 
1. Adds a record 127.0.0.1 registry.local в /etc/hosts.
<details open>
<summary>2. Creates all necessary folders</summary>

- _data-registrymy_
- _security-settings/auth_
- _security-settings/certs_
- _/etc/docker/certs.d/registry.local_
- _/home/$username/.docker_

</details>

3. Records and encrypts login and password using htpasswd, DOCKER_USERNAME_LOCAL and DOCKER_PASSWORD_LOCAL secrets added to GitHub.
4. Creates a self-signed certificate and adds it to docker to trust them.
5. The script will interactively prompt for two parameters:

- Login, which is your DOCKER_USERNAME_LOCAL added as a secret in GitHub.
- Password, which is your password added as a secret DOCKER_PASSWORD_LOCAL in GitHub.

6. Docker restarts
7. RUN _docker compose up -d_

<details open>
<summary>List of commands that need sudo:</summary>

- sudo tee -a /etc/hosts
- sudo mkdir -p /etc/docker/certs.d/registry.local
- sudo ln -s /etc/docker/certs.d/registry.local/registry.local.crt $users/.docker/ca.pem
- sudo systemctl restart docker

</details>
</td>
</tr>
</table>

## Launch of the project
```sh
docker compose up
```
## Check
Link to check
```sh
https://registry.local:5000/v2/_catalog
```
## License
This project is licensed under the MIT license. Feel free to edit and distribute this template as you like.

See [LICENSE](LICENSE) for more information.