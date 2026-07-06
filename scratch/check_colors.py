import os
import re
import json

dir_path = r"a:\IGrow\scratch\stitch_screens"
all_colors = {}
all_fonts = set()
all_sizes = set()

for name in os.listdir(dir_path):
    if not name.endswith('.html'):
        continue
    filepath = os.path.join(dir_path, name)
    content = open(filepath, encoding='utf-8').read()
    
    # Extract tailwind config JSON-like colors
    match = re.search(r'"colors"\s*:\s*({[^}]+})', content)
    if match:
        colors_str = match.group(1)
        try:
            # Clean up the string to be valid JSON if needed (often it is already valid JSON)
            # Replace trailing commas or single quotes if present
            colors_json = json.loads(colors_str)
            for k, v in colors_json.items():
                if k not in all_colors:
                    all_colors[k] = set()
                all_colors[k].add(v)
        except Exception as e:
            # Fallback regex extraction if json parsing fails
            for item in re.findall(r'"([^"]+)"\s*:\s*"([^"]+)"', colors_str):
                k, v = item
                if k not in all_colors:
                    all_colors[k] = set()
                all_colors[k].add(v)
                
    # Extract custom font sizes or families if any
    for size_match in re.findall(r'"fontSize"\s*:\s*({[^}]+})', content):
        try:
            sizes_json = json.loads(size_match)
            for k, v in sizes_json.items():
                all_sizes.add(f"{k}: {v}")
        except:
            pass

print("--- UNIQUE COLORS FOUND ---")
for k, vals in sorted(all_colors.items()):
    print(f"{k}: {list(vals)}")
print("\n--- UNIQUE FONT SIZES ---")
print(sorted(list(all_sizes)))
