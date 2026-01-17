WordPress learn

# WordPress filesystem

## порядок загрузки:

index.php --> wp-blog-header.php --> wp-load.php --> wp-config.php --> wp-settings.php

# [[HTACCESS]]
# [[LICENSE TXT]]
# [[PHP]]
# [[WP Database]]

## Функции взаимодействия

_Функции важно искать в документации разработчика WordPress. Code Reference._
[Code Reference](https://developer.wordpress.org/reference/)

### Database API func standards

1. Insert, update, delete func.
2. Usually have the same prefix: wp\_.
3. wp*{action}*{table_name}.

#### пример

```php
wp_update_post(
							array|object $postarr = array(),
							bool $wp_error = false,
							bool $fire_after_hooks = true
	): int|WP_Error
```

# [[Permalinks]]
