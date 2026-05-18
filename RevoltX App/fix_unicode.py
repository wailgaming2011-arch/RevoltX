with open('app.py', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix 1 : forcer l'encodage UTF-8 au lancement
old = "from flask import Flask, render_template, request, redirect, url_for, session, jsonify, flash"
new = "import sys\nsys.stdout.reconfigure(encoding='utf-8')\nsys.stderr.reconfigure(encoding='utf-8')\nfrom flask import Flask, render_template, request, redirect, url_for, session, jsonify, flash"

content = content.replace(old, new)

# Fix 2 : remplacer les emojis dans la DB par defaut
content = content.replace('"image":"🏆"', '"image":"[Trophee]"')
content = content.replace('"image":"🎯"', '"image":"[Cible]"')
content = content.replace('"image":"🥇"', '"image":"[Medaille]"')
content = content.replace('"image":"📰"', '"image":"[Article]"')
content = content.replace('"avatar":"🎮"', '"avatar":"RVX"')
content = content.replace('"avatar":"⚡"', '"avatar":"RVX"')
content = content.replace('"avatar":"🔥"', '"avatar":"RVX"')
content = content.replace('"avatar":"❄️"', '"avatar":"RVX"')

with open('app.py', 'w', encoding='utf-8') as f:
    f.write(content)

# Supprimer la DB corrompue pour repartir propre
import os
if os.path.exists('database.json'):
    os.remove('database.json')
    print("OK : database.json supprime")

print("OK : app.py corrige pour UTF-8")
print("Lance maintenant : python app.py")
