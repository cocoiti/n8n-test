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

詳細なセットアップ手順については [setup.md](./setup.md) を参照してください。

## ドキュメント

- [n8nワークフロー開発ガイド](./n8n-workflow-guide.md)
- [Claude Codeコマンドテンプレート](./claude-commands.md)
- [ワークフロー仕様書作成ガイド](./workflow-specifications.md)
- [ワークフローアップロード機能](./workflow-upload.md)
- [セットアップ手順](./setup.md)

## ライセンス

MIT License