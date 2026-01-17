#docker #php #env #db #mysql #backend 

```yml
# Всё по аналогии с PHP и Composer
artisan:
    build:
      context: .
      dockerfile: php.dockerfile
    volumes:
      - ./src:/var/www/html
    working_dir: /var/www/html
    depends_on:
      mysql:
      
	    # Здесь мы проверяем состояние сервиса, в данном случае mysql
	    # Лично у меня это решает проблему первой миграции MySQL
	    # Сервис artisan не запустится, пока не получит ответ от сервиса mysql: healthy
        condition: service_healthy
    
    # Переопределяем CMD из докер-файла
    # Указываем на исполняемый файл и его аргументы, которые запускаются при старте контейнера
    # Отличается от CMD тем, что фиксирует команду, её сложнее переопределить при загрузке контейнера
    entrypoint: ['php', '/var/www/html/artisan']
```

^39cd26
