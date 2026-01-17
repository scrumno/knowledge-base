#php #function #backend #code 

В PHP есть именованные параметры функций. Они нужны, если в функцию передается много параметров одинакового типа. Их можно передавать в разном порядке. Пример:

```php
function sum(int $base, int $first, int $second) 
{
	return $base + $first - $second;
}


print_r(sum(
	base: 2,
	first: 5,
	second: 10
));
```