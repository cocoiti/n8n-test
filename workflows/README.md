# Workflows Directory

n8nワークフローファイルの管理ディレクトリです。

## ディレクトリ構成

- **production/**: 本番環境用ワークフロー
- **development/**: 開発環境用ワークフロー  
- **templates/**: 再利用可能なワークフローテンプレート
- **tests/**: テスト用ワークフロー
- **specifications/**: ワークフロー仕様書
  - **requirements/**: 要件定義書
  - **designs/**: 設計書
  - **implementations/**: 実装仕様書

## 命名規則

### ワークフローファイル
- 形式: `[目的]_[連番].json`
- 例: `slack_notification_001.json`

### 仕様書ファイル
- 要件定義書: `REQ-[連番]_[ワークフロー名].md`
- 設計書: `DES-[連番]_[ワークフロー名].md`
- 実装仕様書: `IMP-[連番]_[ワークフロー名].md`