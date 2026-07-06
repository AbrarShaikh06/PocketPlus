import sys, json
from graphify.build import build_from_json
from graphify.cluster import score_all
from graphify.analyze import god_nodes, surprising_connections, suggest_questions
from graphify.report import generate
from pathlib import Path

extraction = json.loads(Path('graphify-out/.graphify_extract.json').read_text(encoding='utf-8'))
detection  = json.loads(Path('graphify-out/.graphify_detect.json').read_text(encoding='utf-8-sig'))
analysis   = json.loads(Path('graphify-out/.graphify_analysis.json').read_text(encoding='utf-8'))

G = build_from_json(extraction)
communities = {int(k): v for k, v in analysis['communities'].items()}
cohesion = {int(k): v for k, v in analysis['cohesion'].items()}
tokens = {'input': extraction.get('input_tokens', 0), 'output': extraction.get('output_tokens', 0)}

labels = {
    0: "Data Models & Serialization",
    1: "Analytics Event Tracking",
    2: "PDF Export Service",
    3: "Error Handling & Failures",
    4: "Khata Customer UI",
    5: "Riverpod Provider Wiring",
    6: "Analytics Screen Tests",
    7: "Screen Routing & Navigation",
    8: "Home Dashboard & Charts",
    9: "Project Roadmap & Planning",
    10: "OCR Image Parsing",
    11: "CA Connect Feature",
    12: "Feedback Data Model",
    13: "Transaction Data Model",
    14: "SMS Capture & Permission",
    15: "Voice Entry Feature",
    16: "Feedback Screen Tests",
    17: "Settings & Security",
    18: "CA Connect Data Model",
    19: "Architecture & Tech Stack",
    20: "Test Mocks & Fakes",
    21: "Invoice Quota & Rewards",
    22: "Animation Widgets",
    23: "SMS Capture ViewModel",
    24: "Onboarding Tutorial Tests",
    25: "Firebase Cloud Messaging",
    26: "Category Data Model",
    27: "SMS Capture Confirmation",
    28: "Khata State Management",
    29: "CA Connect Tests",
}

questions = suggest_questions(G, communities, labels)

report = generate(G, communities, cohesion, labels, analysis['gods'], analysis['surprises'], detection, tokens, '.', suggested_questions=questions)
Path('graphify-out/GRAPH_REPORT.md').write_text(report, encoding='utf-8')
Path('graphify-out/.graphify_labels.json').write_text(json.dumps({str(k): v for k, v in labels.items()}, ensure_ascii=False), encoding='utf-8')
print('Report updated with community labels')
