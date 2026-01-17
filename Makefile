# Makefile для автоматической обработки заметок в системе управления знаниями
# Использование: make process (обработать новые файлы)
#               make format-all (форматировать все файлы)
#               make check (проверить систему)

.PHONY: process format-all check format-file move-from-inbox add-metadata fix-tags fix-links update-mocs help

# Цвета для вывода
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Основная команда - обработать новые файлы
process: move-from-inbox format-new add-metadata fix-tags fix-links update-mocs
	@echo "$(GREEN)✅ Обработка завершена!$(NC)"

# Форматировать все файлы (использовать с осторожностью)
format-all:
	@echo "$(YELLOW)⚠️  Форматирование всех файлов...$(NC)"
	@find . -type f -name "*.md" -not -path "./99-MOCs/*" -not -path "./Templates/*" -not -path "./00-Inbox/*" -exec $(MAKE) format-file FILE={} \;
	@echo "$(GREEN)✅ Все файлы отформатированы!$(NC)"

# Форматировать новый файл (определяет тип и применяет правильный формат)
format-file:
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)❌ Ошибка: укажите FILE=путь/к/файлу.md$(NC)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)📝 Обработка: $(FILE)$(NC)"
	@bash scripts/format_file.sh "$(FILE)"

# Переместить файлы из Inbox в правильные папки
move-from-inbox:
	@echo "$(YELLOW)📥 Проверка Inbox...$(NC)"
	@bash scripts/move_from_inbox.sh
	@echo "$(GREEN)✅ Inbox обработан!$(NC)"

# Добавить YAML метаданные в файлы без них
add-metadata:
	@echo "$(YELLOW)📋 Добавление метаданных...$(NC)"
	@bash scripts/add_metadata.sh
	@echo "$(GREEN)✅ Метаданные добавлены!$(NC)"

# Исправить теги (привести к единой системе)
fix-tags:
	@echo "$(YELLOW)🏷️  Исправление тегов...$(NC)"
	@bash scripts/fix_tags.sh
	@echo "$(GREEN)✅ Теги исправлены!$(NC)"

# Исправить ссылки
fix-links:
	@echo "$(YELLOW)🔗 Проверка ссылок...$(NC)"
	@bash scripts/fix_links.sh
	@echo "$(GREEN)✅ Ссылки проверены!$(NC)"

# Обновить MOCs
update-mocs:
	@echo "$(YELLOW)🗺️  Обновление MOCs...$(NC)"
	@bash scripts/update_mocs.sh
	@echo "$(GREEN)✅ MOCs обновлены!$(NC)"

# Форматировать новые файлы (недавно измененные)
format-new:
	@echo "$(YELLOW)🆕 Форматирование новых файлов...$(NC)"
	@bash scripts/format_new_files.sh
	@echo "$(GREEN)✅ Новые файлы отформатированы!$(NC)"

# Проверить целостность системы
check:
	@echo "$(YELLOW)🔍 Проверка системы...$(NC)"
	@bash scripts/check_system.sh
	@echo "$(GREEN)✅ Проверка завершена!$(NC)"

# Помощь
help:
	@echo "$(GREEN)📚 Система управления знаниями - Makefile команды$(NC)"
	@echo ""
	@echo "$(YELLOW)Основные команды:$(NC)"
	@echo "  make process       - Обработать новые файлы (полный цикл)"
	@echo "  make format-new    - Форматировать только новые файлы"
	@echo "  make check         - Проверить целостность системы"
	@echo ""
	@echo "$(YELLOW)Индивидуальные операции:$(NC)"
	@echo "  make move-from-inbox  - Переместить файлы из Inbox"
	@echo "  make add-metadata     - Добавить YAML метаданные"
	@echo "  make fix-tags         - Исправить теги"
	@echo "  make fix-links        - Исправить ссылки"
	@echo "  make update-mocs      - Обновить MOCs"
	@echo ""
	@echo "$(YELLOW)Форматирование:$(NC)"
	@echo "  make format-file FILE=путь/к/файлу.md  - Форматировать конкретный файл"
	@echo "  make format-all       - Форматировать все файлы (осторожно!)"
	@echo ""
	@echo "$(YELLOW)Примеры:$(NC)"
	@echo "  make process"
	@echo "  make format-file FILE=02-Areas/Learning/PHP/Новый\ файл.md"
