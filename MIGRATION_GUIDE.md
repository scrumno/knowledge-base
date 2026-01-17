# 🚀 РУКОВОДСТВО ПО МИГРАЦИИ

> Пошаговая инструкция по переносу существующих заметок в новую систему

---

## 📋 ОБЗОР МИГРАЦИИ

Цель: Организовать существующие заметки по новой структуре PARA + Zettelkasten.

**Время выполнения:** 2-4 часа (в зависимости от количества заметок)

**Подход:** Постепенная миграция по категориям

---

## 🎯 ПЛАН МИГРАЦИИ

### Этап 1: Подготовка (15 минут)
- [ ] Создать резервную копию папки `knowledge/`
- [ ] Создать новую структуру папок
- [ ] Ознакомиться с новой системой

### Этап 2: Классификация (1-2 часа)
- [ ] Определить проекты → переместить в `01-Projects/`
- [ ] Определить обучение → переместить в `02-Areas/Learning/`
- [ ] Определить ресурсы → переместить в `03-Resources/`
- [ ] Определить личное → переместить в `02-Areas/`

### Этап 3: Организация (30-60 минут)
- [ ] Создать подпапки по технологиям/темам
- [ ] Переименовать файлы по новой системе именования
- [ ] Удалить дубликаты

### Этап 4: Метаданные (30-60 минут)
- [ ] Добавить YAML-метаданные в заметки
- [ ] Обновить теги
- [ ] Создать связи `[[ссылки]]`

### Этап 5: MOCs и связи (30 минут)
- [ ] Обновить существующие MOCs
- [ ] Создать обратные ссылки
- [ ] Проверить граф связей

---

## 📁 МАППИНГ СТАРЫХ ПАПОК В НОВЫЕ

### Существующая структура → Новая структура

```
ROAD TO THE BUSINESS/LEARN/          →  02-Areas/Learning/
  ├── JavaScript/                     →      02-Areas/Learning/JavaScript/
  ├── PHP/                            →      02-Areas/Learning/PHP/
  ├── REACT-NATIVE/                   →      02-Areas/Learning/React-Native/
  ├── Backend/                        →      02-Areas/Learning/Backend/
  ├── Bitrix/                         →      02-Areas/Learning/Bitrix/
  ├── Docker/                         →      03-Resources/Tools/Docker/
  ├── WordPress/                      →      02-Areas/Learning/WordPress/
  └── English/                        →      02-Areas/Learning/English/

ROAD TO THE BUSINESS/WORK/           →  01-Projects/Web-Studio/
  └── Веб-студия с нуля/              →      01-Projects/Web-Studio/

LIFE/                                →  02-Areas/
  ├── Agile life/                     →      02-Areas/Health/Agile-Life/
  ├── Films/                          →      02-Areas/Personal/Entertainment/
  └── VIDEO/                          →      02-Areas/Personal/Video/

_resources/                          →  03-Resources/
  └── links/                          →      03-Resources/External-Links/

Корневые файлы (паттерны)           →  03-Resources/Patterns/
Корневые файлы (Bitrix)              →  02-Areas/Learning/Bitrix/ или Bitrix-MOC
Корневые файлы (Docker)              →  03-Resources/Tools/Docker/
```

---

## 🔧 ПОШАГОВАЯ ИНСТРУКЦИЯ

### Шаг 1: Создание резервной копии

```bash
# В терминале (из папки knowledge/)
cp -r knowledge knowledge-backup-$(date +%Y%m%d)
```

### Шаг 2: Создание новой структуры папок

```bash
# Создать основные папки
mkdir -p "00-Inbox"
mkdir -p "01-Projects/Bitrix-Exam"
mkdir -p "01-Projects/React-Native-App"
mkdir -p "01-Projects/Web-Studio"

mkdir -p "02-Areas/Learning/JavaScript"
mkdir -p "02-Areas/Learning/PHP"
mkdir -p "02-Areas/Learning/React-Native"
mkdir -p "02-Areas/Learning/Backend"
mkdir -p "02-Areas/Learning/Bitrix"
mkdir -p "02-Areas/Learning/Docker"
mkdir -p "02-Areas/Learning/WordPress"
mkdir -p "02-Areas/Learning/English"

mkdir -p "02-Areas/Health/Agile-Life"
mkdir -p "02-Areas/Personal/Entertainment"
mkdir -p "02-Areas/Personal/Video"
mkdir -p "02-Areas/Career"

mkdir -p "03-Resources/Patterns/React-Native-Patterns"
mkdir -p "03-Resources/Patterns/PHP-Patterns"
mkdir -p "03-Resources/Patterns/DDD-Patterns"
mkdir -p "03-Resources/Cheat-Sheets"
mkdir -p "03-Resources/Tools/Docker"
mkdir -p "03-Resources/External-Links"

mkdir -p "04-Archive"
mkdir -p "99-MOCs"
```

