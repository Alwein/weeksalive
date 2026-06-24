#!/usr/bin/env python3
"""Generate Android launcher foreground sources (BoxFit.contain).

Tuning zoom: edit values/fractions.xml -> app_icon_foreground_inset
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image

IOS_ICONS = Path(__file__).resolve().parents[2] / 'ios' / 'Runner' / 'icons'
RES = Path(__file__).resolve().parents[1] / 'app' / 'src' / 'main' / 'res'

VARIANTS = {
    'ic_launcher_composer_outline': (
        'weeksalive_composer_outline.icon/Assets/weeksalive_icon_outline 2.png',
        (0, 0, 0),
    ),
    'ic_launcher_composer_outline_light': (
        'weeksalive_composer_outline_light.icon/Assets/weeksalive_icon_outline_light.png',
        (255, 255, 255),
    ),
    'ic_launcher_draw': (
        'weeksalive_draw.icon/Assets/weeksalive_icon_draw 2.png',
        (255, 255, 255),
    ),
    'ic_launcher_composer_outline_silver': (
        'weeksalive_composer_outline_silver.icon/Assets/weeksalive_icon_outline_silver.png',
        (0, 0, 0),
    ),
    'ic_launcher_sisyphus': (
        'weeksalive_sisyphus.icon/Assets/weeksalive_icon_sisyphus 2.png',
        (255, 255, 255),
    ),
    'ic_launcher_composer_outline_gold': (
        'weeksalive_composer_outline_gold.icon/Assets/weeksalive_icon_outline_gold.png',
        (0, 0, 0),
    ),
}

DRAWABLE_SIZES = {
    'drawable-mdpi': 108,
    'drawable-hdpi': 162,
    'drawable-xhdpi': 216,
    'drawable-xxhdpi': 324,
    'drawable-xxxhdpi': 432,
}

MIPMAP_SIZES = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}


def box_fit_contain(source_path: Path, size: int, bg_color: tuple[int, int, int]) -> Image.Image:
    image = Image.open(source_path).convert('RGBA')
    canvas = Image.new('RGBA', (size, size), (*bg_color, 255))
    image.thumbnail((size, size), Image.Resampling.LANCZOS)
    offset = ((size - image.width) // 2, (size - image.height) // 2)
    canvas.paste(image, offset, image)
    return canvas


def main() -> None:
    for icon_name, (relative_source, bg) in VARIANTS.items():
        source = IOS_ICONS / relative_source
        if not source.exists():
            raise FileNotFoundError(f'Missing icon source: {source}')
        for folder_name, size in DRAWABLE_SIZES.items():
            out = RES / folder_name / f'{icon_name}_foreground_src.png'
            box_fit_contain(source, size, bg).save(out)
        for folder_name, size in MIPMAP_SIZES.items():
            out = RES / folder_name / f'{icon_name}.png'
            box_fit_contain(source, size, bg).save(out)


if __name__ == '__main__':
    main()
