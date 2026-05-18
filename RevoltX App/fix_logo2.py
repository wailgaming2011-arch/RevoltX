with open('templates/base.html', 'r', encoding='utf-8') as f:
    content = f.read()

old = '<img src="/static/logo.jpg" alt="RevoltX" style="height:44px;width:auto;">'
new = '<img src="/static/logo.jpg" alt="RevoltX" style="height:44px;width:auto;"><span style="font-family:Orbitron,sans-serif;font-weight:900;font-size:1.1rem;color:#fff;letter-spacing:.15em;margin-left:.6rem">REVOLT<b style="color:#f5c400">X</b></span>'

content = content.replace(old, new)

with open('templates/base.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("OK ! REVOLTX reapparu a cote du logo.")
