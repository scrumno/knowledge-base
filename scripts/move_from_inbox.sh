#!/bin/bash
# Скрипт для перемещения файлов из Inbox в правильные папки
# Анализирует содержимое файла и определяет куда его переместить

set -euo pipefail

INBOX_DIR="00-Inbox"
SKIP_FILES=("README.md")

# Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Определить куда переместить файл на основе содержимого
determine_destination() {
    local file="$1"
    local content=$(cat "$file" 2>/dev/null || echo "")
    local basename=$(basename "$file")
    
    # Проекты - ищем ключевые слова
    if grep -qiE "(проект|project|задача|дедлайн|deadline|sprint|спринт)" "$file" 2>/dev/null; then
        if grep -qiE "(bitrix|битрикс)" "$file" 2>/dev/null; then
            echo "01-Projects/Bitrix-Exam/"
        elif grep -qiE "(react.*native|reactnative)" "$file" 2>/dev/null; then
            echo "01-Projects/React-Native-App/"
        elif grep -qiE "(web.*studio|веб.*студия|webstudio)" "$file" 2>/dev/null; then
            echo "01-Projects/Web-Studio/"
        else
            echo "01-Projects/"
        fi
        return
    fi
    
    # Паттерны
    if grep -qiE "(паттерн|pattern|антипаттерн|antipattern)" "$file" 2>/dev/null; then
        if grep -qiE "(react|reactnative)" "$file" 2>/dev/null; then
            echo "03-Resources/Patterns/React-Native-Patterns/"
        elif grep -qiE "(ddd|domain.*driven)" "$file" 2>/dev/null; then
            echo "03-Resources/Patterns/DDD-Patterns/"
        elif grep -qiE "(php|solid|mvc|orm)" "$file" 2>/dev/null; then
            echo "03-Resources/Patterns/PHP-Patterns/"
        else
            echo "03-Resources/Patterns/"
        fi
        return
    fi
    
    # Bitrix
    if grep -qiE "(bitrix|битрикс|компонент|информационный блок)" "$file" 2>/dev/null; then
        echo "02-Areas/Learning/Bitrix/"
        return
    fi
    
    # React Native
    if grep -qiE "(react.*native|reactnative|expo)" "$file" 2>/dev/null; then
        echo "02-Areas/Learning/React-Native/"
        return
    fi
    
    # PHP
    if grep -qiE "(php|laravel|slim)" "$file" 2>/dev/null && ! grep -qiE "bitrix" "$file" 2>/dev/null; then
        echo "02-Areas/Learning/PHP/"
        return
    fi
    
    # JavaScript
    if grep -qiE "(javascript|js|redux|typescript)" "$file" 2>/dev/null; then
        echo "02-Areas/Learning/JavaScript/"
        return
    fi
    
    # Backend
    if grep -qiE "(database|sql|orm|mvc|backend|api)" "$file" 2>/dev/null; then
        echo "02-Areas/Learning/Backend/"
        return
    fi
    
    # Docker
    if grep -qiE "(docker|nginx|mysql|compose|container)" "$file" 2>/dev/null; then
        echo "03-Resources/Tools/Docker/"
        return
    fi
    
    # Agile Life
    if grep -qiE "(agile|спринт|энергия|стресс|мозг)" "$file" 2>/dev/null; then
        echo "02-Areas/Health/Agile-Life/"
        return
    fi
    
    # Личное / Развлечения
    if grep -qiE "(фильм|сериал|игра|game|view)" "$file" 2>/dev/null; then
        echo "02-Areas/Personal/Entertainment/"
        return
    fi
    
    # Если не определили - оставляем в Inbox
    echo ""
}

# Главная функция
main() {
    local moved=0
    local skipped=0
    
    if [ ! -d "$INBOX_DIR" ]; then
        echo -e "${YELLOW}⚠️  Папка Inbox не найдена${NC}"
        return
    fi
    
    echo -e "${YELLOW}📥 Обработка Inbox...${NC}"
    
    # Обрабатываем все .md файлы кроме README
    find "$INBOX_DIR" -maxdepth 1 -name "*.md" -type f -print0 | while IFS= read -r -d '' file; do
        local basename=$(basename "$file")
        
        # Пропускаем README и системные файлы
        if [[ " ${SKIP_FILES[@]} " =~ " ${basename} " ]]; then
            continue
        fi
        
        local dest=$(determine_destination "$file")
        
        if [ -z "$dest" ]; then
            echo -e "  ⚠️  Не удалось определить место для: $basename (остается в Inbox)"
            skipped=$((skipped + 1))
            continue
        fi
        
        # Создаем папку назначения если нужно
        mkdir -p "$dest"
        
        # Перемещаем файл (правильная обработка путей с пробелами)
        local dest_file="$dest/$basename"
        if mv "$file" "$dest_file" 2>/dev/null; then
            echo -e "  ${GREEN}✅${NC} $basename → $dest"
            moved=$((moved + 1))
        else
            echo -e "  ${RED}❌${NC} Ошибка перемещения: $basename"
        fi
    done
    
    echo -e "\n${GREEN}📊 Итого:${NC} перемещено: $moved, пропущено: $skipped"
}

main
