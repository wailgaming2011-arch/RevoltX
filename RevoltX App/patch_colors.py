import os

replacements = [
    ("rgba(230,57,70", "rgba(245,196,0"),
    ("#e63946", "#f5c400"),
    ("#b52a35", "#c49a00"),
    ("#f24a57", "#f7d000"),
    ("0a0a0f", "080808"),
    ("0f0f1a", "0d0d0d"),
    ("12121c", "111111"),
    ("1a1a28", "181818"),
    ("15151f", "111111"),
    ("#8888aa", "#9a8a6a"),
    ("#e8e8f0", "#f0e8d0"),
    ("#1a0a0d", "#1a1500"),
    ("#2d0f12", "#1a1200"),
]

folder = "templates"
count = 0
for fname in os.listdir(folder):
    if not fname.endswith(".html"):
        continue
    path = os.path.join(folder, fname)
    with open(path, encoding="utf-8") as f:
        content = f.read()
    original = content
    for old, new in replacements:
        content = content.replace(old, new)
    if content != original:
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"OK: {fname}")
        count += 1

print(f"\nTermine ! {count} fichiers mis a jour.")
print("Relance python app.py pour voir le nouveau theme Or/Noir !")
