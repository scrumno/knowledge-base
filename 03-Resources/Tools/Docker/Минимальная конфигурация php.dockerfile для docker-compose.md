#php #backend #docker #mysql #nginx 

Создаем файл php.dockerfile
```dockerfile
# Контейнер с легковестным дистрибутивом
# Все alpine-image это облегченные версии, то, что нужно
FROM php:8.2-fpm-alpine

# Переменные окружения аналогично MySQL
ENV PHPGROUP=laravel
ENV PHPUSER=laravel

# Создаем пользователя и группу в контейнере
# *adduser => создать пользователя в Alpine Linux
# **-g ${PHPGROUP} => задать группу из переменной
# **-s /bin/sh => устанавливаем оболчну /bin/sh для пользователя
# **-D => создаем системного пользователя без пароля, то что нужно для сервисов
RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}

# Изменяем конфигурацию PHP-FPM, задавая пользователя
# *sed -i: выполняем замену текста в файле /usr/local/etc/php-fpm.d/www.conf
# *"s/user = www-data/user = ${PHPUSER}/g" => заменяем user = www-data на user = laravel во всех строках
RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf

# Аналогично строке выше, только группу
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

# Создаем директорию в контейнере с родительскими директориями, флаг -p предотвращает ошибку, если директория существует
RUN mkdir -p /var/www/html/public

# Устанавливаем расширения PHP
# *docker-php-ext-install => утилита в офицальных PHP-образах для установки расширений
# pdo, pdo_mysql нужны для корректной работы с БД MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Этот скрипт нужен для корректного управления правами, без него сайт выдает ошибку - permission denied
# т.к. в CMD нежелательно использовать синтаксис shell из-за его побочных эффектов
# я вставил это во временный скрипт, он удаляется после выполнения
# Данный скрипт корректно инициализирует PHP, сначала выдает права, затем запускает PHP-FPM с конфигурацией /usr/local/etc/php-fpm.conf и делает себя исполняемым
RUN echo "#!/bin/sh" > /tmp/start.sh && \
    echo "chown -R ${PHPUSER}:${PHPGROUP} /var/www/html" >> /tmp/start.sh && \
    echo "rm -f /tmp/start.sh" >> /tmp/start.sh && \
    echo "exec php-fpm -y /usr/local/etc/php-fpm.conf -R" >> /tmp/start.sh && \
    chmod +x /tmp/start.sh

# Указываем рабочую директорию, что бы проще было выполнять php команды
WORKDIR /var/www/html

# Запускаем команду после монтирование volumes
CMD ["/tmp/start.sh"]
```

^3140d1

