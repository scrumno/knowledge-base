```yml
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
```