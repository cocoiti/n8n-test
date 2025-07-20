# n8nワークフロー開発ガイド with Claude Code

Claude Codeを活用したn8nワークフロー開発の包括的なガイドです。

## 目次

1. [基本概念](#基本概念)
2. [開発環境の準備](#開発環境の準備)
3. [ワークフロー作成プロセス](#ワークフロー作成プロセス)
4. [Claude Codeでの自動化](#claude-codeでの自動化)
5. [テストとデバッグ](#テストとデバッグ)
6. [ベストプラクティス](#ベストプラクティス)

## 基本概念

### n8nとは
n8nは視覚的なワークフロー自動化ツールで、様々なサービスやアプリケーションを連携させることができます。

### Claude Codeの活用ポイント
- ワークフロー設計の自動生成
- JSONベースの設定ファイル作成
- エラーハンドリングの実装
- テストケースの生成

## 開発環境の準備

### 必要なツール
```bash
# n8nのインストール
npm install -g n8n

# JSON処理用ツール（アップロード機能で使用）
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```

### ディレクトリ構造
```
workflows/
├── production/         # 本番環境用ワークフロー
├── development/        # 開発環境用ワークフロー
├── templates/          # 再利用可能なテンプレート
└── tests/             # テスト用ワークフロー
```

## ワークフロー作成プロセス

### 1. 要件定義
Claude Codeに以下の情報を提供：
- 自動化したいプロセスの説明
- 入力と出力の形式
- エラーハンドリングの要件
- 実行頻度とトリガー

### 2. ワークフロー設計
```
プロンプト例：
「以下の要件でn8nワークフローを作成してください：
- Webhookで受信したデータをSlackに送信
- データ形式のバリデーション
- エラー時の通知機能」
```

### 3. JSON設定の生成
Claude Codeが以下を自動生成：
- ノード設定
- 接続情報
- パラメータ設定
- エラーハンドリング

## Claude Codeでの自動化

### ワークフロー生成コマンド
```bash
# 新しいワークフローを作成
claude "Create n8n workflow for [要件]"

# 既存ワークフローの修正
claude "Modify n8n workflow to add [新機能]"

# エラーハンドリングの追加
claude "Add error handling to n8n workflow"
```

### テンプレート活用
```javascript
// 共通のエラーハンドリングパターン
{
  "name": "Error Handler",
  "type": "n8n-nodes-base.function",
  "parameters": {
    "functionCode": "// Claude Code generated error handler\\nif (items[0].json.error) {\\n  throw new Error('Workflow failed: ' + items[0].json.error);\\n}\\nreturn items;"
  }
}
```

## テストとデバッグ

### テスト戦略
1. **単体テスト**: 個別ノードの動作確認
2. **統合テスト**: ワークフロー全体のテスト
3. **エラーケーステスト**: 異常系のテスト

### デバッグ手法
```bash
# ワークフローの実行ログ確認
n8n start --log-level debug

# 特定ノードのデバッグ
# Claude Codeでデバッグコードを生成
claude "Add debug logging to n8n node"
```

## ベストプラクティス

### 1. モジュール化
- 再利用可能なサブワークフローを作成
- 共通処理はテンプレート化

### 2. エラーハンドリング
- 全てのノードにエラーハンドリングを実装
- 適切なログ出力とアラート設定

### 3. セキュリティ
- 機密情報は環境変数で管理
- 適切な認証・認可の実装

### 4. パフォーマンス
- 不要な処理の削減
- 効率的なデータ変換

### 5. ドキュメント化
- ワークフローの目的と動作を文書化
- Claude Codeでドキュメント自動生成

## トラブルシューティング

### よくある問題と解決策

#### 1. データ形式エラー
```javascript
// Claude Code生成のデータバリデーション
function validateInput(data) {
  if (!data || typeof data !== 'object') {
    throw new Error('Invalid input data format');
  }
  return data;
}
```

#### 2. 接続エラー
- 認証情報の確認
- ネットワーク設定の確認
- レート制限の確認

#### 3. パフォーマンス問題
- バッチ処理の実装
- 並列実行の最適化

## 参考リンク

- [n8n公式ドキュメント](https://docs.n8n.io/)
- [Claude Code使用方法](./claude-commands.md)
- [セットアップ手順](./setup.md)