### Шаг 3: Перемещение файлов по категориям

#### 3.1. Проекты

```bash
# Bitrix Exam
mv "Подготовка к экзамену Bitrix Framework.md" "01-Projects/Bitrix-Exam/"
mv "Личная инициатива и обучение по Bitrix.md" "01-Projects/Bitrix-Exam/"

# Web Studio
mv "ROAD TO THE BUSINESS/WORK/Веб-студия с нуля/"* "01-Projects/Web-Studio/"
```

#### 3.2. Обучение - JavaScript

```bash
mv "ROAD TO THE BUSINESS/LEARN/JAVASCRIPT/"* "02-Areas/Learning/JavaScript/"
mv "что такое REDUX.md" "02-Areas/Learning/JavaScript/"
```

#### 3.3. Обучение - PHP

```bash
mv "ROAD TO THE BUSINESS/LEARN/PHP/"* "02-Areas/Learning/PHP/"
mv "Мой метод.md" "02-Areas/Learning/PHP/"
```

#### 3.4. Обучение - React Native

```bash
mv "ROAD TO THE BUSINESS/LEARN/REACT-NATIVE/"* "02-Areas/Learning/React-Native/"
```

#### 3.5. Обучение - Backend

```bash
mv "ROAD TO THE BUSINESS/LEARN/Backend/"* "02-Areas/Learning/Backend/"
mv "Что нужно знать в базах данных.md" "02-Areas/Learning/Backend/"
mv "ORM.md" "02-Areas/Learning/Backend/"
mv "MVC.md" "02-Areas/Learning/Backend/"
mv "Тесты.md" "02-Areas/Learning/Backend/"
```

#### 3.6. Обучение - Bitrix

```bash
# Все заметки по Bitrix в одну папку
mv "*Bitrix*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Установка*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Управление*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Интеграция*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Компоненты*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Контент*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Информационные*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Вывод*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Комплексные*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Кеширование*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Поиск.md" "02-Areas/Learning/Bitrix/"
mv "Почтовая*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Расширение*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Разбор*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
mv "Лекция*.md" "02-Areas/Learning/Bitrix/" 2>/dev/null || true
```

#### 3.7. Обучение - Docker

```bash
mv "ROAD TO THE BUSINESS/LEARN/Docker/"* "02-Areas/Learning/Docker/"
mv "*docker*.md" "03-Resources/Tools/Docker/" 2>/dev/null || true
mv "*nginx*.md" "03-Resources/Tools/Docker/" 2>/dev/null || true
mv "*mysql*.md" "03-Resources/Tools/Docker/" 2>/dev/null || true
mv "*phpmyadmin*.md" "03-Resources/Tools/Docker/" 2>/dev/null || true
mv "Оркестр*.md" "03-Resources/Tools/Docker/" 2>/dev/null || true
mv "Настройка*.md" "03-Resources/Tools/Docker/" 2>/dev/null || true
mv "Базовый*.md" "03-Resources/Tools/Docker/" 2>/dev/null || true
mv "Минимальная*.md" "03-Resources/Tools/Docker/" 2>/dev/null || true
```

#### 3.8. Ресурсы - Паттерны

