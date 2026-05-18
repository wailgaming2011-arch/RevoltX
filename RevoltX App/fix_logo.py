with open('templates/base.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Trouver et afficher ce qui est dans la nav-logo actuellement
idx = content.find('nav-logo')
print("=== Contenu actuel de la nav-logo ===")
print(content[idx:idx+300])
print("=====================================")

# Remplacer tout le bloc nav-logo
import re
new_logo = '<a href="/" class="nav-logo">\n    <img src="/static/logo.jpg" alt="RevoltX" style="height:44px;width:auto;">\n  </a>'

# Remplacement avec regex pour attraper n'importe quelle version
result = re.sub(
    r'<a href="/" class="nav-logo">.*?</a>',
    new_logo,
    content,
    flags=re.DOTALL
)

if result != content:
    with open('templates/base.html', 'w', encoding='utf-8') as f:
        f.write(result)
    print("OK ! Logo remplace avec succes.")
else:
    print("ERREUR : Rien remplace. Voici le HTML autour de nav-logo :")
    print(content[idx:idx+400])
