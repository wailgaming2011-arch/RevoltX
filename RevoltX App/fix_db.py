import os, json

# Supprimer la DB corrompue
if os.path.exists('database.json'):
    os.remove('database.json')
    print("OK: database.json supprime")

# Créer une DB propre SANS emojis
db = {
    "users": [],
    "news": [
        {
            "id": 1,
            "title": "RevoltX rejoint la scene competitive FR",
            "content": "Notre organisation est fiere d'annoncer son entree officielle dans le circuit professionnel francais de Fortnite et Valorant. Une nouvelle ere commence.",
            "date": "2024-03-15",
            "category": "Organisation",
            "author": "Admin",
            "image": "★"
        },
        {
            "id": 2,
            "title": "Tryouts ouverts - Saison 3",
            "content": "Vous revez de jouer pour RevoltX ? Les candidatures sont maintenant ouvertes. Connectez votre compte Epic Games et soumettez votre candidature directement depuis le site.",
            "date": "2024-03-10",
            "category": "Recrutement",
            "author": "Staff",
            "image": "◆"
        },
        {
            "id": 3,
            "title": "Victoire au tournoi Paris Open",
            "content": "Notre roster Fortnite remporte le Paris Open avec un score parfait en phase de groupes. Felicitations a toute l'equipe pour cette performance exceptionnelle !",
            "date": "2024-03-05",
            "category": "Competition",
            "author": "Staff",
            "image": "▲"
        }
    ],
    "applications": [],
    "products": [
        {"id": 1, "name": "Maillot RevoltX Home 2024", "price": 59.99, "stock": 42, "category": "Maillots", "color": "#f5c400", "image": "M", "desc": "Maillot officiel domicile, tissu respirant haute performance."},
        {"id": 2, "name": "Maillot RevoltX Away 2024", "price": 59.99, "stock": 28, "category": "Maillots", "color": "#1d3557", "image": "M", "desc": "Maillot exterieur edition limitee, design exclusif."},
        {"id": 3, "name": "Hoodie RevoltX Logo", "price": 74.99, "stock": 15, "category": "Vetements", "color": "#2d2d2d", "image": "H", "desc": "Hoodie premium brode, confort maximal pour les longues sessions."},
        {"id": 4, "name": "Casquette RevoltX Snapback", "price": 29.99, "stock": 60, "category": "Accessoires", "color": "#f5c400", "image": "C", "desc": "Snapback ajustable, broderie 3D haute qualite."},
        {"id": 5, "name": "Tapis de souris XL RevoltX", "price": 24.99, "stock": 80, "category": "Gaming", "color": "#2d2d2d", "image": "T", "desc": "Surface optimisee 90x40cm, base antiderapante."},
        {"id": 6, "name": "Pack Fan Kit 2024", "price": 99.99, "stock": 10, "category": "Packs", "color": "#f5c400", "image": "P", "desc": "Maillot + Casquette + Tapis de souris, edition collector."}
    ],
    "competitions": [
        {"id": 1, "name": "Paris Open 2024", "game": "Fortnite", "date": "2024-03-05", "result": "1er place", "prize": "5,000 EUR", "status": "Termine"},
        {"id": 2, "name": "France Esport Cup", "game": "Valorant", "date": "2024-04-20", "result": "-", "prize": "10,000 EUR", "status": "A venir"},
        {"id": 3, "name": "RevoltX Invitational", "game": "Fortnite", "date": "2024-05-10", "result": "-", "prize": "2,500 EUR", "status": "En cours"}
    ],
    "team": [
        {"id": 1, "name": "ShadowX", "role": "IGL / Fragger", "game": "Fortnite", "avatar": "S", "wins": 142, "kd": 3.8, "epic": "ShadowX_RVX"},
        {"id": 2, "name": "NeonKill", "role": "Support", "game": "Fortnite", "avatar": "N", "wins": 98, "kd": 2.9, "epic": "NeonKill_RVX"},
        {"id": 3, "name": "VortexAim", "role": "Entry Fragger", "game": "Valorant", "avatar": "V", "wins": 211, "kd": 4.1, "epic": "VortexAim_RVX"},
        {"id": 4, "name": "IceSniper", "role": "AWPer", "game": "Valorant", "avatar": "I", "wins": 176, "kd": 3.5, "epic": "IceSniper_RVX"}
    ]
}

with open('database.json', 'w', encoding='utf-8') as f:
    json.dump(db, f, indent=2, ensure_ascii=True)

print("OK: database.json cree proprement sans emojis")
print("Lance maintenant : python app.py")