```bash
# React Native паттерны
mv "pattern*.md" "03-Resources/Patterns/React-Native-Patterns/" 2>/dev/null || true
mv "*pattern*.md" "03-Resources/Patterns/React-Native-Patterns/" 2>/dev/null || true
mv "local global state.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "hooks flow.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "render props.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "contextual DI.md" "03-Resources/Patterns/React-Native-Patterns/"

# React Native антипаттерны
mv "god component.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "props driiling.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "premature optimization.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "global state coupling.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "components folder.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "useEffect driven development.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "low level code.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "useWindowDimensions.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "useRouter expo.md" "03-Resources/Patterns/React-Native-Patterns/"

# React Native компоненты
mv "ScrollView.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "Pressable Component.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "SaveAreaView Component.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "KeyboardAvoidingView.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "Stack*.md" "03-Resources/Patterns/React-Native-Patterns/" 2>/dev/null || true
mv "Tabs.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "MMKV.md" "03-Resources/Patterns/React-Native-Patterns/"
mv "REATOM.md" "03-Resources/Patterns/React-Native-Patterns/"

# Общие паттерны
mv "Шаблон проектирования в разработке.md" "03-Resources/Patterns/PHP-Patterns/"
mv "CACHE, SOURCE OF TRUTH SEGREGATION.md" "03-Resources/Patterns/PHP-Patterns/"

# DDD
mv "*DDD*.md" "03-Resources/Patterns/DDD-Patterns/" 2>/dev/null || true

# SOLID
mv "S - SINGLE REPOSITORY PRINCIPLE.md" "03-Resources/Patterns/PHP-Patterns/"
mv "O - OPEN OR CLOSED PRINCIPLE.md" "03-Resources/Patterns/PHP-Patterns/"
mv "L - LISKOV SUBSTITUTION PRINCIPLE.md" "03-Resources/Patterns/PHP-Patterns/"
mv "I - INTERFACE SEGREGATION PRINCIPLE.md" "03-Resources/Patterns/PHP-Patterns/"
mv "D -.md" "03-Resources/Patterns/PHP-Patterns/"
mv "REACT NATIVE ARCHITECTURE PATTERNS.md" "03-Resources/Patterns/React-Native-Patterns/"
```

#### 3.9. Ресурсы - Внешние ссылки

```bash
mv "_resources/links/"* "03-Resources/External-Links/"
mv "_resources/Pasted image*.png" "03-Resources/External-Links/" 2>/dev/null || true
```

#### 3.10. Личное развитие

```bash
mv "LIFE/Agile life/"* "02-Areas/Health/Agile-Life/"
mv "LIFE/Films.md" "02-Areas/Personal/Entertainment/"
mv "LIFE/VIDEO/"* "02-Areas/Personal/Video/"
mv "Снегопад*.md" "02-Areas/Personal/Entertainment/" 2>/dev/null || true
```

#### 3.11. Разное

```bash
# Файлы без категории - в Inbox для обработки
mv "Untitled.md" "00-Inbox/" 2>/dev/null || true
mv "*Untitled*.md" "00-Inbox/" 2>/dev/null || true
mv "Введение*.md" "00-Inbox/" 2>/dev/null || true  # Проверить куда
```

### Шаг 4: Удаление старых папок

```bash
# Удалить старые пустые папки (после проверки!)
rm -rf "ROAD TO THE BUSINESS/"
rm -rf "LIFE/"
rm -rf "_resources/"  # Или оставить, если там еще что-то важное
```

### Шаг 5: Добавление метаданных

Используйте поиск и замену в Obsidian или скрипт для добавления YAML-метаданных в начало файлов.

**Пример для паттернов React Native:**

Добавить в начало каждого файла:

```yaml
---
type: pattern
category: react-native
created: 2024-12-15
status: active
tags: [pattern, react-native]
---
```

---

## ⚠️ ВАЖНЫЕ ЗАМЕЧАНИЯ

1. **Не удаляйте резервную копию** до завершения миграции
2. **Проверяйте ссылки** после перемещения файлов
3. **Обновляйте MOCs** после миграции каждой категории
4. **Делайте миграцию поэтапно** — не пытайтесь переместить всё сразу

---

## 🔍 ПРОВЕРКА ПОСЛЕ МИГРАЦИИ

### Чеклист:

- [ ] Все файлы перемещены в нужные папки
- [ ] Нет дубликатов файлов
- [ ] Все ссылки `[[заметка]]` работают
- [ ] MOCs обновлены и ссылаются на правильные пути
- [ ] Граф связей показывает связи между заметками
- [ ] Теги приведены к единому формату

---

## 📚 ДОПОЛНИТЕЛЬНЫЕ РЕСУРСЫ

- [[README_SYSTEM|Полное описание системы]]
- [[Home|Главная навигация]]
- [[00-Inbox/README|Инструкция по работе с Inbox]]

---

**Удачной миграции! 🚀**
