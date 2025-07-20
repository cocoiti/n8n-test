# 実装仕様書: [ワークフロー名]

## 基本情報
- **文書ID**: IMP-XXX
- **設計書ID**: DES-XXX
- **作成日**: YYYY-MM-DD
- **実装者**: [実装者名]
- **実装完了日**: YYYY-MM-DD

## 1. 実装概要
### 1.1 ワークフローファイル
- **ファイル名**: `[workflow-name].json`
- **保存場所**: `workflows/[environment]/`
- **バージョン**: [バージョン番号]

## 2. ノード実装詳細
### 2.1 [ノード名1]
```json
{
  "name": "ノード名",
  "type": "n8n-nodes-base.httpRequest",
  "parameters": {
    "url": "https://api.example.com/endpoint",
    "authentication": "predefinedCredentialType",
    "nodeCredentialType": "slackApi"
  }
}
```

#### 設定パラメータ
- **URL**: [エンドポイントの詳細]
- **認証**: [認証設定の詳細]
- **ヘッダー**: [必要なヘッダー]

### 2.2 [ノード名2]
[同様の形式で各ノードの実装詳細]

## 3. 環境固有設定
### 3.1 開発環境
```json
{
  "N8N_ENVIRONMENT": "development",
  "API_BASE_URL": "https://dev-api.example.com",
  "LOG_LEVEL": "debug"
}
```

### 3.2 本番環境
```json
{
  "N8N_ENVIRONMENT": "production",
  "API_BASE_URL": "https://api.example.com",
  "LOG_LEVEL": "info"
}
```

## 4. テスト結果
### 4.1 単体テスト
| テストケース | 結果 | 実行日 | 備考 |
|-------------|------|--------|------|
| [テスト1] | Pass | YYYY-MM-DD | [備考] |

### 4.2 統合テスト
| シナリオ | 結果 | 実行日 | 備考 |
|---------|------|--------|------|
| [シナリオ1] | Pass | YYYY-MM-DD | [備考] |

## 5. デプロイ手順
1. [手順1]
2. [手順2]
3. [手順3]

## 6. 運用注意事項
- [注意事項1]
- [注意事項2]

## 7. 既知の問題
| 問題 | 影響度 | 対応予定 |
|------|--------|----------|
| [問題1] | [High/Medium/Low] | [対応予定日] |