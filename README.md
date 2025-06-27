# OverlayToastExample

<img src="https://github.com/user-attachments/assets/fb210fc2-9255-476f-bca0-a8e75ec64ad6" width="300">

## ⚠️ 使用上の注意：VStack構造が前提です

`inlineToast` は View 拡張としてトースト通知を挿入するための簡易APIですが、  
内部的に `VStack` を使って元のViewとトーストを**縦方向に積んで表示**しています。

そのため以下の制約があります：

- ✅ Viewの上または下に通知バーを追加したいときに最適です
- ⚠️ `HStack`, `ZStack` などと併用する場合はレイアウトが崩れる可能性があります
- ❌ トーストを「上に重ねる」用途には向きません → `overlay` ベースのカスタム実装を使用してください

### ✔️ 正しい使用例

```swift
VStack {
    ContentView()
}
.inlineToast(alignment: .top, config: ..., isPresented: showToast)
