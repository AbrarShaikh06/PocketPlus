import json
from pathlib import Path

lines = Path('graphify-out/.graphify_uncached.txt').read_text(encoding='utf-8').strip().splitlines()

# Indices from the file (0-indexed)
chunks = {}

# Images get their own chunks
chunks["01"] = [lines[56]]                # screen.png (interesting screenshot)
chunks["02"] = lines[51:56]               # ic_launcher pngs (5 identical icons)

# Docs grouped by directory
chunks["03"] = lines[0:15]                # .ai/ (15 files)
chunks["04"] = lines[15:18] + lines[18:22] + [lines[22], lines[50]]  # .github/ + .planning/ + root analyze + test_output
chunks["05"] = lines[25:30] + [lines[39]] # docs/ + scratch/dart_files.txt
chunks["06"] = lines[30:39]               # flutter_run logs (9)
chunks["07"] = [lines[23], lines[24]] + lines[40:50]  # analyze.txt + analyze_utf8 + stitch screens (10)

total = sum(len(v) for v in chunks.values())
print(f"{len(chunks)} chunks, {total} files")

for k, v in chunks.items():
    imgs = [f for f in v if f.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.webp'))]
    docs = [f for f in v if not f.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.webp'))]
    print(f"  Chunk {k}: {len(v)} files ({len(imgs)} img, {len(docs)} doc)")
    Path(f'graphify-out/.graphify_chunk_{k}.txt').write_text('\n'.join(v), encoding='utf-8')
