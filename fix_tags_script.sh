#!/bin/bash
# Скрипт для исправления тегов в системе

cd /Users/rasa/knowledge/knowledge

# React Native паттерны - заменить на категорийные теги
find "03-Resources/Patterns/React-Native-Patterns" -name "*.md" -type f -print0 | while IFS= read -r -d '' file; do
    # Паттерны
    sed -i '' 's/^#react #reactnative #pattern$/#tech\/react-native #pattern\/react-native/g' "$file"
    # Антипаттерны
    sed -i '' 's/^#react #reactnative #antipattern$/#tech\/react-native #pattern\/react-native #antipattern/g' "$file"
done

# Bitrix файлы - заменить на #tech/bitrix
find "02-Areas/Learning/Bitrix" -name "*.md" -type f -exec sed -i '' 's/^#bitrix$/#tech\/bitrix/g' {} \;

# PHP файлы - базовые замены
find "02-Areas/Learning/PHP" -name "*.md" -type f -print0 | while IFS= read -r -d '' file; do
    sed -i '' 's/^#php #bitrix/#tech\/php #tech\/bitrix/g' "$file"
    sed -i '' 's/^#php #backend/#tech\/php #tech\/backend/g' "$file"
    sed -i '' 's/^#php #code/#tech\/php/g' "$file"
    sed -i '' 's/^#php$/#tech\/php/g' "$file"
done

# Backend файлы
find "02-Areas/Learning/Backend" -name "*.md" -type f -print0 | while IFS= read -r -d '' file; do
    sed -i '' 's/#php #javascript #backend/#tech\/php #tech\/javascript #tech\/backend/g' "$file"
done

# Docker файлы
find "03-Resources/Tools/Docker" -name "*.md" -type f -exec sed -i '' 's/#docker/#tech\/docker/g' {} \;
find "03-Resources/Tools/Docker" -name "*.md" -type f -exec sed -i '' 's/#php #docker/#tech\/php #tech\/docker/g' {} \;

# Agile Life
find "02-Areas/Health/Agile-Life" -name "*.md" -type f -print0 | while IFS= read -r -d '' file; do
    sed -i '' 's/#agilelife #life/#life\/agile/g' "$file"
    sed -i '' 's/#life #agilelife/#life\/agile/g' "$file"
done

# JavaScript
find "02-Areas/Learning/JavaScript" -name "*.md" -type f -exec sed -i '' 's/#javascript #learn/#tech\/javascript #learning/g' {} \;
find "02-Areas/Learning/JavaScript" -name "*.md" -type f -exec sed -i '' 's/#react #reactnative #javascript/#tech\/react-native #tech\/javascript/g' {} \;
find "02-Areas/Learning/JavaScript" -name "*.md" -type f -exec sed -i '' 's/#redux$/#tech\/javascript/g' {} \;

# React Native обучение
find "02-Areas/Learning/React-Native" -name "*.md" -type f -exec sed -i '' 's/#reactnative$/#tech\/react-native/g' {} \;

# Проекты Web Studio
find "01-Projects/Web-Studio" -name "*.md" -type f -exec sed -i '' 's/#webstudio$/#project\/web-studio/g' {} \;

# Bitrix Exam проект
find "01-Projects/Bitrix-Exam" -name "*.md" -type f -exec sed -i '' 's/#bitrix$/#tech\/bitrix #project\/bitrix-exam/g' {} \;

echo "Теги исправлены!"
