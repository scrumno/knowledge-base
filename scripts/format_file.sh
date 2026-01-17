#!/bin/bash
# Скрипт для форматирования одного файла
# Автоматически определяет тип и применяет правильный формат

set -euo pipefail

FILE="$1"
BASENAME=$(basename "$FILE")
DIRNAME=$(dirname "$FILE")
CONTENT=$(cat "$FILE")

# Определяем тип файла на основе пути и содержимого
detect_file_type() {
    local file="$1"
    local path="$file"
    
    # По пути папки
    if [[ "$path" == *"01-Projects/"* ]]; then
        echo "project"
    elif [[ "$path" == *"03-Resources/Patterns/"* ]]; then
        echo "pattern"
    elif [[ "$path" == *"99-MOCs/"* ]]; then
        echo "MOC"
    elif [[ "$path" == *"Templates/"* ]]; then
        echo "template"
    elif [[ "$path" == *"00-Inbox/"* ]]; then
        echo "inbox"
    # По содержимому
    elif grep -qE "^#.*(паттерн|pattern|антипаттерн)" "$file" 2>/dev/null; then
        echo "pattern"
    elif grep -qE "(type: project|type: meeting|type: daily-review)" "$file" 2>/dev/null; then
        grep -oE "type: \w+" "$file" | head -1 | cut -d' ' -f2
    else
        echo "note"
    fi
}

# Определяем категорию для тегов
detect_category() {
    local file="$1"
    local path="$file"
    
    if [[ "$path" == *"Bitrix"* ]] || grep -qi "bitrix" "$file" 2>/dev/null; then
        echo "bitrix"
    elif [[ "$path" == *"React-Native"* ]] || [[ "$path" == *"REACT"* ]] || grep -qiE "react|reactnative" "$file" 2>/dev/null; then
        echo "react-native"
    elif [[ "$path" == *"PHP"* ]] || grep -qiE "^#php|php" "$file" 2>/dev/null; then
        echo "php"
    elif [[ "$path" == *"JavaScript"* ]] || grep -qiE "javascript|js|redux" "$file" 2>/dev/null; then
        echo "javascript"
    elif [[ "$path" == *"Backend"* ]] || grep -qiE "backend|database|sql|orm" "$file" 2>/dev/null; then
        echo "backend"
    elif [[ "$path" == *"Docker"* ]] || grep -qiE "docker|nginx|mysql|compose" "$file" 2>/dev/null; then
        echo "docker"
    elif [[ "$path" == *"Agile-Life"* ]] || grep -qiE "agile|спринт|энергия" "$file" 2>/dev/null; then
        echo "life-agile"
    else
        echo "general"
    fi
}

# Получить или создать YAML frontmatter
get_yaml_frontmatter() {
    local file="$1"
    local file_type="$2"
    local category="$3"
    local current_date=$(date +%Y-%m-%d)
    
    # Проверяем, есть ли уже frontmatter
    if grep -q "^---" "$file" 2>/dev/null; then
        # Извлекаем существующий frontmatter
        sed -n '1,/^---$/p' "$file" | sed '/^---$/d'
    else
        # Создаем новый frontmatter
        case "$file_type" in
            project)
                cat <<EOF
---
type: project
status: in-progress
priority: medium
created: ${current_date}
updated: ${current_date}
tags: []
---
EOF
                ;;
            pattern)
                cat <<EOF
---
type: pattern
category: ${category}
created: ${current_date}
updated: ${current_date}
status: active
tags: []
---
EOF
                ;;
            meeting)
                cat <<EOF
---
type: meeting
date: ${current_date}
participants: []
project: []
action-items: []
created: ${current_date}
tags: []
---
EOF
                ;;
            daily-review)
                cat <<EOF
---
type: daily-review
date: ${current_date}
energy-level: medium
focus-areas: []
completed: []
blockers: []
created: ${current_date}
tags: []
---
EOF
                ;;
            MOC)
                cat <<EOF
---
type: MOC
created: ${current_date}
updated: ${current_date}
tags: []
---
EOF
                ;;
            *)
                cat <<EOF
---
type: note
created: ${current_date}
updated: ${current_date}
status: active
tags: []
related: []
---
EOF
                ;;
        esac
    fi
}

