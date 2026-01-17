# 🌳 СТРУКТУРА СИСТЕМЫ УПРАВЛЕНИЯ ЗНАНИЯМИ

> Визуальное дерево папок и файлов новой системы

---

## 📁 ПОЛНАЯ СТРУКТУРА ПАПОК

```
knowledge/
│
├── 📥 00-Inbox/                           # Временная папка для новых заметок
│   └── README.md                          # Инструкция по работе с Inbox
│
├── 🚀 01-Projects/                        # Активные проекты (с дедлайнами)
│   ├── Bitrix-Exam/                       # Проект: Подготовка к экзамену Bitrix
│   │   ├── Подготовка к экзамену Bitrix Framework.md
│   │   └── Личная инициатива и обучение по Bitrix.md
│   ├── React-Native-App/                  # Проект: Разработка React Native приложения
│   │   └── [файлы проекта]
│   └── Web-Studio/                        # Проект: Создание веб-студии
│       ├── Оглавление.md
│       ├── Заработок.md
│       ├── Поиск проектов.md
│       ├── Состав.md
│       ├── Стратегия набора команды.md
│       └── Сплотить команду в единый организм.md
│
├── 🎯 02-Areas/                           # Области ответственности (без дедлайнов)
│   ├── Learning/                          # Обучение
│   │   ├── JavaScript/                    # JavaScript обучение
│   │   │   ├── RS School. Курс JS Frontend-разработка.md
│   │   │   ├── что такое REDUX.md
│   │   │   └── [другие файлы JS]
│   │   ├── PHP/                           # PHP обучение
│   │   │   ├── Ключевые аспекты веб-разработки на PHP.md
│   │   │   ├── Классы в PHP.md
│   │   │   ├── Функции в PHP.md
│   │   │   └── [другие файлы PHP]
│   │   ├── React-Native/                  # React Native обучение
│   │   │   ├── ARCHITECTURE CLEAN REACT NATIVE.md
│   │   │   ├── how create React Native app.md
│   │   │   ├── how start React Native app.md
│   │   │   ├── REACT/
│   │   │   │   ├── ПАТТЕРНЫ.md
│   │   │   │   └── АНТИПАТТЕРНЫ.md
│   │   │   └── XCODE/
│   │   │       └── XCODE GUIDE.md
│   │   ├── Backend/                       # Backend обучение
│   │   │   ├── Темы, которые нужно знать на беке.md
│   │   │   ├── Что нужно знать в базах данных.md
│   │   │   ├── SMTP почта.md
│   │   │   ├── ORM.md
│   │   │   ├── MVC.md
│   │   │   └── Тесты.md
│   │   ├── Bitrix/                        # Bitrix Framework
│   │   │   ├── Основы архитектуры Bitrix Framework.md
│   │   │   ├── Установка и первичная настройка системы.md
│   │   │   ├── Управление публичной структурой сайта.md
│   │   │   ├── Интеграция HTML шаблона.md
│   │   │   ├── Компоненты.md
│   │   │   ├── Комплексные компоненты.md
│   │   │   ├── Информационные блоки.md
│   │   │   ├── Кеширование в компонентах.md
│   │   │   ├── Поиск.md
│   │   │   ├── Почтовая система.md
│   │   │   ├── Управление доступом и безопасностью.md
│   │   │   ├── Вывод динамической информации на сайте.md
│   │   │   └── [другие файлы Bitrix]
│   │   ├── Docker/                        # Docker обучение
│   │   │   └── Docker.md
│   │   ├── WordPress/                     # WordPress обучение
│   │   │   └── wp-lessions.md
│   │   └── English/                       # Английский язык
│   │       ├── English Learn Lib.md
│   │       └── Введение. Основные ссылки. (English).md
│   │
│   ├── Health/                            # Здоровье и энергия
│   │   └── Agile-Life/                    # Agile Life
│   │       ├── Введение (Планирование).md
│   │       ├── Введение (Восстановление энергии).md
│   │       ├── Agile и спринты.md
│   │       ├── Постановка целей на спринт.md
│   │       ├── Тест для направления agile-компаса.md
│   │       ├── Корпорация Мозг (Восстановление энергии).md
│   │       ├── Стресс и выгорание (Восстановление энергии).md
│   │       ├── Проверить себя на стресс.md
│   │       └── Энергия тела, разума и смысла (Восстановление энергии).md
│   │
│   ├── Personal/                          # Личное
│   │   ├── Entertainment/                 # Развлечения
│   │   │   ├── Films.md
│   │   │   └── Снегопад (сериал 2017 - 2023).md
│   │   └── Video/                         # Видео проекты
│   │       ├── Видео №1.md
│   │       └── Придумываем название канала.md
│   │
│   └── Career/                            # Карьера
│       └── [файлы карьеры]
│
├── 📚 03-Resources/                       # Справочные материалы (без дедлайнов)
│   ├── Patterns/                          # Паттерны программирования
│   │   ├── React-Native-Patterns/         # React Native паттерны
│   │   │   ├── pattern module.md
│   │   │   ├── pattern render as you fetch.md
│   │   │   ├── pattern ssr.md
│   │   │   ├── pattern slot.md
│   │   │   ├── pattern polymorphizm.md
│   │   │   ├── pattern mediator.md
│   │   │   ├── render props.md
│   │   │   ├── hooks flow.md
│   │   │   ├── local global state.md
│   │   │   ├── contextual DI.md
│   │   │   ├── god component.md (антипаттерн)
│   │   │   ├── props driiling.md (антипаттерн)
│   │   │   ├── premature optimization.md (антипаттерн)
│   │   │   ├── global state coupling.md (антипаттерн)
│   │   │   ├── components folder.md (антипаттерн)
│   │   │   ├── useEffect driven development.md (антипаттерн)
│   │   │   ├── low level code.md (антипаттерн)
│   │   │   ├── ScrollView.md
│   │   │   ├── Pressable Component.md
│   │   │   ├── SaveAreaView Component.md
│   │   │   ├── KeyboardAvoidingView.md
│   │   │   ├── Stack.md
│   │   │   ├── Stack.Screen.md
│   │   │   ├── Tabs.md
│   │   │   ├── useWindowDimensions.md
│   │   │   ├── useRouter expo.md
│   │   │   ├── MMKV.md
│   │   │   ├── REATOM.md
│   │   │   └── REACT NATIVE ARCHITECTURE PATTERNS.md
│   │   ├── PHP-Patterns/                  # PHP паттерны
│   │   │   ├── Шаблон проектирования в разработке.md
│   │   │   ├── CACHE, SOURCE OF TRUTH SEGREGATION.md
│   │   │   ├── S - SINGLE REPOSITORY PRINCIPLE.md
│   │   │   ├── O - OPEN OR CLOSED PRINCIPLE.md
│   │   │   ├── L - LISKOV SUBSTITUTION PRINCIPLE.md
│   │   │   ├── I - INTERFACE SEGREGATION PRINCIPLE.md
│   │   │   └── D -.md
│   │   └── DDD-Patterns/                  # DDD паттерны
│   │       ├── Что такое DDD архитектура.md
│   │       ├── DDD архитектура в RASA и как с ней работать.md
│   │       └── Методы написания DDD архитектурны.md
│   │
│   ├── Cheat-Sheets/                      # Шпаргалки
│   │   └── [быстрые справочники]
│   │
│   ├── Tools/                             # Инструменты
│   │   └── Docker/                        # Docker конфигурации
│   │       ├── Оркестр всех контейнеров - docker-compose.yml.md
│   │       ├── Базовый nginx.conf.md
│   │       ├── Базовый nginx.dockerfile.md
│   │       ├── Настройка сервиса nginx в docker-compose.yml.md
│   │       ├── Настройка mysql для docker.md
│   │       ├── phpmyadmin для docker-compose.yml.md
│   │       ├── Минимальная настройка PHP для docker-compose.yml.md
│   │       ├── Минимальная конфигурация php.dockerfile.md
│   │       ├── Минимальная конфигурация composer.dockerfile.md
│   │       ├── Минимальная конфигурация сервиса artisan.md
│   │       └── Настройка окружения для Laravel проекта.md
│   │
│   ├── External-Links/                    # Внешние ссылки
│   │   ├── [файлы из _resources/links/]
│   │   └── [изображения из _resources/]
│   │
│   └── Templates/                         # Шаблоны заметок
│       ├── Note-Template.md               # Шаблон обычной заметки
│       ├── Project-Template.md            # Шаблон проекта
│       ├── Meeting-Template.md            # Шаблон встречи
│       ├── Daily-Review-Template.md       # Шаблон ежедневного обзора
│       └── pattern.md                     # Шаблон паттерна
│
├── 📦 04-Archive/                         # Завершенные проекты (неактивные)
│   └── [год]-[месяц]/                     # Организация по дате
│       └── [завершенные проекты]
│
└── 🗺️ 99-MOCs/                           # Maps of Content (навигационные карты)
    ├── Home.md                            # 🏠 ГЛАВНАЯ ТОЧКА ВХОДА
    ├── Projects-MOC.md                    # Карта проектов
    ├── Learning-MOC.md                    # Карта обучения
    ├── Patterns-MOC.md                    # Карта паттернов
    ├── Resources-MOC.md                   # Карта ресурсов
    ├── Bitrix-MOC.md                      # Карта Bitrix
    └── Life-MOC.md                        # Карта личного развития

┌─────────────────────────────────────────────────────────────┐
│  📄 КОРНЕВЫЕ ФАЙЛЫ                                          │
├─────────────────────────────────────────────────────────────┤
│  README_SYSTEM.md          Полное описание системы          │
│  MIGRATION_GUIDE.md        Руководство по миграции          │
│  SYSTEM_STRUCTURE.md       Этот файл (структура)            │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 ПРИНЦИПЫ ОРГАНИЗАЦИИ

### PARA Методология

1. **Projects (01-Projects/)** — Активные проекты с дедлайнами
   - Bitrix Exam
   - React Native App
   - Web Studio

2. **Areas (02-Areas/)** — Области ответственности без дедлайнов
   - Learning — непрерывное обучение
   - Health — здоровье и энергия
   - Personal — личное развитие
   - Career — карьера

3. **Resources (03-Resources/)** — Справочные материалы
   - Patterns — паттерны программирования
   - Cheat-Sheets — шпаргалки
   - Tools — инструменты и конфигурации
   - External-Links — внешние ссылки
   - Templates — шаблоны заметок

4. **Archive (04-Archive/)** — Неактивные проекты
   - Организация по дате архивирования

### Дополнительные элементы

- **00-Inbox/** — Временная папка для новых заметок (обрабатывать ежедневно!)
- **99-MOCs/** — Навигационные карты (Maps of Content)

---

## 🏷️ СИСТЕМА ТЕГОВ

### Иерархия тегов (3 уровня):

```
#tech/
  #tech/javascript/
  #tech/react-native/
  #tech/php/
  #tech/bitrix/
  #tech/docker/

#project/
  #project/bitrix-exam/
  #project/web-studio/

#pattern/
  #pattern/react-native/
  #pattern/php/
  #pattern/ddd/

#learning/
  #learning/rsschool/
  #learning/hexlet/

#life/
  #life/agile/
  #life/health/
  #life/career/
```

---

## 📊 СТАТИСТИКА СИСТЕМЫ

**Всего категорий:** 4 основных (PARA) + 2 дополнительных (Inbox, MOCs)

**Основные MOCs:**
- Home (главная навигация)
- Projects-MOC
- Learning-MOC
- Patterns-MOC
- Resources-MOC
- Bitrix-MOC
- Life-MOC

**Шаблоны:** 5 шаблонов (Note, Project, Meeting, Daily-Review, Pattern)

**Области обучения:** 7 направлений (JavaScript, PHP, React Native, Backend, Bitrix, Docker, English)

---

## 🔗 СВЯЗАННЫЕ ДОКУМЕНТЫ

- [[README_SYSTEM|README_SYSTEM.md]] — полное описание системы
- [[MIGRATION_GUIDE|MIGRATION_GUIDE.md]] — руководство по миграции
- [[Home|99-MOCs/Home.md]] — главная навигация

---

**Последнее обновление:** 2024-12-15
