#!/usr/bin/env python3
import json
import os
import subprocess

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
    outline = colors.get("outline_variant", "#313244")

    theme_dir = os.path.join(home, ".local/share/fcitx5/themes/Material-Dynamic")
    os.makedirs(theme_dir, exist_ok=True)
    theme_conf_path = os.path.join(theme_dir, "theme.conf")

    theme_content = f"""[Metadata]
Name=Material-Dynamic
Version=0.1
Author=end4-itshimelz
Description=Dynamic Material 3 Theme for Fcitx5
ScaleWithDPI=True

[InputPanel]
Font=Sans 11
NormalColor={on_surface}
HighlightCandidateColor={on_primary}
HighlightColor={primary}
HighlightBackgroundColor={surface}
Spacing=6

[InputPanel/TextMargin]
Left=12
Right=12
Top=8
Bottom=8

[InputPanel/Background]
Color={surface}
BorderColor={outline}
BorderWidth=1

[InputPanel/Background/Margin]
Left=6
Right=6
Top=6
Bottom=6

[InputPanel/Highlight]
Color={primary}

[InputPanel/Highlight/Margin]
Left=8
Right=8
Top=5
Bottom=5

[Menu/Background]
Color={surface}

[Menu/Highlight]
Color={primary_container}

[Menu/Highlight/Margin]
Left=8
Right=8
Top=5
Bottom=5
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
        subprocess.run(["fcitx5-remote", "-r"], check=False)
    except Exception:
        pass

if __name__ == "__main__":
    main()