# Исправить теги в файле
fix_tags_in_file() {
    local file="$1"
    local category="$2"
    
    # Создаем временный файл
    local tmp_file=$(mktemp)
    local in_frontmatter=false
    local frontmatter_end=false
    
    while IFS= read -r line || [ -n "$line" ]; do
        # Обработка YAML frontmatter
        if [[ "$line" == "---" ]]; then
            if [ "$in_frontmatter" = false ]; then
                in_frontmatter=true
                echo "$line" >> "$tmp_file"
                continue
            else
                in_frontmatter=false
                frontmatter_end=true
                echo "$line" >> "$tmp_file"
                continue
            fi
        fi
        
        if [ "$in_frontmatter" = true ]; then
            # В frontmatter - оставляем как есть
            echo "$line" >> "$tmp_file"
        elif [ "$frontmatter_end" = true ] || [ "$in_frontmatter" = false ]; then
            # В содержимом - исправляем теги
            local fixed_line="$line"
            
            # Исправляем теги на основе категории
            case "$category" in
                bitrix)
                    fixed_line=$(echo "$fixed_line" | sed 's/^#bitrix$/#tech\/bitrix/g')
                    fixed_line=$(echo "$fixed_line" | sed 's/#bitrix /#tech\/bitrix /g')
                    ;;
                react-native)
                    fixed_line=$(echo "$fixed_line" | sed 's/#react #reactnative\( #pattern\)\?/#tech\/react-native #pattern\/react-native/g')
                    fixed_line=$(echo "$fixed_line" | sed 's/#react #reactnative\( #antipattern\)\?/#tech\/react-native #pattern\/react-native #antipattern/g')
                    fixed_line=$(echo "$fixed_line" | sed 's/#reactnative$/#tech\/react-native/g')
                    ;;
                php)
                    fixed_line=$(echo "$fixed_line" | sed 's/^#php /#tech\/php /g')
                    fixed_line=$(echo "$fixed_line" | sed 's/^#php$/#tech\/php/g')
                    ;;
                javascript)
                    fixed_line=$(echo "$fixed_line" | sed 's/^#javascript$/#tech\/javascript/g')
                    fixed_line=$(echo "$fixed_line" | sed 's/#redux$/#tech\/javascript/g')
                    ;;
                docker)
                    fixed_line=$(echo "$fixed_line" | sed 's/#docker /#tech\/docker /g')
                    ;;
                life-agile)
                    fixed_line=$(echo "$fixed_line" | sed 's/#agilelife #life/#life\/agile/g')
                    fixed_line=$(echo "$fixed_line" | sed 's/#life #agilelife/#life\/agile/g')
                    ;;
            esac
            
            echo "$fixed_line" >> "$tmp_file"
        fi
    done < "$file"
    
    mv "$tmp_file" "$file"
}

# Главная функция форматирования
main() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "❌ Файл не найден: $file"
        exit 1
    fi
    
    # Пропускаем системные файлы
    local basename=$(basename "$file")
    if [[ "$basename" == "README"* ]] || \
       [[ "$basename" == "MIGRATION"* ]] || \
       [[ "$basename" == "SYSTEM_STRUCTURE.md" ]] || \
       [[ "$basename" == "LINKS_FIXED.md" ]] || \
       [[ "$basename" == "TAGS_FIXED.md" ]] || \
       [[ "$basename" == "MAKEFILE_GUIDE.md" ]]; then
        return 0
    fi
    
    # Определяем тип и категорию
    local file_type=$(detect_file_type "$file")
    local category=$(detect_category "$file")
    
    # Добавляем/обновляем YAML frontmatter если его нет или он неполный
    if ! grep -q "^---" "$file" 2>/dev/null || ! grep -qE "^type:" "$file" 2>/dev/null; then
        local frontmatter=$(get_yaml_frontmatter "$file" "$file_type" "$category")
        
        if grep -q "^---" "$file" 2>/dev/null; then
            # Заменяем существующий frontmatter (удаляем первый блок --- ... ---)
            local temp_file=$(mktemp)
            local in_frontmatter=false
            local frontmatter_removed=false
            
            while IFS= read -r line || [ -n "$line" ]; do
                if [[ "$line" == "---" ]]; then
                    if [ "$in_frontmatter" = false ] && [ "$frontmatter_removed" = false ]; then
                        in_frontmatter=true
                        continue
                    elif [ "$in_frontmatter" = true ]; then
                        in_frontmatter=false
                        frontmatter_removed=true
                        continue
                    fi
                fi
                
                if [ "$in_frontmatter" = false ] || [ "$frontmatter_removed" = true ]; then
                    echo "$line" >> "$temp_file"
                fi
            done < "$file"
            
            # Добавляем новый frontmatter
            echo "$frontmatter" > "${file}.new"
            cat "$temp_file" >> "${file}.new"
            mv "${file}.new" "$file"
            rm "$temp_file"
        else
            # Добавляем новый frontmatter в начало
            echo "$frontmatter" > temp_frontmatter.txt
            cat temp_frontmatter.txt "$file" > temp_file.txt
            mv temp_file.txt "$file"
            rm temp_frontmatter.txt
        fi
    fi
    
    # Исправляем теги
    fix_tags_in_file "$file" "$category"
}

# Вызываем main если скрипт запущен напрямую
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -eq 0 ]; then
        echo "❌ Ошибка: укажите путь к файлу"
        exit 1
    fi
    main "$1"
fi

# Если скрипт импортирован, используем переменную FILE
if [ -n "${FILE:-}" ]; then
    main "$FILE"
fi
