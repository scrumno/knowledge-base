#code #php #associativeMassive #backend 

## Добавление
```php
$arr['new'] = 'val';
```

## Удаление
```php
unset($arr['key']);
```

## Проверка:
```php
array_key_exists('key', $arr); 
// or
isset($arr['key']);
```

## Итерация
```php
foreach($arr as $key => $value) {
	// ...
}
```

## Слияние
```php
array_merge($arr1, $arr2);
```

## Фильтр
```php
array_filter($arr, fn($n) => $v > 0); // PHP > 5.3
```

## Ключи/значения
```php
array_keys($arr); 
// ||
array_values($arr);
```

## Поиск
```php
array_search('value', $arr);
```


