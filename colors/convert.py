from pathlib import Path

for theme in Path('.').glob("*.yaml"):
    out = theme.with_suffix('.lua')
    lines = ["require('mini.base16').setup({", '  palette = {']
    for line in theme.read_text().splitlines():
        if line.startswith('base'):
            dec, color = line.split(': ')
            lines.append(f'    {dec} = {color[:1] + "#" + color[1:]},')
    lines.append('  },')
    lines.append('})\n')
    lines.append(f'vim.g.colors_name = "{theme.stem}"')
    out.write_text("\n".join(lines))
