# ⚡ RevoltX Esport — Application Web

Application web complète pour l'organisation esport RevoltX.

## 🚀 Installation & Lancement

```bash
# 1. Installer les dépendances
pip install flask werkzeug

# 2. Lancer l'app
cd revoltx
python app.py

# 3. Ouvrir dans le navigateur
# http://localhost:5000
```

## 📋 Fonctionnalités

### Pour les membres
- ✅ **Inscription / Connexion** — Créer un compte ou se connecter
- ✅ **Accueil** — News, roster, statistiques de l'orga
- ✅ **Team** — Voir tous les joueurs avec leurs stats
- ✅ **Compétitions** — Historique et prochains tournois
- ✅ **Boutique** — Maillots, accessoires, équipements
- ✅ **Actualités** — Tous les articles
- ✅ **Candidature** — Formulaire pour rejoindre la team
- ✅ **Profil** — Stats Epic Games, historique des candidatures

### Epic Games
- Connecter son pseudo Epic Games dans le profil
- Les stats sont récupérées automatiquement (simulation)
- Les stats sont visibles dans la candidature

### Pour les admins
- 🔐 **Panel admin** — Accessible sur `/admin`
- 👁 **Voir les candidatures** — Avec stats Epic Games intégrées
- ✓/✗ **Accepter ou refuser** les candidatures
- 📰 **Publier des articles** directement depuis le panel
- 👥 **Gérer les membres**

## ⚙️ Notes techniques

- **1er compte créé = Admin** automatiquement
- Les données sont stockées dans `database.json`
- Pour une vraie API Epic Games, remplacer le bloc `fake_stats` dans `app.py`
- Police `Orbitron` + `Rajdhani` (Google Fonts)

## 🎨 Design
- Thème dark gaming premium
- Couleurs : Rouge #e63946 + Fond sombre
- Polices : Orbitron (titres) + Rajdhani (texte)
- Effets : Glow, noise texture, gradient mesh, animations CSS
