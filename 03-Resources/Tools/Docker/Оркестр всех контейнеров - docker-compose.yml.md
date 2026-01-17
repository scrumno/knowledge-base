#docker #php #backend #env

![[Nginx образ для docker#^580da7]]

![[Nginx образ для docker#^4c6b88]]

## Создаем *docker-compose.yml*
```yml
version: '3.8'

# Определяем сервисы, которые будут запущенны
services:
```

## Настраиваем сервис mysql:
![[Настройка mysql для docker#^476bd6]]

## Настраиваем сервис nginx
![[Настройка сервиса nginx в docker-compose.yml#^73d2d9]]

## Настраиваем PHP для нашего проекта
![[Минимальная настройка PHP для docker-compose.yml#^9e0f8b]]

Так же, нам нужно немного перенастроить наш php-образ
![[Минимальная конфигурация php.dockerfile для docker-compose#^3140d1]]

Настраиваем nginx.conf для нашего PHP (именно языка, не проекта)
![[Минимальная настройка PHP для docker-compose.yml#^7a5bc6]]

Добавим сервис для composer
![[Минимальная конфигурация composer.dockerfile для Docker Compose#^5aa310]]

Добавим конфигурацию сервиса composer
![[Минимальная конфигурация composer.dockerfile для Docker Compose#^beae5d]]

Добавим сервис artisan
![[Минимальная конфигурация сервиса artisan для Docker Composer#^39cd26]]

Опционально можно добавить phpmyadmin
[[phpmyadmin для docker-compose.yml]]

Обязательно нужно выполнить команды в терминале:

`cd *projectn-name*`
`docker-compose run --rm npm install`

`docker-compose run --rm composer create-project laravel/laravel`

Зайди в файл */src/.env* и настроить .env файл (особенно БД)

`docker-compose run --rm artisan migrate`

Полный docker-compose.yml
```yml
version: '3.8'

services:
  nginx:
    build:
      context: .
      dockerfile: nginx.dockerfile
    ports:
      - 80:80
    volumes:
      - ./src:/var/www/html
    depends_on:
      - mysql
  mysql:
    image: mysql:8.0
    ports:
      - 3306:3306
    environment:
      MYSQL_DATABASE: laravel
      MYSQL_USER: laravel
      MYSQL_PASSWORD: secret
      MYSQL_ROOT_PASSWORD: secret
    volumes:
      - ./mysql:/var/lib/mysql
    healthcheck:
      test: ['CMD', 'mysqladmin', 'ping', '-h', 'localhost']
      interval: 10s
      retries: 5
  phpmyadmin:
    image: phpmyadmin:latest
    restart: always
    ports:
      - 8080:80
    environment:
      PMA_HOST: mysql
      MYSQL_ROOT_PASSWORD: secret
    depends_on:
      - mysql
      - php
  php:
    build:
      context: .
      dockerfile: php.dockerfile
    volumes:
      - ./src:/var/www/html
  composer:
    build:
      context: .
      dockerfile: composer.dockerfile
    volumes:
      - ./src:/var/www/html
    working_dir: /var/www/html
  npm:
    image: node:current-alpine
    volumes:
      - ./src:/var/www/html
    entrypoint: ['npm']
    working_dir: /var/www/html
  artisan:
    build:
      context: .
      dockerfile: php.dockerfile
    volumes:
      - ./src:/var/www/html
    working_dir: /var/www/html
    depends_on:
      mysql:
        condition: service_healthy
    entrypoint: ['php', '/var/www/html/artisan']
```

