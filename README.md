<div align="center">

# 💠 end4-itshimelz

**A customized fork of [end4-pC](https://github.com/pctrade/end4-pC) by [@pctrade](https://github.com/pctrade)**  
*(derived from [illogical-impulse](https://github.com/end-4/dots-hyprland) by [@end-4](https://github.com/end-4))*

Original Project by **[@end-4](https://github.com/end-4)** • Forked from **[@pctrade](https://github.com/pctrade)** • Customized & Maintained by **[@itshimelz](https://github.com/itshimelz)**

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [বাংলা](README.bn.md)

</div>

---

## 📸 Screenshots
<div align="center">

| 🎵 Lyrics | 🖼️ Online Wallpapers |
|:---:|:---:|
| ![Screenshot 1](screenshots/1.png) | ![Screenshot 2](screenshots/2.png) |
| 🪟 Desktop Widgets | 🔧 Hyprland Configs |
| ![Screenshot 5](screenshots/5.png) | ![Screenshot 6](screenshots/6.png) |
| ⚙️ Configurable Bar | ✨ And More |
| ![Screenshot 3](screenshots/3.png) | ![Screenshot 4](screenshots/4.png) |

</div>

---

## ⚡ Installation

> [!NOTE]
> This fork manages its own configuration folder independently — it does **not** overwrite or modify any existing setup. However, it does require [illogical-impulse](https://github.com/end-4/dots-hyprland) to be installed and running.

```bash
cd ~/.config/quickshell/
git clone https://github.com/itshimelz/end4-itshimelz.git
killall qs 2>/dev/null; qs -c end4-itshimelz > /dev/null 2>&1 & disown
```

### 🔧 Set as your default shell (optional)

If you like it and want it to load by default instead of `ii`, edit:

```bash
~/.config/hypr/hyprland/variables.lua
```

And change this line:

```lua
hl.env("qsConfig", "ii")
```

to:

```lua
hl.env("qsConfig", "end4-itshimelz")
```

> [!TIP]
> After saving, restart Hyprland or run `hyprctl reload` to apply the change.

---

### ⚙️ Keybindings

- **Settings Panel**: `Super + I`
- **Cheatsheet**: `Super + /`
- **Right Sidebar**: `Super + N`
- **Left Sidebar**: `Super + A`
- **Media Controls**: `Super + M`

---

This project is a customized fork of **[end4-pC](https://github.com/pctrade/end4-pC)** by **[@pctrade](https://github.com/pctrade)**, which is derived from **[illogical-impulse](https://github.com/end-4/dots-hyprland)** created by **[@end-4](https://github.com/end-4)**.

---

## ❓ FAQ

### How do I see my keybinds?

Open the launcher (`SUPER`) and type `<` — it'll show you the full list of configured keybinds.

### Why doesn't Settings have a search bar?

It doesn't need one — the launcher already does that job. Open the launcher (`SUPER`) and just type what you're looking for (e.g. `wallpaper`, `bar`, `blur`); it'll match against page names and section keywords and jump you straight to the right Settings page, so there's no need for a separate search inside Settings itself.

---

## 🙏 Upstream & Credits

Huge thanks to the original authors and all contributors who made this project possible:

- **[@end-4](https://github.com/end-4)** — Original author & creator of **[illogical-impulse / dots-hyprland](https://github.com/end-4/dots-hyprland)**. An outstanding Hyprland desktop shell & dotfiles ecosystem 🫡
- **[@pctrade](https://github.com/pctrade)** — Author & creator of **[end4-pC](https://github.com/pctrade/end4-pC)** (the direct upstream fork) 🛠️
- **[@itshimelz](https://github.com/itshimelz)** — Customization, PipeWire audio port switcher, instant MPRIS player sync, responsive keybind cheatsheet, and maintenance 🚀
- **[@gh0stzk](https://github.com/gh0stzk)** — Weather API integration that powers the weather widget 🙌
- **[@StarS2112](https://github.com/StarS2112)** — Showcase and community support 🙌

---

<div align="center">

Based on **[illogical-impulse](https://github.com/end-4/dots-hyprland)** by **[@end-4](https://github.com/end-4)** & **[end4-pC](https://github.com/pctrade/end4-pC)** by **[@pctrade](https://github.com/pctrade)** • Customized with ❤️ by **[@itshimelz](https://github.com/itshimelz)**

</div>
