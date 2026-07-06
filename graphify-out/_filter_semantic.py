import json
from pathlib import Path

detect = json.loads(Path('graphify-out/.graphify_detect.json').read_text(encoding='utf-8-sig'))

non_code = []
for ftype in ['document', 'paper', 'image']:
    non_code.extend(detect['files'].get(ftype, []))

raw_uncached = Path('graphify-out/.graphify_uncached.txt').read_text(encoding='utf-8').splitlines()
uncached_set = set(raw_uncached)
uncached = [f for f in non_code if f in uncached_set]

Path('graphify-out/.graphify_uncached.txt').write_text('\n'.join(uncached), encoding='utf-8')
print(f'{len(uncached)} non-code files need semantic extraction')
print(f'  docs: {sum(1 for f in uncached if f in detect["files"]["document"])}')
print(f'  images: {sum(1 for f in uncached if f in detect["files"]["image"])}')
print(f'  papers: {sum(1 for f in uncached if f in detect["files"]["paper"])}')
