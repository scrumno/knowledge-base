#!/bin/bash
# Скрипт для проверки и исправления ссылок

set -euo pipefail

# Найти все битые ссылки (ссылаются на несуществующие файлы)
find_broken_links() {
    local file="$1"
    local broken_count=0
    
    # Извлекаем все [[ссылки]]
    grep -oE '\[\[[^]]+\]\]' "$file" 2>/dev/null | while IFS= read -r link; do
        local link_content=$(echo "$link" | sed 's/\[\[//; s/\]\]//; s/|.*$//')
        local link_file=""
        
        # Проверяем разные форматы ссылок
        if [[ "$link_content" == *"/"* ]]; then
            # Полный путь
            link_file="$link_content.md"
        else
            # Короткое имя - ищем по всей структуре
            link_file=$(find . -name "${link_content}.md" -type f 2>/dev/null | head -1)
        fi
        
        if [ -z "$link_file" ] || [ ! -f "$link_file" ]; then
            echo "  ⚠️  Битая ссылка: $link_content"
            broken_count=$((broken_count + 1))
        fi
    done
    
    return $broken_count
}

# Исправляем ссылки на старые пути
fix_old_paths() {
    local file="$1"
    
    # Создаем временный файл
    sed -i '' \
        -e 's|\[\[ROAD TO THE BUSINESS/WORK/Веб-студия с нуля/|[[01-Projects/Web-Studio/|g' \
        -e 's|\[\[ROAD TO THE BUSINESS/LEARN/|[[02-Areas/Learning/|g' \
        -e 's|\[\[LIFE/|[[02-Areas/Health/Agile-Life/|g' \
        -e 's|\[\[_resources/links/|[[03-Resources/External-Links/|g' \
        -e 's|\[\[VIDEO/|[[02-Areas/Personal/Video/|g' \
        -e 's|\[\[Films|[[02-Areas/Personal/Entertainment/Films|g' \
        "$file" 2>/dev/null || true
}

# Главная функция
main() {
    local total_broken=0
    
    # Обрабатываем все .md файлы
    find . -type f -name "*.md" \
        -not -path "./Templates/*" \
        -print0 | while IFS= read -r -d '' file; do
        fix_old_paths "$file"
    done
    
    echo "✅ Старые пути исправлены"
}

main
