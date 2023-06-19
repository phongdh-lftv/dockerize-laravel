Dockerize Laravel
===
## Install & Dependence
- [Get Docker](https://docs.docker.com/get-docker/) - **required**
- [Makefile](https://www.gnu.org/software/make/#download) - **required**

## How To Use
- Build images
  ```
  make build
  ```
- Run application
  ```
  make up
  ```

## Directory Hierarchy
```
|—— .env.example
|—— Makefile
|—— docker
|    |—— .gitignore
|    |—— Dockerfile.core
|    |—— app
|        |—— config
|            |—— php
|                |—— php.ini
|        |—— entrypoint.sh
|    |—— mysql
|        |—— Dockerfile
|        |—— init.sql
|        |—— my.cnf
|    |—— nginx
|        |—— app-site.conf.example
|    |—— workers
|        |—— laravel-worker.conf
|        |—— php-fpm.conf
|        |—— supervisord.conf
|—— docker-compose.yml
|—— src
|    |—— laravel application
```
## Make cmd support
- Build images
  ```
  make build
  ```
- Run application
  ```
  make up
  ```
- Assets watcher: That the assets are rebuilt each time they change
  ```
  make assets-watcher
  ```
- Generate key for laravel application
  ```
  make generate-key
  ```
- Restart your application
  ```
  make restart
  ```
- Access to application container
  ```
  make exec-app
  ```
- Connect to mysql
  ```
  make exec-mysql
  ```
- Access to nginx container
  ```
  make exec-nginx
  ```
- Access to redis container
  ```
  make exec-redis
  ```
## License
MIT
