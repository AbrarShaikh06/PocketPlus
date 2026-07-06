import os
import urllib.request

urls = {
    "1_design_system.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzE1M2Y4ZWU2NTZkYzRkNDViMTFjNGFhMWNiY2VlYTZjEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "2_onboarding.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sX2Q0ZTQ1OTUzZGRiOTRkNDU4YzFmYTE5YjMzODJhZGFlEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "3_ca_connect.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzRjYzQwZDdjYTA5ODQxYzliYWE2NGEzODI0Njg5MzdkEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "4_feedback_support.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzFiM2FjMWM2ZjVlMzQ5ZTBhMTg3MWEzZWM3NDE0Y2FkEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "5_auto_capture.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzRjNTNkNDJkMzdjMTQ1MWFiMDNiYTFhNWVmZjRiNTdmEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "6_reports_screen.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzQ1Y2VlNjc4YWM5ZDQ0NGNiNzBjZDRjM2ZlNmNlOTllEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "7_home_dashboard.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sX2NiY2Q2YzJkODM1MDRkZjg5YzM3OTUwMDI4ZWM4MDYyEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "8_performance_charts.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzA1NmQwZmE1N2ZhZDRjNWQ4MzE4OGFlNDhmZWVlNzRkEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "9_add_transaction.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sX2NjZWNjYjQ3YjVhOTQ5Njg4Yzc4YmQwZTk2MDFjYWMwEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
    "10_savings_goal_planner.html": "https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzE1NTk3NzQ2NTRmODQwNTM5YzJlMWIxOGNhMGY5ZDcyEgsSBxC10NmpuhYYAZIBIwoKcHJvamVjdF9pZBIVQhMyMTY3OTgwMTQzMzk2ODA3MzMy&filename=&opi=89354086",
}

dest_dir = r"a:\IGrow\scratch\stitch_screens"
os.makedirs(dest_dir, exist_ok=True)

for name, url in urls.items():
    dest_path = os.path.join(dest_dir, name)
    print(f"Downloading {name}...")
    try:
        urllib.request.urlretrieve(url, dest_path)
        print(f"Saved to {dest_path}")
    except Exception as e:
        print(f"Failed to download {name}: {e}")
