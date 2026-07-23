#!/usr/bin/env python3
import json
import os
import subprocess
from PIL import Image, ImageDraw

def create_rounded_png(filepath, width, height, radius, fill_color, outline_color=None, outline_width=1):
    img = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle(
        [0, 0, width - 1, height - 1],
        radius=radius,
        fill=fill_color,
        outline=outline_color,
        width=outline_width if outline_color else 0
    )
    img.save(filepath, "PNG")

def main():
    home = os.path.expanduser("~")
    colors_file = os.path.join(home, ".local/state/quickshell/user/generated/colors.json")
    if not os.path.exists(colors_file):
        print(f"[Fcitx5Theme] {colors_file} does not exist.")
        return

    try:
        with open(colors_file, "r") as f:
            colors = json.load(f)
    except Exception as e:
        print(f"[Fcitx5Theme] Error reading colors.json: {e}")
        return

    surface = colors.get("surface_container", "#1e1e2e")
    on_surface = colors.get("on_surface", "#cdd6f4")
    primary = colors.get("primary", "#b4befe")
    on_primary = colors.get("on_primary", "#11111b")
    primary_container = colors.get("primary_container", "#45475a")
    outline = colors.get("outline_variant", "#484648")

    theme_dir = os.path.join(home, ".local/share/fcitx5/themes/Material-Dynamic")
    os.makedirs(theme_dir, exist_ok=True)
    
    # Generate rounded background and highlight PNGs
    panel_png = os.path.join(theme_dir, "panel.png")
    highlight_png = os.path.join(theme_dir, "highlight.png")

    create_rounded_png(panel_png, width=48, height=48, radius=16, fill_color=surface, outline_color=outline, outline_width=1)
    create_rounded_png(highlight_png, width=36, height=36, radius=10, fill_color=primary)

    theme_conf_path = os.path.join(theme_dir, "theme.conf")

    theme_content = f"""[Metadata]
Name=Material-Dynamic
Version=0.1
Author=end4-itshimelz
Description=Dynamic Material 3 Theme for Fcitx5 with Rounded Corners
ScaleWithDPI=True

[InputPanel]
Font=Sans 11
NormalColor={on_surface}
HighlightCandidateColor={on_primary}
HighlightColor={on_primary}
Spacing=6

[InputPanel/TextMargin]
Left=14
Right=14
Top=10
Bottom=10

[InputPanel/Background]
Image=panel.png

[InputPanel/Background/Margin]
Left=18
Right=18
Top=18
Bottom=18

[InputPanel/Highlight]
Image=highlight.png

[InputPanel/Highlight/Margin]
Left=10
Right=10
Top=6
Bottom=6

[Menu/Background]
Image=panel.png

[Menu/Background/Margin]
Left=18
Right=18
Top=18
Bottom=18

[Menu/Highlight]
Image=highlight.png

[Menu/Highlight/Margin]
Left=10
Right=10
Top=6
Bottom=6
"""

    with open(theme_conf_path, "w") as f:
        f.write(theme_content)

    classicui_conf = os.path.join(home, ".config/fcitx5/conf/classicui.conf")
    os.makedirs(os.path.dirname(classicui_conf), exist_ok=True)

    lines = []
    if os.path.exists(classicui_conf):
        with open(classicui_conf, "r") as f:
            lines = f.readlines()

    theme_set = False
    dark_theme_set = False
    new_lines = []

    for line in lines:
        if line.startswith("Theme="):
            new_lines.append("Theme=Material-Dynamic\n")
            theme_set = True
        elif line.startswith("DarkTheme="):
            new_lines.append("DarkTheme=Material-Dynamic\n")
            dark_theme_set = True
        else:
            new_lines.append(line)

    if not theme_set:
        new_lines.append("Theme=Material-Dynamic\n")
    if not dark_theme_set:
        new_lines.append("DarkTheme=Material-Dynamic\n")

    with open(classicui_conf, "w") as f:
        f.writelines(new_lines)

    try:
        subprocess.run(["killall", "fcitx5"], check=False)
        subprocess.Popen(["fcitx5", "-d"])
    except Exception:
        pass

if __name__ == "__main__":
    main()
