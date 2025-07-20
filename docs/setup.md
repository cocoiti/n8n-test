# セットアップ手順書

n8n Claude Code Development Kitを使用するための詳細なセットアップ手順です。

## 目次

1. [前提条件](#前提条件)
2. [n8nのインストール](#n8nのインストール)
3. [Claude Codeの設定](#claude-codeの設定)
4. [プロジェクト初期化](#プロジェクト初期化)
5. [動作確認](#動作確認)
6. [トラブルシューティング](#トラブルシューティング)

## 前提条件

### システム要件
- **OS**: Windows 10+, macOS 10.15+, Linux (Ubuntu 18.04+)
- **Node.js**: v18.0.0以上
- **npm**: v9.0.0以上
- **RAM**: 最低4GB（推奨8GB以上）
- **ストレージ**: 最低2GB

### 必要なアカウント
- **Claude Code アカウント**: ワークフロー自動生成のため
- **n8n.cloud アカウント**: クラウド版使用の場合（任意）
- **連携サービスアカウント**: 実際に連携するサービス（Slack、GitHub等）

## Node.jsのインストール（n8n用）

n8nはNode.js上で動作するため、Node.jsをインストールする必要があります。

### macOS (Homebrew使用)
```bash
# Homebrewのインストール（未インストールの場合）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Node.jsのインストール
brew install node@18
```

### Windows (Node.js公式サイト)
1. [Node.js公式サイト](https://nodejs.org/)からLTS版をダウンロード
2. インストーラーを実行してセットアップ

### Linux (Ubuntu/Debian)
```bash
# NodeSourceリポジトリの追加
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Node.jsのインストール
sudo apt-get install -y nodejs
```

## n8nのインストール

### 1. グローバルインストール
```bash
# n8nのグローバルインストール
npm install -g n8n

# インストール確認
n8n --version
```

### 2. ローカル環境での実行
```bash
# n8nの起動
n8n start

# または開発モード
n8n start --log-level debug
```

### 3. 初期設定
1. ブラウザで `http://localhost:5678` にアクセス
2. 初期ユーザーアカウントの作成
3. 基本設定の完了

### 4. 基本的な使い方
- **ワークフロー作成**: GUIでノードをドラッグ&ドロップ
- **ワークフロー保存**: JSONファイルとしてエクスポート可能
- **実行とテスト**: 手動実行またはトリガーベース実行

## Claude Codeの設定

### 1. Claude Codeのインストール
```bash
# Claude Code CLIのインストール
# 公式サイトからダウンロード: https://claude.ai/code
# または以下のコマンドでインストール（利用可能な場合）
curl -sSL https://install.claude.ai/code | bash

# インストール確認
claude --version
```

### 2. 認証設定
```bash
# Claude Codeにログイン
claude auth login

# APIキーの設定（環境変数）
export CLAUDE_API_KEY="your-api-key-here"
echo 'export CLAUDE_API_KEY="your-api-key-here"' >> ~/.bashrc
```

### 3. プロジェクト固有の設定
```bash
# プロジェクトディレクトリでの初期化
cd ~/n8n-claude-kit

# Claude Codeプロジェクトとして初期化（任意）
claude init
```

## プロジェクト初期化

### 1. プロジェクト構造の作成
```bash
# プロジェクトディレクトリの作成
mkdir -p n8n-claude-kit
cd n8n-claude-kit

# ワークフロー管理用ディレクトリの作成
mkdir -p {\
  workflows/{production,development,templates,tests},\
  workflows/specifications/{requirements,designs,implementations},\
  docs,\
  scripts\
}
```

### 2. 基本ファイルの作成
```bash
# .gitignore の作成
cat > .gitignore << EOF
# n8n
.n8n/
*.db
*.sqlite

# Environment
.env
.env.local

# Logs
logs/
*.log

# OS
.DS_Store
Thumbs.db
EOF

# README.md の作成
cat > README.md << EOF
# n8n Claude Code Kit

n8nワークフローをClaude Codeで効率的に開発するプロジェクトです。

## セットアップ
1. n8n起動: \`n8n start\`
2. ブラウザでアクセス: http://localhost:5678
3. Claude Codeでワークフロー作成

## ワークフロー開発
- 仕様書: \`workflows/specifications/\`
- 本番環境: \`workflows/production/\`
- 開発環境: \`workflows/development/\`
EOF
```

### 3. n8n環境設定（任意）
```bash
# .env.example の作成（必要に応じて）
cat > .env.example << EOF
# n8n Configuration
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http

# Basic Auth (本番環境では必須)
N8N_BASIC_AUTH_ACTIVE=false
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your-secure-password

# Database (デフォルトはSQLite)
DB_TYPE=sqlite

# Webhook URL
WEBHOOK_URL=http://localhost:5678/webhook
EOF
```

## 動作確認

### 1. n8nの起動確認
```bash
# n8nを起動
n8n start

# 別ターミナルで動作確認（任意）
curl http://localhost:5678/rest/active-workflows
```

### 2. Claude Codeの動作確認
```bash
# Claude Codeの基本動作確認
claude "Hello, n8n development setup is complete"

# n8nワークフロー作成テスト
claude "Create a simple n8n workflow that logs 'Hello World'"
```

### 3. 統合テスト
```bash
# Claude Codeでテストワークフローを作成
claude "Create a simple n8n workflow that receives a webhook and logs the data"

# 生成されたJSONをn8n GUIでインポート
# 1. http://localhost:5678 にアクセス
# 2. 「Import from URL/File」でJSONを読み込み
# 3. ワークフローを保存・実行
```

## トラブルシューティング

### よくある問題と解決策

#### 1. n8nが起動しない
```bash
# ポート競合の確認
lsof -i :5678

# 別ポートでの起動
N8N_PORT=5679 n8n start
```

#### 2. Claude Code認証エラー
```bash
# 認証情報の再設定
claude auth logout
claude auth login

# 環境変数の確認
echo $CLAUDE_API_KEY
```

#### 3. Node.jsバージョン問題
```bash
# Node.jsバージョンの確認
node --version

# nvmを使用したバージョン管理
nvm install 18
nvm use 18
```

#### 4. 権限エラー
```bash
# npmの権限修正
sudo chown -R $(whoami) ~/.npm

# グローバルインストールの権限修正
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
```

### パフォーマンス最適化

#### 1. メモリ使用量の最適化
```bash
# Node.jsのメモリ制限設定
export NODE_OPTIONS="--max-old-space-size=4096"
```

#### 2. ログレベルの調整
```bash
# 本番環境でのログレベル
N8N_LOG_LEVEL=info n8n start
```

### セキュリティ設定

#### 1. 基本認証の有効化
```bash
# .env ファイルの設定
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=your-username
N8N_BASIC_AUTH_PASSWORD=your-secure-password
```

#### 2. HTTPS設定（本番環境）
```bash
# SSL証明書の設定
N8N_PROTOCOL=https
N8N_SSL_KEY=/path/to/private-key.pem
N8N_SSL_CERT=/path/to/certificate.pem
```

## 次のステップ

1. [n8nワークフロー開発ガイド](./n8n-workflow-guide.md)を参照して基本的なワークフローを作成
2. [Claude Codeコマンドテンプレート](./claude-commands.md)を使用して効率的な開発を実践
3. 実際のユースケースに基づいたワークフローの構築

## サポートとコミュニティ

- **n8n公式フォーラム**: https://community.n8n.io/
- **Claude Code ドキュメント**: https://docs.anthropic.com/claude/docs
- **GitHub Issues**: このプロジェクトのIssuesページ