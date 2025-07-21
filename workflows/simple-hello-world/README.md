# Simple Hello World Workflow

n8n入門者向けの基本的な学習用ワークフローです。

## 概要

- **目的**: n8nの基本操作を学習
- **トリガー**: Manual Trigger（手動実行）
- **処理**: JavaScriptでのデータ生成とログ出力
- **外部依存**: なし

## ファイル構成

```
simple-hello-world/
├── README.md                    # このファイル
├── specifications/             # 仕様書
│   ├── requirements.md         # 要件定義書
│   ├── design.md              # 設計書
│   └── implementation.md       # 実装仕様書
├── development/               # 開発環境用
│   ├── workflow.json          # 標準版ワークフロー
│   └── workflow-minimal.json  # 最小版ワークフロー
├── production/               # 本番環境用（未実装）
└── tests/                   # テストファイル（未実装）
```

## 使用方法

### 開発環境でテスト
```bash
# 標準版をアップロード
make upload-dev WORKFLOW=simple-hello-world/development/workflow.json

# 最小版をアップロード
make upload-dev WORKFLOW=simple-hello-world/development/workflow-minimal.json
```

### 実行方法
1. n8n GUI (http://localhost:5678) にアクセス
2. アップロードされたワークフローを開く
3. "Execute Workflow" ボタンをクリック
4. ブラウザの開発者ツール（Console）でログを確認

## 学習ポイント

- Manual Triggerノードの使用方法
- Function Nodeでの JavaScript 実行
- console.log によるデバッグ出力
- ノード間のデータ受け渡し
- n8n のワークフロー基本構造

## 仕様書

詳細な仕様については `specifications/` ディレクトリの各ドキュメントを参照してください：

- [要件定義書](./specifications/requirements.md)
- [設計書](./specifications/design.md)
- [実装仕様書](./specifications/implementation.md)