import re

with open('app.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix 1: forcer ensure_ascii=True dans save_db
content = content.replace(
    'json.dump(db, f, indent=2, ensure_ascii=False)',
    'json.dump(db, f, indent=2, ensure_ascii=True)'
)

# Fix 2: ajouter encodage UTF-8 en tete si pas deja present
if 'sys.stdout.reconfigure' not in content:
    content = 'import sys\ntry:\n    sys.stdout.reconfigure(encoding="utf-8")\n    sys.stderr.reconfigure(encoding="utf-8")\nexcept Exception:\n    pass\n' + content

with open('app.py', 'w', encoding='utf-8') as f:
    f.write(content)

print("OK: app.py corrige")
print("Lance maintenant : python fix_db.py puis python app.py")
