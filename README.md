<div align="center">

# 💠 end4-itshimelz

**A customized fork of [illogical-impulse](https://github.com/end-4/dots-hyprland) by [@end-4](https://github.com/end-4)**  

Created by **[@end-4](https://github.com/end-4)** • Customized & Maintained by **[@itshimelz](https://github.com/itshimelz)**

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

</div>

---

## 🎬 Showcase

<p align="center">
  <a href="https://www.youtube.com/watch?v=o0Vsh7eVchs">
    <img src="https://img.youtube.com/vi/o0Vsh7eVchs/maxresdefault.jpg" alt="Material 3 Expressive x Linux" width="85%" style="border-radius: 12px; box-shadow: 0px 10px 30px rgba(0,0,0,0.5);"/>
  </a>
</p>

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

## 🙏 Credits & Acknowledgments

Huge thanks to the original creators and contributors who made this project possible:

- **[@end-4](https://github.com/end-4)** — Original author & creator of [dots-hyprland](https://github.com/end-4/dots-hyprland) / illogical-impulse shell. An absolute masterpiece of a Linux dotfiles project 🫡
- **[@itshimelz](https://github.com/itshimelz)** — Customization, PipeWire audio port switcher, instant MPRIS player sync, responsive keybind cheatsheet, and maintenance 🚀
- **[@gh0stzk](https://github.com/gh0stzk)** — Weather API integration that powers the weather widget 🙌
- **[@StarS2112](https://github.com/StarS2112)** — Showcase and community support 🙌

---

<div align="center">

Made with ❤️ by **itshimelz** — based on work by **end-4**

</div>
