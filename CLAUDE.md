# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

これは**n8n Claude Code Development Kit**です - Claude Codeを使用してn8nワークフローを効率的に作成、管理、デプロイするための開発フレームワークです。構造化された仕様管理、自動ワークフローアップロード、標準化された開発プラクティスを重視しています。

## 主要コマンド

### セットアップと設定
```bash
make init-config          # テンプレートから設定ファイルを作成
make check-env            # 環境設定を確認（n8n、claude、curl、jq）
make test-connection       # n8n API接続と認証をテスト
```

### ワークフロー開発
```bash
make upload-dev WORKFLOW=filename.json     # 開発環境にワークフローをアップロード
make upload-prod WORKFLOW=filename.json    # 本番環境にワークフローをアップロード
make validate WORKFLOW=filename.json       # ワークフローJSONの構造を検証
make list-workflows                         # n8nインスタンス上のワークフロー一覧を表示
```

### 仕様管理
```bash
make generate-spec WORKFLOW=name SPEC_ID=001   # 仕様書テンプレートを生成
```

### メンテナンス
```bash
make backup               # n8nから既存ワークフローをバックアップ
make status              # プロジェクトの状態と最近のファイルを表示
make clean               # 一時ファイルとログを削除
make claude-version      # Claude Codeのバージョンを確認
make test                # テストを実行
```

## アーキテクチャ

### 仕様駆動開発
プロジェクトは3つの仕様フェーズを持つ構造化されたアプローチに従います：
- **要件定義** (`workflows/specifications/requirements/REQ-XXX_name.md`)
- **設計** (`workflows/specifications/designs/DES-XXX_name.md`) 
- **実装** (`workflows/specifications/implementations/IMP-XXX_name.md`)

### 環境管理
- 設定ファイル: `config/{env}.env` (dev.env, prod.env)
- 環境テンプレート: `config/{env}.env.example`
- Makefileでの環境変数の自動読み込み

### n8n API統合
- **APIバージョン**: n8n v1 API (`/api/v1/workflows`) を使用
- **認証**: `X-N8N-API-KEY` ヘッダーベース
- **対応n8nバージョン**: 1.102.4以上

## 重要な設定

### 必須環境変数 (config/dev.env)
```bash
N8N_BASE_URL=http://localhost:5678
N8N_API_KEY=your_api_key_here
```

### ワークフローJSON要件
n8n 1.x ワークフローには以下が必要：
- `settings: {}` プロパティ（必須）
- `active` プロパティは除外（読み取り専用）
- 適切なノード接続構造を使用
- 各ノードに一意の`id`を設定

### ディレクトリ構造
```
workflows/
├── development/          # 開発ワークフロー（.json）
├── production/          # 本番ワークフロー（.json）
├── specifications/      # 構造化された仕様書
└── templates/           # 再利用可能なワークフローテンプレート
```

## 開発ワークフロー

1. **環境セットアップ**: `make init-config` で設定ファイルを作成し、APIキーを設定
2. **接続確認**: `make test-connection` でn8n APIの接続と認証を確認
3. **仕様書作成**: `make generate-spec WORKFLOW=name SPEC_ID=001` を使用して構造化されたドキュメントを作成
4. **ワークフロー実装**: `workflows/development/` にワークフローJSONを作成
5. **検証**: `make validate WORKFLOW=filename.json` でJSON構造をチェック
6. **アップロードテスト**: `make upload-dev WORKFLOW=filename.json` を使用
7. **デプロイ**: 本番デプロイには `make upload-prod WORKFLOW=filename.json` を使用

## 重要な注意事項

- **APIキー権限**: `workflow:create` と `workflow:write` スコープが必要
- **設定セキュリティ**: 実際の設定ファイル（*.env）はgitignoreされています
- **ワークフロー構造**: アップロード成功にはn8n 1.x API要件に従ってください
- **環境分離**: 開発と本番のワークフローディレクトリは分離されています
- **バックアップ**: 本番デプロイ前には `make backup` でバックアップを作成
- **API互換性**: n8n 1.102.4以上が必要、古いバージョンでは `/rest/workflows` エンドポイントを使用