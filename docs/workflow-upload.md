# ワークフローアップロード機能

Makefileを使用してn8nワークフローをAPI経由で効率的にアップロードするための機能です。

## 目次

1. [概要](#概要)
2. [前提条件](#前提条件)
3. [Makefile設計](#makefile設計)
4. [使用方法](#使用方法)
5. [設定ファイル](#設定ファイル)
6. [エラーハンドリング](#エラーハンドリング)
7. [Claude Codeとの連携](#claude-codeとの連携)

## 概要

### 目的
- ワークフローJSONファイルのn8nへの自動アップロード
- 開発環境と本番環境の切り替え対応
- バッチ処理による複数ワークフローの一括アップロード
- エラーハンドリングと実行結果の確認

### 機能
- **単体アップロード**: 指定したワークフローファイルをアップロード
- **バッチアップロード**: ディレクトリ内の全ワークフローを一括アップロード
- **環境別デプロイ**: development/production環境への切り替え
- **バックアップ**: アップロード前の既存ワークフローバックアップ
- **検証**: アップロード後の動作確認

## 前提条件

### システム要件
- **make**: GNU Make 3.81以上
- **curl**: HTTP APIリクエスト用
- **jq**: JSON処理用
- **n8n**: 起動済みのn8nインスタンス
- **Claude Code**: ワークフロー生成とアップロード連携用

### 実装状況
- ✅ **Makefile**: 基本コマンド実装済み
- ✅ **設定管理**: テンプレートベース設定システム
- ✅ **バックアップ**: 基本的なバックアップ機能
- 🚧 **アップロード機能**: 将来実装予定
- 🚧 **スクリプト**: scripts/ディレクトリは将来実装

### n8n API設定
- n8n REST APIが有効
- 適切な認証設定（Basic Auth等）
- APIエンドポイントへのアクセス権限

## Makefile設計

### コマンド構成
```makefile
# 基本コマンド
make upload WORKFLOW=filename.json     # 単体アップロード
make upload-all                        # 全ワークフローアップロード
make upload-dev                        # 開発環境アップロード
make upload-prod                       # 本番環境アップロード

# 管理コマンド
make list-workflows                     # n8n上のワークフロー一覧
make backup                             # 既存ワークフローバックアップ
make validate WORKFLOW=filename.json   # ワークフロー検証
make clean                              # 一時ファイル削除

# 開発支援
make generate-spec WORKFLOW=filename   # 仕様書生成
make test-workflow WORKFLOW=filename   # ワークフローテスト
```

### ディレクトリ構造
```
n8n-claude-kit/
├── Makefile                    # メインMakefile
├── config/                     # 環境設定ファイル
│   ├── dev.env.example        # 開発環境設定テンプレート
│   ├── prod.env.example       # 本番環境設定テンプレート
│   ├── dev.env                # 開発環境実際の設定（gitignore）
│   ├── prod.env               # 本番環境実際の設定（gitignore）
│   └── README.md              # 設定ガイド
├── workflows/                  # n8nワークフローファイル
│   ├── production/            # 本番環境用ワークフロー
│   ├── development/           # 開発環境用ワークフロー
│   ├── templates/             # 再利用可能なテンプレート
│   ├── tests/                # テスト用ワークフロー
│   └── specifications/       # ワークフロー仕様書
│       ├── requirements/      # 要件定義書
│       ├── designs/          # 設計書
│       └── implementations/   # 実装仕様書
├── templates/                 # コマンドテンプレート
│   └── specifications/       # 仕様書テンプレート
├── tests/                     # テストファイル
│   ├── unit/                 # ユニットテスト
│   ├── integration/          # 統合テスト
│   ├── e2e/                  # エンドツーエンドテスト
│   └── data/                 # テストデータ
├── scripts/                   # ユーティリティスクリプト（将来実装）
├── backups/                   # ワークフローバックアップ
├── logs/                      # 実行ログ
└── docs/                      # ドキュメント
```

## 使用方法

### 基本的な使用例

#### 1. 単体ワークフローアップロード
```bash
# 指定したワークフローをアップロード
make upload WORKFLOW=slack-notification.json

# 環境を指定してアップロード
make upload WORKFLOW=slack-notification.json ENV=dev
```

#### 2. バッチアップロード
```bash
# 開発環境の全ワークフローをアップロード
make upload-dev

# 本番環境の全ワークフローをアップロード
make upload-prod

# 指定ディレクトリの全ワークフローをアップロード
make upload-all DIR=workflows/templates
```

#### 3. バックアップとリストア
```bash
# 現在のワークフローをバックアップ
make backup

# 特定の日時のバックアップを作成
make backup TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# ワークフロー一覧表示
make list-workflows

# 削除されたワークフローの検出
make diff-workflows
```

### 高度な使用例

#### 1. 段階的デプロイ
```bash
# 開発環境でテスト
make upload-dev WORKFLOW=new-feature.json
make test-workflow WORKFLOW=new-feature.json ENV=dev

# 検証後に本番デプロイ
make validate WORKFLOW=new-feature.json
make upload-prod WORKFLOW=new-feature.json
```

#### 2. 環境間同期
```bash
# 開発環境から本番環境への同期
make sync-dev-to-prod

# 本番環境のワークフローを開発環境にコピー
make sync-prod-to-dev WORKFLOW=critical-workflow.json
```

#### 3. ロールバック
```bash
# 最新バックアップへのロールバック
make rollback

# 指定バックアップへのロールバック
make rollback BACKUP=backup_20240119_143000
```

## 設定ファイル

### 環境設定ファイル (config/dev.env)
```bash
# 開発環境設定
N8N_BASE_URL=http://localhost:5678
N8N_API_KEY=dev-api-key
N8N_USERNAME=dev-user
N8N_PASSWORD=dev-password
WORKFLOW_DIR=workflows/development
BACKUP_DIR=backups/dev
LOG_LEVEL=debug
```

### 環境設定ファイル (config/prod.env)
```bash
# 本番環境設定
N8N_BASE_URL=https://n8n.production.com
N8N_API_KEY=prod-api-key
N8N_USERNAME=prod-user
N8N_PASSWORD=prod-password
WORKFLOW_DIR=workflows/production
BACKUP_DIR=backups/prod
LOG_LEVEL=info
SSL_VERIFY=true
```

### API設定ファイル (config/api.conf)
```bash
# API共通設定
API_TIMEOUT=30
RETRY_COUNT=3
RETRY_DELAY=5
CONCURRENT_UPLOADS=5
VALIDATE_JSON=true
CREATE_BACKUP=true
LOG_REQUESTS=true
```

## エラーハンドリング

### エラーパターンと対処法

#### 1. API接続エラー
```bash
# 接続確認
make check-connection

# ヘルスチェック
make health-check

# 認証確認
make test-auth
```

#### 2. ワークフロー検証エラー
```bash
# JSON構文チェック
make validate-json WORKFLOW=filename.json

# n8n固有の検証
make validate-n8n WORKFLOW=filename.json

# 依存関係チェック
make check-dependencies WORKFLOW=filename.json
```

#### 3. アップロードエラー
```bash
# リトライ機能
make retry-upload WORKFLOW=filename.json

# 強制アップロード（既存を上書き）
make force-upload WORKFLOW=filename.json

# 部分的リカバリ
make partial-recovery
```

### ログとモニタリング

#### ログ出力例
```bash
[2024-01-19 14:30:00] INFO: Starting upload process
[2024-01-19 14:30:01] INFO: Loading environment: development
[2024-01-19 14:30:02] INFO: Validating workflow: slack-notification.json
[2024-01-19 14:30:03] INFO: Creating backup: backup_20240119_143003
[2024-01-19 14:30:04] INFO: Uploading workflow to http://localhost:5678
[2024-01-19 14:30:05] SUCCESS: Workflow uploaded successfully (ID: wf_123)
[2024-01-19 14:30:06] INFO: Upload process completed
```

#### 実行結果レポート
```bash
# 実行サマリー表示
make report

# 詳細ログ表示
make show-logs

# エラーログのみ表示
make show-errors
```

## Claude Codeとの連携

### ワークフロー生成からアップロードまでの自動化

#### 1. Claude Codeでの生成
```bash
# Claude Codeプロンプト例
claude "Create n8n workflow for Slack notification with error handling"

# 生成されたワークフローを保存
# workflows/development/slack-notification.json
```

#### 2. 自動アップロード
```bash
# Makefileでの自動処理
make claude-upload PROMPT="Create webhook to Slack workflow"

# または段階的処理
claude "Generate n8n workflow: webhook to email notification"
make upload WORKFLOW=email-notification.json
make test-workflow WORKFLOW=email-notification.json
```

### 統合コマンド例

#### 開発フロー自動化
```bash
# 1. Claude Codeで生成
# 2. 自動検証
# 3. 開発環境アップロード
# 4. テスト実行
make dev-flow SPEC="requirements/REQ-001_new-workflow.md"
```

#### 本番デプロイフロー
```bash
# 1. 開発環境での動作確認
# 2. 仕様書更新
# 3. 本番環境デプロイ
# 4. 動作確認
make prod-deploy WORKFLOW=verified-workflow.json
```

## ベストプラクティス

### 1. セキュリティ
- API認証情報の環境変数管理
- HTTPS通信の強制
- ログでの機密情報マスキング

### 2. 可用性
- アップロード前のバックアップ必須
- ロールバック機能の準備
- 段階的デプロイの実施

### 3. 効率性
- 並列アップロードの活用
- 差分アップロードの実装
- キャッシュ機能の利用

### 4. 保守性
- 明確なログ出力
- エラーメッセージの標準化
- ドキュメントの自動更新

## トラブルシューティング

### よくある問題

#### 1. 認証エラー
```bash
Error: 401 Unauthorized
Solution: 
- API認証情報の確認
- make test-auth で認証テスト
```

#### 2. JSON形式エラー
```bash
Error: Invalid JSON format
Solution:
- make validate-json で構文チェック
- jq . filename.json でフォーマット確認
```

#### 3. ワークフロー競合
```bash
Error: Workflow already exists
Solution:
- make force-upload で強制上書き
- make backup してからアップロード
```

## 参考リンク

- [n8n REST API Documentation](https://docs.n8n.io/api/)
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Claude Codeコマンドテンプレート](./claude-commands.md)
- [ワークフロー仕様書作成ガイド](./workflow-specifications.md)