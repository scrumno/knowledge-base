#!/bin/bash
# Скрипт для проверки целостности системы

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

check_count=0
error_count=0

# Проверка структуры папок
check_structure() {
    echo "📁 Проверка структуры папок..."
    
    local required_dirs=(
        "00-Inbox"
        "01-Projects"
        "02-Areas"
        "03-Resources"
        "04-Archive"
        "99-MOCs"
        "Templates"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo -e "  ${GREEN}✅${NC} $dir"
            check_count=$((check_count + 1))
        else
            echo -e "  ${RED}❌${NC} Отсутствует: $dir"
            error_count=$((error_count + 1))
        fi
    done
}

# Проверка MOCs
check_mocs() {
    echo -e "\n🗺️  Проверка MOCs..."
    
    local required_mocs=(
        "99-MOCs/Home.md"
        "99-MOCs/Projects-MOC.md"
        "99-MOCs/Learning-MOC.md"
        "99-MOCs/Patterns-MOC.md"
        "99-MOCs/Resources-MOC.md"
        "99-MOCs/Bitrix-MOC.md"
        "99-MOCs/Life-MOC.md"
    )
    
    for moc in "${required_mocs[@]}"; do
        if [ -f "$moc" ]; then
            echo -e "  ${GREEN}✅${NC} $(basename $moc)"
            check_count=$((check_count + 1))
        else
            echo -e "  ${RED}❌${NC} Отсутствует: $moc"
            error_count=$((error_count + 1))
        fi
    done
}

# Проверка шаблонов
check_templates() {
    echo -e "\n📋 Проверка шаблонов..."
    
    local required_templates=(
        "Templates/Note-Template.md"
        "Templates/Project-Template.md"
        "Templates/Meeting-Template.md"
        "Templates/Daily-Review-Template.md"
    )
    
    for template in "${required_templates[@]}"; do
        if [ -f "$template" ]; then
            echo -e "  ${GREEN}✅${NC} $(basename $template)"
            check_count=$((check_count + 1))
        else
            echo -e "  ${RED}❌${NC} Отсутствует: $template"
            error_count=$((error_count + 1))
        fi
    done
}

# Проверка файлов без метаданных
check_metadata() {
    echo -e "\n📝 Проверка метаданных..."
    
    local files_without_metadata=0
    
    find . -type f -name "*.md" \
        -not -path "./Templates/*" \
        -not -path "./README_SYSTEM.md" \
        -not -path "./MIGRATION*.md" \
        -not -path "./SYSTEM_STRUCTURE.md" \
        -not -path "./LINKS_FIXED.md" \
        -not -path "./TAGS_FIXED.md" \
        -print0 | while IFS= read -r -d '' file; do
        if ! grep -q "^---" "$file" 2>/dev/null || ! grep -qE "^type:" "$file" 2>/dev/null; then
            files_without_metadata=$((files_without_metadata + 1))
        fi
    done
    
    if [ $files_without_metadata -eq 0 ]; then
        echo -e "  ${GREEN}✅${NC} Все файлы имеют метаданные"
    else
        echo -e "  ${YELLOW}⚠️  ${NC} Файлов без метаданных: $files_without_metadata (запустите 'make add-metadata')"
    fi
}

# Статистика
show_statistics() {
    echo -e "\n📊 Статистика системы:"
    
    local total_md=$(find . -type f -name "*.md" | wc -l | tr -d ' ')
    local total_dirs=$(find . -type d -not -path "./.git*" -not -path "./.obsidian*" | wc -l | tr -d ' ')
    local inbox_files=$(find "00-Inbox" -maxdepth 1 -name "*.md" -not -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
    
    echo "  - Всего .md файлов: $total_md"
    echo "  - Папок: $total_dirs"
    echo "  - Файлов в Inbox: $inbox_files"
    
    if [ "$inbox_files" -gt 5 ]; then
        echo -e "  ${YELLOW}⚠️  В Inbox много файлов (запустите 'make move-from-inbox')${NC}"
    fi
}

# Главная функция
main() {
    echo -e "${GREEN}🔍 Проверка системы управления знаниями${NC}\n"
    
    check_structure
    check_mocs
    check_templates
    check_metadata
    show_statistics
    
    echo -e "\n${GREEN}✅ Проверка завершена!${NC}"
    echo "  Успешных проверок: $check_count"
    if [ $error_count -gt 0 ]; then
        echo -e "  ${RED}Ошибок: $error_count${NC}"
        exit 1
    fi
}

main
