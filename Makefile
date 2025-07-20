# n8n Claude Code Development Kit Makefile
# ワークフローアップロード機能と開発支援コマンド

# デフォルト設定
DEFAULT_ENV := dev
WORKFLOW_DIR := workflows
CONFIG_DIR := config
BACKUP_DIR := backups
LOG_DIR := logs
SCRIPTS_DIR := scripts

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
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# セットアップコマンド
.PHONY: setup
setup: ## プロジェクトの初期セットアップ
	@echo "Setting up n8n Claude Code Development Kit..."
	@mkdir -p $(WORKFLOW_DIR)/{production,development,templates,tests}
	@mkdir -p $(WORKFLOW_DIR)/specifications/{requirements,designs,implementations}
	@mkdir -p $(CONFIG_DIR) $(BACKUP_DIR) $(LOG_DIR) $(SCRIPTS_DIR)
	@mkdir -p tests/{unit,integration,e2e,data,fixtures,scripts}
	@echo "Setup completed!"

# 環境チェック
.PHONY: check-env
check-env: ## 環境設定をチェック
	@echo "Checking environment setup..."
	@command -v n8n >/dev/null 2>&1 || { echo "Error: n8n is not installed"; exit 1; }
	@command -v claude >/dev/null 2>&1 || { echo "Warning: Claude Code CLI is not installed"; }
	@command -v curl >/dev/null 2>&1 || { echo "Error: curl is not installed"; exit 1; }
	@command -v jq >/dev/null 2>&1 || { echo "Error: jq is not installed"; exit 1; }
	@echo "Environment check completed!"

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
validate: ## ワークフローJSONを検証 (make validate WORKFLOW=filename.json)
	@if [ -z "$(WORKFLOW)" ]; then \
		echo "Error: WORKFLOW parameter is required"; \
		echo "Usage: make validate WORKFLOW=filename.json"; \
		exit 1; \
	fi
	@echo "Validating workflow: $(WORKFLOW)"
	@jq empty $(WORKFLOW_DIR)/$(ENV)/$(WORKFLOW) && echo "✓ Valid JSON" || echo "✗ Invalid JSON"

# バックアップコマンド
.PHONY: backup
backup: ## 既存ワークフローをバックアップ
	@echo "Creating backup..."
	@mkdir -p $(BACKUP_DIR)/$(shell date +%Y%m%d_%H%M%S)
	@curl -s http://localhost:5678/rest/workflows | jq '.data[]' > $(BACKUP_DIR)/$(shell date +%Y%m%d_%H%M%S)/workflows_backup.json
	@echo "Backup created in $(BACKUP_DIR)"

# クリーンアップコマンド
.PHONY: clean
clean: ## 一時ファイルとログを削除
	@echo "Cleaning up temporary files..."
	@rm -f $(LOG_DIR)/*.log
	@rm -f *.tmp
	@echo "Cleanup completed!"

# 開発支援コマンド
.PHONY: generate-spec
generate-spec: ## 仕様書テンプレートを生成 (make generate-spec WORKFLOW=name SPEC_ID=001)
	@if [ -z "$(WORKFLOW)" ] || [ -z "$(SPEC_ID)" ]; then \
		echo "Error: WORKFLOW and SPEC_ID parameters are required"; \
		echo "Usage: make generate-spec WORKFLOW=workflow_name SPEC_ID=001"; \
		exit 1; \
	fi
	@echo "Generating specification template for $(WORKFLOW)..."
	@sed "s/XXX/$(SPEC_ID)/g; s/\[ワークフロー名\]/$(WORKFLOW)/g" \
		templates/specifications/requirement-template.md > \
		$(WORKFLOW_DIR)/specifications/requirements/REQ-$(SPEC_ID)_$(WORKFLOW).md
	@echo "Specification template generated: REQ-$(SPEC_ID)_$(WORKFLOW).md"

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
	@echo "Environment: $(or $(ENV),$(DEFAULT_ENV))"
	@echo ""
	@echo "=== Directory Structure ==="
	@find . -type d -name ".git" -prune -o -type d -print | head -20
	@echo ""
	@echo "=== Recent Files ==="
	@find . -name "*.json" -o -name "*.md" | grep -v ".git" | head -10
	@echo ""
	@make --no-print-directory check-env

# 実装予定のアップロード機能（将来実装）
.PHONY: upload
upload: ## ワークフローをアップロード (実装予定)
	@echo "Upload functionality will be implemented in future versions"
	@echo "Please refer to docs/workflow-upload.md for detailed specifications"

.PHONY: upload-dev
upload-dev: ## 開発環境にアップロード (実装予定)
	@echo "Development upload functionality will be implemented in future versions"

.PHONY: upload-prod  
upload-prod: ## 本番環境にアップロード (実装予定)
	@echo "Production upload functionality will be implemented in future versions"