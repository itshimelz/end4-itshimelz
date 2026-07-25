



<div align="center">

# 💠 end4-itshimelz

**[@pctrade](https://github.com/pctrade) 氏の [end4-pC](https://github.com/pctrade/end4-pC) のカスタマイズフォーク**  
*( [@end-4](https://github.com/end-4) 氏の [illogical-impulse](https://github.com/end-4/dots-hyprland) から派生)*

オリジナル **[@end-4](https://github.com/end-4)** 氏 • アップストリーム **[@pctrade](https://github.com/pctrade)** 氏 • カスタマイズ＆メンテナンス **[@itshimelz](https://github.com/itshimelz)**

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

</div>

---

## 📸 スクリーンショット
<div align="center">

| 🎵 歌詞 | 🖼️ オンライン壁紙 |
|:---:|:---:|
| ![スクリーンショット 1](screenshots/1.png) | ![スクリーンショット 2](screenshots/2.png) |
| 🪟 デスクトップウィジェット | 🔧 Hyprland の設定 |
| ![スクリーンショット 5](screenshots/5.png) | ![スクリーンショット 6](screenshots/6.png) |
| ⚙️ カスタマイズ可能なバー | ✨ その他の機能 |
| ![スクリーンショット 3](screenshots/3.png) | ![スクリーンショット 4](screenshots/4.png) |

</div>

---

## ⚡ インストール

> [!NOTE]
> このフォークは独自の設定フォルダーを個別に管理するため、既存の設定を上書きまたは変更することは**ありません**。ただし、[illogical-impulse](https://github.com/end-4/dots-hyprland) がインストールされ、実行中である必要があります。

```bash
cd ~/.config/quickshell/
git clone https://github.com/pctrade/end4-pC.git
killall qs 2>/dev/null; qs -c end4-pC > /dev/null 2>&1 & disown
```

### 🔧 デフォルトのシェルに設定する（任意）

気に入って、`ii` の代わりにデフォルトで読み込むようにする場合は、次のファイルを編集します。

```bash
~/.config/hypr/hyprland/variables.lua
```

次の行を、

```lua
hl.env("qsConfig", "ii")
```

以下のように変更します。

```lua
hl.env("qsConfig", "end4-pC")
```

> [!TIP]
> 保存後、Hyprland を再起動するか `hyprctl reload` を実行して変更を適用してください。

---

### ⚙️ 設定用キーバインド

設定パネルを開くには、Hyprland の設定に次の内容を追加します。

```lua
hl.bind("SUPER + escape", hl.dsp.global("quickshell:settingsToggle"), {description = "Toggle settings"})
```

> **注意：** 設定は通常のウィンドウではなくオーバーレイパネルであるため、`Super + Q` では閉じられません。同じキーバインドで切り替えるか、`Escape` を押してください。

## 🙏 アップストリーム＆クレジット

このプロジェクトは、**[@pctrade](https://github.com/pctrade)** 氏の **[end4-pC](https://github.com/pctrade/end4-pC)** のカスタマイズフォークであり、**[@end-4](https://github.com/end-4)** 氏によるオリジナルの **[illogical-impulse](https://github.com/end-4/dots-hyprland)** から派生したものです。

オリジナルの作者および貢献者の皆さまに心から感謝いたします。

- **[@end-4](https://github.com/end-4)** — **[illogical-impulse / dots-hyprland](https://github.com/end-4/dots-hyprland)** のオリジナル作者。素晴らしい Hyprland デスクトップシェル＆dotfiles プロジェクトです 🫡
- **[@pctrade](https://github.com/pctrade)** — **[end4-pC](https://github.com/pctrade/end4-pC)** (直接のアップストリームリポジトリ) の開発者 🛠️
- **[@itshimelz](https://github.com/itshimelz)** — カスタマイズ、PipeWire オーディオ出力切替、MPRIS プレイヤー同期、キーバインドガイド、およびメンテナンス 🚀
- **[@gh0stzk](https://github.com/gh0stzk)** — 天気ウィジェットの実現に必要な天気 API 連携を提供 🙌
- **[@StarS2112](https://github.com/StarS2112)** — コミュニティおよび紹介のサポート 🙌

---

<div align="center">

**[@end-4](https://github.com/end-4)** 氏の **[illogical-impulse](https://github.com/end-4/dots-hyprland)** および **[@pctrade](https://github.com/pctrade)** 氏の **[end4-pC](https://github.com/pctrade/end4-pC)** をベースに制作 • **[@itshimelz](https://github.com/itshimelz)** が ❤️ を込めてカスタマイズ

</div>
