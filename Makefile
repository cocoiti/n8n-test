# n8n Claude Code Development Kit Makefile
# ワークフローアップロード機能と開発支援コマンド

# デフォルト設定
DEFAULT_ENV := dev
ENV ?= $(DEFAULT_ENV)
WORKFLOW_DIR := workflows
CONFIG_DIR := config
BACKUP_DIR := backups
LOG_DIR := logs
SCRIPTS_DIR := scripts
TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

# 環境変数の読み込み
ifneq (,$(wildcard $(CONFIG_DIR)/$(ENV).env))
    include $(CONFIG_DIR)/$(ENV).env
    export
endif

# デフォルトターゲット
.PHONY: help
help: ## ヘルプメッセージを表示
	@echo "n8n Claude Code Development Kit"
	@echo ""
	@echo "利用可能なコマンド:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

# セットアップコマンド
.PHONY: init-config
init-config: ## 設定ファイルを作成（テンプレートからコピー）
	@echo "Creating configuration files from templates..."
	@mkdir -p $(CONFIG_DIR)
	@if [ ! -f $(CONFIG_DIR)/dev.env ]; then \
		if [ -f $(CONFIG_DIR)/dev.env.example ]; then \
			cp $(CONFIG_DIR)/dev.env.example $(CONFIG_DIR)/dev.env; \
			echo "✓ Created $(CONFIG_DIR)/dev.env from template"; \
			echo "⚠️  Please edit $(CONFIG_DIR)/dev.env with your actual configuration"; \
		else \
			echo "✗ Template file $(CONFIG_DIR)/dev.env.example not found"; \
		fi \
	else \
		echo "✓ $(CONFIG_DIR)/dev.env already exists"; \
	fi
	@if [ ! -f $(CONFIG_DIR)/prod.env ]; then \
		if [ -f $(CONFIG_DIR)/prod.env.example ]; then \
			cp $(CONFIG_DIR)/prod.env.example $(CONFIG_DIR)/prod.env; \
			echo "✓ Created $(CONFIG_DIR)/prod.env from template"; \
			echo "⚠️  Please edit $(CONFIG_DIR)/prod.env with your actual configuration"; \
		else \
			echo "✗ Template file $(CONFIG_DIR)/prod.env.example not found"; \
		fi \
	else \
		echo "✓ $(CONFIG_DIR)/prod.env already exists"; \
	fi
	@echo ""
	@echo "🔒 SECURITY NOTICE:"
	@echo "   - Config files are gitignored and won't be committed"
	@echo "   - Edit the created files with your actual credentials"
	@echo "   - Never commit files containing real passwords or API keys"

# 環境チェック
.PHONY: check-env
check-env: ## 環境設定をチェック
	@echo "Checking environment setup..."
	@command -v n8n >/dev/null 2>&1 || { echo "Error: n8n is not installed"; exit 1; }
	@command -v claude >/dev/null 2>&1 || { echo "Warning: Claude Code CLI is not installed"; }
	@command -v curl >/dev/null 2>&1 || { echo "Error: curl is not installed"; exit 1; }
	@command -v jq >/dev/null 2>&1 || { echo "Error: jq is not installed"; exit 1; }
	@echo "Environment check completed!"

