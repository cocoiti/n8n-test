# Configuration Directory

環境別の設定ファイルを管理するディレクトリです。

## ⚠️ セキュリティ重要事項

### 🔒 機密情報の取り扱い
- **絶対にクレデンシャル情報をコミットしないでください**
- `.env`ファイルは`.gitignore`で除外済みです
- テンプレートファイル（`.example`）のみをコミット対象とします

### 📁 ファイル構成

```
config/
├── dev.env.example      # 開発環境設定テンプレート（コミット対象）
├── prod.env.example     # 本番環境設定テンプレート（コミット対象）
├── dev.env             # 開発環境実際の設定（gitignore対象）
└── prod.env            # 本番環境実際の設定（gitignore対象）
```

## 🚀 セットアップ手順

### 1. 設定ファイルの作成
```bash
# テンプレートから設定ファイルを作成
make init-config
```

### 2. 設定値の編集
```bash
# 開発環境設定の編集
vim config/dev.env

# 本番環境設定の編集
vim config/prod.env
```

### 3. 環境の指定
```bash
# 開発環境で実行
make some-command ENV=dev

# 本番環境で実行  
make some-command ENV=prod
```

## 📝 設定項目

### 必須設定
- `N8N_BASE_URL`: n8nインスタンスのURL
- `N8N_LOG_LEVEL`: ログレベル（debug/info/warn/error）

### 認証設定（本番環境推奨）
- `N8N_BASIC_AUTH_USER`: 基本認証ユーザー名
- `N8N_BASIC_AUTH_PASSWORD`: 基本認証パスワード
- `N8N_API_KEY`: API認証キー

### データベース設定（本番環境）
- `DB_TYPE`: データベース種類（sqlite/postgres/mysql）
- `DB_*`: データベース接続設定

## 🛡️ セキュリティベストプラクティス

### ✅ DO（推奨）
- テンプレートファイルから設定をコピー
- 強力なパスワードを使用
- 本番環境では必ず認証を有効化
- 定期的なパスワード変更

### ❌ DON'T（禁止）
- 設定ファイルをコミット
- パスワードをプレーンテキストで共有
- 開発環境と本番環境で同じ認証情報を使用
- 設定ファイルをメールやチャットで送信

## 🔍 設定確認コマンド

```bash
# 環境設定の確認
make check-env

# プロジェクト状態の確認
make status ENV=dev
```