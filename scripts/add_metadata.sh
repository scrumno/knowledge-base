#!/bin/bash
# Скрипт для добавления YAML метаданных в файлы без них

set -euo pipefail

CURRENT_DATE=$(date +%Y-%m-%d)

add_metadata_if_missing() {
    local file="$1"
    
    # Пропускаем файлы с уже существующим frontmatter
    if grep -q "^---" "$file" 2>/dev/null && grep -qE "^type:" "$file" 2>/dev/null; then
        return 0
    fi
    
    # Определяем тип файла
    local file_type="note"
    if [[ "$file" == *"01-Projects/"* ]]; then
        file_type="project"
    elif [[ "$file" == *"03-Resources/Patterns/"* ]]; then
        file_type="pattern"
    elif [[ "$file" == *"99-MOCs/"* ]]; then
        file_type="MOC"
    elif grep -qiE "(паттерн|pattern)" "$file" 2>/dev/null; then
        file_type="pattern"
    elif grep -qiE "(проект|project|задача)" "$file" 2>/dev/null; then
        file_type="project"
    fi
    
    # Создаем frontmatter
    local frontmatter=""
    case "$file_type" in
        project)
            frontmatter="---
type: project
status: in-progress
priority: medium
created: ${CURRENT_DATE}
updated: ${CURRENT_DATE}
tags: []
---"
            ;;
        pattern)
            frontmatter="---
type: pattern
created: ${CURRENT_DATE}
updated: ${CURRENT_DATE}
status: active
tags: []
---"
            ;;
        MOC)
            frontmatter="---
type: MOC
created: ${CURRENT_DATE}
updated: ${CURRENT_DATE}
tags: []
---"
            ;;
        *)
            frontmatter="---
type: note
created: ${CURRENT_DATE}
updated: ${CURRENT_DATE}
status: active
tags: []
related: []
---"
            ;;
    esac
    
    # Добавляем frontmatter в начало файла
    if ! grep -q "^---" "$file" 2>/dev/null; then
        echo "$frontmatter" > "${file}.tmp"
        cat "$file" >> "${file}.tmp"
        mv "${file}.tmp" "$file"
    fi
}

# Обрабатываем все .md файлы кроме системных
find . -type f -name "*.md" \
    -not -path "./Templates/*" \
    -not -path "./README_SYSTEM.md" \
    -not -path "./MIGRATION*.md" \
    -not -path "./SYSTEM_STRUCTURE.md" \
    -not -path "./LINKS_FIXED.md" \
    -not -path "./TAGS_FIXED.md" \
    -print0 | while IFS= read -r -d '' file; do
    add_metadata_if_missing "$file" 2>/dev/null || true
done
