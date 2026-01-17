#!/bin/bash
# Скрипт для форматирования новых файлов
# Находит новые/измененные файлы и форматирует их

set -euo pipefail

# Найти все .md файлы кроме MOCs, Templates и системных
find . -type f -name "*.md" \
    -not -path "./99-MOCs/*" \
    -not -path "./Templates/*" \
    -not -path "./README_SYSTEM.md" \
    -not -path "./MIGRATION*.md" \
    -not -path "./SYSTEM_STRUCTURE.md" \
    -not -path "./LINKS_FIXED.md" \
    -not -path "./TAGS_FIXED.md" \
    -print0 | while IFS= read -r -d '' file; do
    
    # Форматируем файл
    ./scripts/format_file.sh "$file" 2>/dev/null || true
done
