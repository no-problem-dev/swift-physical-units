# リリースプロセス

このドキュメントでは、swift-physical-units のリリースプロセスについて説明します。

## セマンティックバージョニング

このプロジェクトは [Semantic Versioning 2.0.0](https://semver.org/) に従います。

- **MAJOR**: 互換性のない API 変更（例: 破壊的変更）
- **MINOR**: 後方互換性のある機能追加
- **PATCH**: 後方互換性のあるバグ修正

## CHANGELOG の更新ルール

### 日常の開発作業

1. 新機能や修正を実装したら、`CHANGELOG.md` の `[Unreleased]` セクションに変更を記録
2. 適切なカテゴリに追加:
   - **Added**: 新機能
   - **Changed**: 既存機能の変更
   - **Deprecated**: 将来削除される機能
   - **Removed**: 削除された機能
   - **Fixed**: バグ修正
   - **Security**: セキュリティ修正

### 変更記録の例

```markdown
## [Unreleased]

### Added
- `Torque` 型を追加（回転力の計算用）

### Fixed
- `Mass` と `Acceleration` の乗算で単位変換が正しく行われない問題を修正
```

## リリースフロー

### 1. リリース準備

```bash
# 1. main ブランチが最新であることを確認
git checkout main
git pull origin main

# 2. リリースブランチを作成
git checkout -b release/vX.Y.Z
```

### 2. CHANGELOG の更新

1. `[Unreleased]` を `[X.Y.Z] - YYYY-MM-DD` に変更
2. 新しい `[Unreleased]` セクションを追加
3. 変更内容を確認・整理

```markdown
## [Unreleased]

## [1.0.0] - 2025-01-15

### Added
- 機能 A
- 機能 B
```

### 3. リリースコミット

```bash
git add CHANGELOG.md
git commit -m "chore: prepare release vX.Y.Z"
git push origin release/vX.Y.Z
```

### 4. プルリクエスト作成

1. `release/vX.Y.Z` から `main` へのプルリクエストを作成
2. レビューを受けてマージ

### 5. タグ作成とリリース

```bash
# main ブランチに切り替え
git checkout main
git pull origin main

# タグを作成
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z
```

### 6. GitHub Release

1. GitHub の Releases ページでタグから新しいリリースを作成
2. CHANGELOG の該当バージョンの内容をリリースノートとして使用

## 自動リリース（GitHub Actions）

将来的に GitHub Actions で以下を自動化予定:

1. タグのプッシュをトリガーに自動リリース作成
2. CHANGELOG からリリースノートを自動抽出
3. Swift Package として自動公開

## チェックリスト

リリース前の確認事項:

- [ ] すべてのテストが通過している
- [ ] CHANGELOG が更新されている
- [ ] バージョン番号がセマンティックバージョニングに従っている
- [ ] 破壊的変更がある場合は MAJOR バージョンを上げている
- [ ] ドキュメントが最新である
