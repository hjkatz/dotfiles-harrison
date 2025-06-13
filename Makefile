# Makefile for .dotfiles-harrison management
# Provides install, update, clean, and version management functionality

# Configuration
SHELL := /bin/bash
DOTFILES_HOME := $(HOME)/.dotfiles-harrison
VERSION_FILE := VERSION
CURRENT_VERSION := $(shell cat $(VERSION_FILE) 2>/dev/null || echo "0.0.0")

# Colors for output
RED := \033[1;31m
GREEN := \033[1;32m
YELLOW := \033[1;33m
BLUE := \033[1;34m
PURPLE := \033[1;35m
CYAN := \033[1;36m
WHITE := \033[1;37m
RESET := \033[0m

# Helper function for colored output
define color_echo
	@echo -e "$(1)$(2)$(RESET)"
endef

# Default target
.PHONY: help
help: ## Show this help message
	$(call color_echo,$(BLUE),📋 Dotfiles Management Commands)
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo
	$(call color_echo,$(WHITE),Current version: $(CURRENT_VERSION))

.PHONY: install
install: ## Install dotfiles (create symlinks and setup)
	$(call color_echo,$(PURPLE),📦 Installing dotfiles...)
	@chmod +x bin/install.sh
	@bash bin/install.sh
	$(call color_echo,$(GREEN),✅ Installation complete!)

.PHONY: update
update: ## Update dotfiles from git and refresh configuration
	$(call color_echo,$(BLUE),🔄 Updating dotfiles...)
	@git fetch origin
	@git pull origin master
	@if command -v zsh >/dev/null 2>&1; then \
		zsh -c "source $(DOTFILES_HOME)/zshrc && dotfiles_template_recompile"; \
	fi
	$(call color_echo,$(GREEN),✅ Update complete!)

.PHONY: clean
clean: ## Clean cache files and async jobs
	$(call color_echo,$(YELLOW),🧹 Cleaning dotfiles cache...)
	@if [[ -d .cache ]]; then \
		find .cache -type f -name "*.pid" -delete 2>/dev/null || true; \
		find .cache -type f -mtime +1 -delete 2>/dev/null || true; \
		rm -f .cache/plugins_combined.zsh .cache/zshrc_d_combined.zsh 2>/dev/null || true; \
		rm -f .cache/completion_* .cache/bash_completions_loaded 2>/dev/null || true; \
	fi
	@rm -f .init_lua_checksum 2>/dev/null || true
	@if command -v zsh >/dev/null 2>&1; then \
		zsh -c "source $(DOTFILES_HOME)/zshrc && dotfiles_template_clean" 2>/dev/null || true; \
		zsh -c "source $(DOTFILES_HOME)/zshrc && dotfiles_async_clean" 2>/dev/null || true; \
	fi
	$(call color_echo,$(GREEN),✅ Cache cleaned!)

.PHONY: clean-all
clean-all: clean ## Deep clean: remove all cache, compiled files, and vim plugins
	$(call color_echo,$(YELLOW),🗑️  Deep cleaning dotfiles...)
	@rm -rf .cache compiled .vim/plugged .vim/autoload/plug.vim 2>/dev/null || true
	@rm -f .last_updated_at templates/*~ 2>/dev/null || true
	$(call color_echo,$(GREEN),✅ Deep clean complete!)

.PHONY: uninstall
uninstall: ## Remove dotfiles symlinks (restore backup if available)
	$(call color_echo,$(RED),🗑️  Uninstalling dotfiles...)
	@echo "This will remove dotfiles symlinks from your home directory."
	@read -p "Are you sure? (y/N): " confirm; \
	if [[ $$confirm == [yY] || $$confirm == [yY][eE][sS] ]]; then \
		rm -f $(HOME)/.zshrc $(HOME)/.vimrc $(HOME)/.gitconfig $(HOME)/.psqlrc; \
		rm -f $(HOME)/.vim $(HOME)/.config/nvim/init.lua; \
		if [[ -f $(HOME)/.zshrc_local ]]; then \
			echo "Restoring backup from ~/.zshrc_local"; \
			tail -n +2 $(HOME)/.zshrc_local > $(HOME)/.zshrc; \
		fi; \
		echo -e "$(GREEN)✅ Dotfiles uninstalled!$(RESET)"; \
	else \
		echo -e "$(YELLOW)❌ Uninstall cancelled$(RESET)"; \
	fi

.PHONY: status
status: ## Show dotfiles status and diagnostics
	$(call color_echo,$(BLUE),📊 Dotfiles Status)
	@echo
	$(call color_echo,$(WHITE),Version: $(CURRENT_VERSION))
	$(call color_echo,$(WHITE),Location: $(DOTFILES_HOME))
	@echo
	@echo "Git Status:"
	@git status --porcelain | head -10 || echo "  No changes"
	@echo
	@echo "Symlinks:"
	@for file in .zshrc .vimrc .gitconfig .psqlrc; do \
		if [[ -L $(HOME)/$$file ]]; then \
			echo -e "  $(GREEN)✅ $$file → $$(readlink $(HOME)/$$file)$(RESET)"; \
		else \
			echo -e "  $(RED)❌ $$file (missing)$(RESET)"; \
		fi; \
	done
	@echo
	@if command -v zsh >/dev/null 2>&1; then \
		echo "Async Jobs:"; \
		zsh -c "source $(DOTFILES_HOME)/zshrc && dotfiles_async_status" 2>/dev/null || echo "  No async jobs"; \
	fi

.PHONY: version
version: ## Show current version
	$(call color_echo,$(WHITE),Current version: $(CURRENT_VERSION))

.PHONY: bump-patch
bump-patch: ## Bump patch version (x.y.Z)
	$(call color_echo,$(BLUE),🔢 Bumping patch version...)
	@$(MAKE) _bump-version TYPE=patch

.PHONY: bump-minor
bump-minor: ## Bump minor version (x.Y.z)
	$(call color_echo,$(BLUE),🔢 Bumping minor version...)
	@$(MAKE) _bump-version TYPE=minor

.PHONY: bump-major
bump-major: ## Bump major version (X.y.z)
	$(call color_echo,$(BLUE),🔢 Bumping major version...)
	@$(MAKE) _bump-version TYPE=major

.PHONY: _bump-version
_bump-version:
	@current=$$(cat $(VERSION_FILE)); \
	IFS='.' read -ra VERSION_PARTS <<< "$$current"; \
	major=$${VERSION_PARTS[0]}; \
	minor=$${VERSION_PARTS[1]}; \
	patch=$${VERSION_PARTS[2]}; \
	case "$(TYPE)" in \
		major) new_version="$$((major + 1)).0.0" ;; \
		minor) new_version="$$major.$$((minor + 1)).0" ;; \
		patch) new_version="$$major.$$minor.$$((patch + 1))" ;; \
		*) echo "Invalid version type"; exit 1 ;; \
	esac; \
	echo "$$new_version" > $(VERSION_FILE); \
	git add $(VERSION_FILE); \
	git commit -m "Bump version to $$new_version"; \
	git tag -a "v$$new_version" -m "Version $$new_version"; \
	echo -e "$(GREEN)✅ Version bumped from $$current to $$new_version$(RESET)"

.PHONY: tag
tag: ## Create a git tag for the current version
	$(call color_echo,$(BLUE),🏷️  Creating git tag...)
	@version=$(CURRENT_VERSION); \
	git tag -a "v$$version" -m "Version $$version"; \
	echo -e "$(GREEN)✅ Tagged version v$$version$(RESET)"

.PHONY: release
release: ## Tag current version and push to origin
	$(call color_echo,$(BLUE),🚀 Creating release...)
	@version=$(CURRENT_VERSION); \
	git tag -a "v$$version" -m "Version $$version"; \
	git push origin master; \
	git push origin "v$$version"; \
	echo -e "$(GREEN)✅ Released version v$$version$(RESET)"

.PHONY: test
test: ## Run basic tests and validation
	$(call color_echo,$(BLUE),🧪 Running tests...)
	@echo "Checking zsh syntax..."
	@if command -v zsh >/dev/null 2>&1; then \
		for file in zshrc zshrc.lib/*.zsh zshrc.d/*.zsh; do \
			if [[ -f $$file ]]; then \
				echo "  Checking $$file..."; \
				zsh -n $$file || exit 1; \
			fi; \
		done; \
	else \
		echo "  Zsh not available, skipping syntax check"; \
	fi
	@echo "Checking symlink targets..."
	@for file in .zshrc .vimrc .gitconfig .psqlrc; do \
		if [[ -L $(HOME)/$$file ]]; then \
			target=$$(readlink $(HOME)/$$file); \
			if [[ ! -e $$target ]]; then \
				echo -e "  $(RED)❌ Broken symlink: $$file → $$target$(RESET)"; \
				exit 1; \
			else \
				echo -e "  $(GREEN)✅ $$file$(RESET)"; \
			fi; \
		fi; \
	done
	$(call color_echo,$(GREEN),✅ All tests passed!)

.PHONY: doctor
doctor: ## Run comprehensive health check
	$(call color_echo,$(BLUE),🩺 Running health check...)
	@echo
	@$(MAKE) test
	@echo
	@$(MAKE) status
	@echo
	@if command -v zsh >/dev/null 2>&1; then \
		echo "Environment Check:"; \
		zsh -c "source $(DOTFILES_HOME)/zshrc && devenv" 2>/dev/null || echo "  Environment check not available"; \
	fi

.PHONY: dev
dev: ## Development mode: install + clean cache for testing
	$(call color_echo,$(PURPLE),🔧 Setting up development mode...)
	@$(MAKE) install
	@$(MAKE) clean
	$(call color_echo,$(GREEN),✅ Development mode ready!)

# Backup and restore functionality
.PHONY: backup
backup: ## Create a backup of current dotfiles
	$(call color_echo,$(BLUE),💾 Creating backup...)
	@backup_dir="$(HOME)/.dotfiles-backup-$$(date +%Y%m%d-%H%M%S)"; \
	mkdir -p "$$backup_dir"; \
	for file in .zshrc .vimrc .gitconfig .psqlrc .vim; do \
		if [[ -e $(HOME)/$$file ]]; then \
			cp -r $(HOME)/$$file "$$backup_dir/"; \
		fi; \
	done; \
	echo -e "$(GREEN)✅ Backup created at $$backup_dir$(RESET)"

# Development helpers
.PHONY: reload
reload: ## Reload zsh configuration (for development)
	$(call color_echo,$(CYAN),🔄 Reloading zsh configuration...)
	@if command -v zsh >/dev/null 2>&1; then \
		zsh -c "source $(DOTFILES_HOME)/zshrc && resource"; \
	else \
		echo "Zsh not available"; \
	fi

.PHONY: debug
debug: ## Reload with debugging enabled
	$(call color_echo,$(CYAN),🔍 Reloading with debugging...)
	@if command -v zsh >/dev/null 2>&1; then \
		zsh -c "source $(DOTFILES_HOME)/zshrc && resource_with_debugging"; \
	else \
		echo "Zsh not available"; \
	fi

# Make sure we don't accidentally run targets that match file names
.SUFFIXES:
