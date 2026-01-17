#!/bin/bash
# Скрипт для исправления тегов (приведение к единой системе)

set -euo pipefail

fix_tags_in_content() {
    local file="$1"
    local tmp_file=$(mktemp)
    local in_frontmatter=false
    local frontmatter_end=false
    
    while IFS= read -r line || [ -n "$line" ]; do
        # Обработка YAML frontmatter
        if [[ "$line" == "---" ]]; then
            if [ "$in_frontmatter" = false ]; then
                in_frontmatter=true
                echo "$line" >> "$tmp_file"
            else
                in_frontmatter=false
                frontmatter_end=true
                echo "$line" >> "$tmp_file"
            fi
            continue
        fi
        
        if [ "$in_frontmatter" = true ]; then
            echo "$line" >> "$tmp_file"
        else
            # Исправляем теги в содержимом
            local fixed_line="$line"
            
            # React Native
            fixed_line=$(echo "$fixed_line" | sed 's/^#react #reactnative #pattern$/#tech\/react-native #pattern\/react-native/g')
            fixed_line=$(echo "$fixed_line" | sed 's/^#react #reactnative #antipattern$/#tech\/react-native #pattern\/react-native #antipattern/g')
            fixed_line=$(echo "$fixed_line" | sed 's/^#reactnative$/#tech\/react-native/g')
            
            # Bitrix
            fixed_line=$(echo "$fixed_line" | sed 's/^#bitrix$/#tech\/bitrix/g')
            fixed_line=$(echo "$fixed_line" | sed 's/^#bitrix /#tech\/bitrix /g')
            
            # PHP
            fixed_line=$(echo "$fixed_line" | sed 's/^#php /#tech\/php /g')
            fixed_line=$(echo "$fixed_line" | sed 's/^#php$/#tech\/php/g')
            
            # JavaScript
            fixed_line=$(echo "$fixed_line" | sed 's/^#javascript$/#tech\/javascript/g')
            fixed_line=$(echo "$fixed_line" | sed 's/^#redux$/#tech\/javascript/g')
            
            # Docker
            fixed_line=$(echo "$fixed_line" | sed 's/#docker /#tech\/docker /g')
            
            # Agile Life
            fixed_line=$(echo "$fixed_line" | sed 's/#agilelife #life/#life\/agile/g')
            fixed_line=$(echo "$fixed_line" | sed 's/#life #agilelife/#life\/agile/g')
            
            # Backend
            fixed_line=$(echo "$fixed_line" | sed 's/#backend /#tech\/backend /g')
            
            echo "$fixed_line" >> "$tmp_file"
        fi
    done < "$file"
    
    mv "$tmp_file" "$file"
}

# Обрабатываем все .md файлы
find . -type f -name "*.md" \
    -not -path "./Templates/*" \
    -not -path "./README_SYSTEM.md" \
    -not -path "./MIGRATION*.md" \
    -not -path "./SYSTEM_STRUCTURE.md" \
    -print0 | while IFS= read -r -d '' file; do
    fix_tags_in_content "$file" 2>/dev/null || true
done