.PHONY: test-connection
test-connection: ## n8nインスタンスへの接続をテスト
	@echo "Testing connection to n8n instance..."
	@echo "Environment: $(ENV)"
	@if [ -f "$(CONFIG_DIR)/$(ENV).env" ]; then \
		echo "✓ Configuration file found: $(CONFIG_DIR)/$(ENV).env"; \
		source $(CONFIG_DIR)/$(ENV).env; \
		echo "✓ Testing API connection to: $$N8N_BASE_URL/api/v1"; \
		if [ ! -z "$$N8N_API_KEY" ]; then \
			echo "✓ API Key found, testing API access..."; \
			if curl -f -s -H "X-N8N-API-KEY: $$N8N_API_KEY" "$$N8N_BASE_URL/api/v1/workflows" | jq empty >/dev/null 2>&1; then \
				echo "✅ API Authentication: OK"; \
				WORKFLOW_COUNT=$$(curl -s -H "X-N8N-API-KEY: $$N8N_API_KEY" "$$N8N_BASE_URL/api/v1/workflows" | jq '.data | length' 2>/dev/null || echo "0"); \
				echo "✓ Workflows found: $$WORKFLOW_COUNT"; \
			else \
				echo "❌ API Authentication: Failed"; \
				echo "   Check your N8N_API_KEY in $(CONFIG_DIR)/$(ENV).env"; \
			fi; \
		else \
			echo "⚠️  No API Key configured"; \
			echo "   Set N8N_API_KEY in $(CONFIG_DIR)/$(ENV).env for API access"; \
		fi; \
	else \
		echo "❌ Configuration file not found: $(CONFIG_DIR)/$(ENV).env"; \
		echo "   Run 'make init-config' to create configuration files"; \
		exit 1; \
	fi

# n8n関連コマンド
.PHONY: n8n-start
n8n-start: ## n8nを起動
	@echo "Starting n8n..."
	n8n start

.PHONY: n8n-dev
n8n-dev: ## n8nを開発モードで起動
	@echo "Starting n8n in development mode..."
	n8n start --log-level debug

# ワークフロー管理コマンド
.PHONY: list-workflows
list-workflows: ## n8n上のワークフロー一覧を表示
	@echo "Listing workflows on n8n instance..."
	@curl -s http://localhost:5678/rest/workflows | jq '.data[].name' || echo "Error: Cannot connect to n8n instance"

.PHONY: validate
validate: ## ワークフローJSONを検証 (make validate WORKFLOW=workflow-name/development/workflow.json)
	@if [ -z "$(WORKFLOW)" ]; then \
		echo "Error: WORKFLOW parameter is required"; \
		echo "Usage: make validate WORKFLOW=workflow-name/development/workflow.json"; \
		exit 1; \
	fi
	@echo "Validating workflow: $(WORKFLOW)"
	@if [ ! -f "$(WORKFLOW_DIR)/$(WORKFLOW)" ]; then \
		echo "✗ File not found: $(WORKFLOW_DIR)/$(WORKFLOW)"; \
		exit 1; \
	fi
	@jq empty "$(WORKFLOW_DIR)/$(WORKFLOW)" && echo "✓ Valid JSON" || echo "✗ Invalid JSON"

# バックアップコマンド
.PHONY: backup
backup: ## 既存ワークフローをバックアップ
	@echo "Creating backup..."
	@mkdir -p $(BACKUP_DIR)/$(TIMESTAMP)
	@if curl -s http://localhost:5678/rest/workflows >/dev/null 2>&1; then \
		curl -s http://localhost:5678/rest/workflows | jq '.data[]' > $(BACKUP_DIR)/$(TIMESTAMP)/workflows_backup.json; \
		echo "✓ Backup created: $(BACKUP_DIR)/$(TIMESTAMP)/workflows_backup.json"; \
	else \
		echo "✗ Error: Cannot connect to n8n instance at http://localhost:5678"; \
		rmdir $(BACKUP_DIR)/$(TIMESTAMP) 2>/dev/null || true; \
		exit 1; \
	fi

