# n8n Claude Code Development Kit

n8nワークフローをClaude Codeで効率的に開発するためのテストプロジェクトおよび汎用的なコマンドテンプレート集です。

## 概要

このプロジェクトは以下の目的で作成されています：

- **n8nワークフロー開発の効率化**: Claude Codeを活用したn8nワークフローの開発、テスト、デバッグ
- **コマンドテンプレートの提供**: 汎用的に使えるClaude Codeコマンドテンプレートの集約
- **仕様管理システム**: ワークフロー要件から実装まで一元管理
- **ベストプラクティスの共有**: n8n開発における効率的な手法とパターンの文書化

## 特徴

- 🤖 Claude Codeによる自動化されたワークフロー開発
- 📝 再利用可能なコマンドテンプレート
- 📋 構造化されたワークフロー仕様管理
- 🚀 Makefileベースの自動アップロード機能
- 🧪 テスト駆動開発のサポート
- 📚 包括的なドキュメントとガイド

## プロジェクト構成

```
n8n-claude-kit/
├── docs/                    # ドキュメント
│   ├── README.md           # プロジェクト概要
│   ├── n8n-workflow-guide.md   # n8nワークフロー開発ガイド
│   ├── claude-commands.md      # Claude Codeコマンドテンプレート
│   ├── setup.md              # セットアップ手順
│   ├── workflow-specifications.md  # ワークフロー仕様書作成ガイド
│   └── workflow-upload.md    # ワークフローアップロード機能
├── workflows/              # n8nワークフローファイル
│   ├── production/         # 本番環境用
│   ├── development/        # 開発環境用
│   ├── templates/          # 再利用可能なテンプレート
│   ├── tests/             # テスト用ワークフロー
│   └── specifications/    # ワークフロー仕様書
│       ├── requirements/   # 要件定義書
│       ├── designs/       # 設計書
│       └── implementations/ # 実装仕様書
├── templates/              # コマンドテンプレート
│   └── specifications/    # 仕様書テンプレート
├── tests/                  # テストファイル
├── scripts/                # ユーティリティスクリプト
├── config/                 # 環境設定ファイル
├── backups/               # ワークフローバックアップ
├── logs/                  # 実行ログ
└── Makefile               # アップロード自動化
```

## クイックスタート

1. **前提条件の確認**
   - Node.js v18.0.0以上
   - Claude Codeアカウント

2. **セットアップ**
   ```bash
   # n8nのインストール
   npm install -g n8n
   
   # Claude Codeのインストール
   # 公式サイト: https://claude.ai/code
   
   # プロジェクトのクローン
   git clone <this-repository>
   cd n8n-claude-kit
   ```

3. **n8nの起動**
   ```bash
   n8n start
   ```

4. **ブラウザでアクセス**
   http://localhost:5678

詳細なセットアップ手順については [docs/setup.md](./docs/setup.md) を参照してください。

## ドキュメント

- **[Claude Code開発ガイド (CLAUDE.md)](./CLAUDE.md)** ⭐ Claude Code使用時の必読ガイド
- [Claude Codeコマンドテンプレート](./docs/claude-commands.md) - 効率的な開発コマンド集
- [セットアップ手順](./docs/setup.md) - 初期環境構築手順
- [ワークフローアップロード機能](./docs/workflow-upload.md) - 自動デプロイ機能
- [ワークフロー仕様書作成ガイド](./docs/workflow-specifications.md) - 仕様書管理システム
- [n8nワークフロー開発ガイド](./docs/n8n-workflow-guide.md) - ワークフロー開発の詳細

## 開発フロー

### Claude Code使用時（推奨）
1. **プロジェクト初期化**: Claude Commandでプロジェクト構造を自動生成
2. **ワークフロー開発**: Claude Commandで仕様書から実装まで一貫して作成
3. **テスト**: `make upload-dev` で開発環境にデプロイしてテスト
4. **本番デプロイ**: `make upload-prod` で本番環境にデプロイ

### 手動開発時
1. **要件定義**: 仕様書テンプレートを使用
2. **設計**: ワークフロー設計書作成
3. **実装**: JSONワークフローファイル作成
4. **テスト**: `make validate` でJSON検証後、`make upload-dev` でテスト
5. **デプロイ**: `make upload-prod` で本番デプロイ

## 貢献

プロジェクトへの貢献を歓迎します：

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## ライセンス

MIT License

## サポート

- **Issues**: [GitHub Issues](../../issues)
- **n8n公式フォーラム**: https://community.n8n.io/
- **Claude Code ドキュメント**: https://docs.anthropic.com/claude/docs