#bitrix #php #javascript #webdev #вебразработка #backend #sql #mysql #postgress #code #webdev 
# Что такое ORM
> По сути, ORM - фреймворк для данных. С помощью него описываются сущности и их связи, определяется то, как сущность отображается на базу данных (как правило, в полуавтоматическом режиме).

ORM берет на себя серьезную часть работы по генерации SQL-запросов, по извлечению данных и кастингу (преобразование типов базы данных в типы целевого языка и обратно), по автоматическому извлечению связей. В итоге получается, что ORM прячет всю работу с базой данных и сама выполняет все необходимые запросы.
В сложных случаях их все равно приходится писать самостоятельно, но, ORM содержат в себе query builder, который упрощает генерацию SQL.

В php таких ORM много. Пример с Docrtine2.
Определение сущности Photo: 
```php
<?php

// src/Entity/Photo.php

use Doctrine\ORM\Mapping as ORM;

class Photo
{
	protected $id;
	protected $title;
	protected $image;
	protected $slug;
	
	public function getId()
	{
		return $this->id;
	}
	
	public function getTitle()
	{
		return $this->title;
	}
	
	public function getSlug()
	{
		return $this->slug;
	}
	
	public function getImage()
	{
		return $this->image;
	}
}

// ИСПОЛЬЗОВАНИЕ:

$app->get('/photos', function ()
{
	// получаем из базы список всех фото
	$photos = $this->entityManager->GetRepository('App\Entity\Photo')->findAll();
	
	// передаем их в шаблон
	return $this->renderer->render($response, "/photos.phtml", ['photos' => $photos]);
})
```