# クリーンアップコマンド
.PHONY: clean
clean: ## 一時ファイルとログを削除
	@echo "Cleaning up temporary files..."
	@rm -f $(LOG_DIR)/*.log
	@rm -f *.tmp
	@echo "Cleanup completed!"

# 開発支援コマンド
.PHONY: generate-spec
generate-spec: ## 仕様書テンプレートを生成 (Claude Commandを推奨)
	@echo "⚠️  この機能はClaude Commandに移行されました"
	@echo "docs/claude-commands.md の「ワークフロー仕様書作成」を使用してください"
	@echo ""
	@echo "Claude Commandの利点:"
	@echo "- 要件定義、設計、実装の3段階を自動生成"
	@echo "- 内容に応じた適切なIDとファイル名の自動設定"
	@echo "- より詳細で実用的な仕様書の作成"

.PHONY: test
test: ## テストを実行
	@echo "Running tests..."
	@echo "Test framework not yet implemented. Please check tests/README.md for setup instructions."

# Claude Code連携コマンド
.PHONY: claude-version
claude-version: ## Claude Codeのバージョンを確認
	@claude --version || echo "Claude Code CLI is not installed"

.PHONY: status
status: ## プロジェクトの状態を表示
	@echo "=== n8n Claude Code Development Kit Status ==="
	@echo "Project Directory: $(PWD)"
	@echo "Environment: $(ENV)"
	@echo ""
	@echo "=== Directory Structure ==="
	@find . -type d -name ".git" -prune -o -type d -print | head -20
	@echo ""
	@echo "=== Recent Files ==="
	@find . -name "*.json" -o -name "*.md" | grep -v ".git" | head -10
	@echo ""
	@make --no-print-directory check-env

# ワークフローアップロード機能
.PHONY: upload
upload: ## ワークフローをアップロード (make upload WORKFLOW=filename.json ENV=dev)
	@if [ -z "$(WORKFLOW)" ]; then \
		echo "Error: WORKFLOW parameter is required"; \
		echo "Usage: make upload WORKFLOW=filename.json [ENV=dev]"; \
		exit 1; \
	fi
	@if [ ! -f "$(WORKFLOW_DIR)/$(WORKFLOW)" ]; then \
		echo "✗ File not found: $(WORKFLOW_DIR)/$(WORKFLOW)"; \
		exit 1; \
	fi
	@echo "Uploading workflow..."
	@echo "File: $(WORKFLOW_DIR)/$(WORKFLOW)"
	@if [ "$(ENV)" = "development" ]; then \
		CONFIG_FILE="$(CONFIG_DIR)/dev.env"; \
	else \
		CONFIG_FILE="$(CONFIG_DIR)/$(ENV).env"; \
	fi; \
	if [ -f "$$CONFIG_FILE" ]; then \
		source $$CONFIG_FILE; \
		echo "Target: $$N8N_BASE_URL"; \
		if curl -f -s -X POST \
			-H "X-N8N-API-KEY: $$N8N_API_KEY" \
			-H "Content-Type: application/json" \
			-d @"$(WORKFLOW_DIR)/$(WORKFLOW)" \
			"$$N8N_BASE_URL/api/v1/workflows" >/dev/null 2>&1; then \
			echo "✅ Upload successful!"; \
			echo "Check your n8n instance to see the imported workflow"; \
		else \
			echo "❌ Upload failed"; \
			echo "Attempting detailed error response:"; \
			curl -X POST \
				-H "X-N8N-API-KEY: $$N8N_API_KEY" \
				-H "Content-Type: application/json" \
				-d @"$(WORKFLOW_DIR)/$(WORKFLOW)" \
				"$$N8N_BASE_URL/api/v1/workflows" 2>/dev/null | jq . || echo "Could not parse error response"; \
			echo ""; \
			echo "💡 Alternative: Manual import via n8n GUI"; \
			echo "   1. Open $$N8N_BASE_URL"; \
			echo "   2. New Workflow → Import from File"; \
			echo "   3. Select: $(WORKFLOW_DIR)/$(WORKFLOW)"; \
		fi; \
	else \
		echo "❌ Configuration file not found: $$CONFIG_FILE"; \
		echo "   Run 'make init-config' to create configuration files"; \
	fi

.PHONY: upload-dev
upload-dev: ## 開発環境にアップロード (make upload-dev WORKFLOW=workflow-name/development/workflow.json)
	@$(MAKE) upload WORKFLOW=$(WORKFLOW) ENV=development

.PHONY: upload-prod  
upload-prod: ## 本番環境にアップロード (make upload-prod WORKFLOW=workflow-name/production/workflow.json)
	@$(MAKE) upload WORKFLOW=$(WORKFLOW) ENV=prod