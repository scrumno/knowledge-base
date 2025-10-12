#php #docker #compose #backend 

Всё аналогично предыдущим настроенным сервисам

docker-compose.yml
```yaml
composer:
    build:
      context: .
      dockerfile: composer.dockerfile
    volumes:
      - ./src:/var/www/html
    working_dir: /var/www/html
```

^5aa310

composer.dockerfile
```dockerfile
FROM composer:2.8

ENV COMPOSERUSER=laravel
ENV COMPOSERGROUP=laravel

RUN adduser -g ${COMPOSERGROUP} -s /bin/sh -D ${COMPOSERUSER}
```

^beae5d

