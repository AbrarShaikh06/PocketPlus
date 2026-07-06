import re

filepath = r"a:\IGrow\scratch\stitch_screens\8_performance_charts.html"
content = open(filepath, encoding='utf-8').read()

# Find all hex colors
hex_colors = set(re.findall(r'#[0-9a-fA-F]{6}', content))
print("Hex colors in performance_charts.html:", hex_colors)

# Find svg path fills, strokes, or tailwind color classes like bg- or text-
bg_classes = set(re.findall(r'bg-[a-z0-9\-]+', content))
text_classes = set(re.findall(r'text-[a-z0-9\-]+', content))

print("\nBackground classes in charts:")
print(sorted(list(bg_classes)))
print("\nText classes in charts:")
print(sorted(list(text_classes)))
