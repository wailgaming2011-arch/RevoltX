import os
import sys
try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

from flask import Flask, render_template, request, redirect, url_for, session, jsonify, flash
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
from functools import wraps

app = Flask(__name__)
app.secret_key = os.environ.get("SECRET_KEY", "dev_key")

DB_FILE = 'database.json'
TRACKER_API_KEY = '9ceb62c2-1b22-4819-836f-fb980fe0b53a'

# ─── DB helpers ───────────────────────────────────────────────
def load_db():
    if not os.path.exists(DB_FILE):
        return {
            "users": [],
            "news": [
                {"id":1,"title":"RevoltX rejoint la scene competitive FR","content":"Notre organisation est fiere d annoncer son entree officielle dans le circuit professionnel francais de Fortnite et Valorant.","date":"2024-03-15","category":"Organisation","author":"Admin","image":"★"},
                {"id":2,"title":"Tryouts ouverts - Saison 3","content":"Vous revez de jouer pour RevoltX ? Les candidatures sont maintenant ouvertes. Connectez votre compte Epic Games et soumettez votre candidature.","date":"2024-03-10","category":"Recrutement","author":"Staff","image":"◆"},
                {"id":3,"title":"Victoire au tournoi Paris Open","content":"Notre roster Fortnite remporte le Paris Open avec un score parfait en phase de groupes. Felicitations a toute l equipe !","date":"2024-03-05","category":"Competition","author":"Staff","image":"▲"},
            ],
            "applications": [],
            "products": [
                {"id":1,"name":"Maillot RevoltX Home 2024","price":59.99,"stock":42,"category":"Maillots","color":"#f5c400","image":"M","desc":"Maillot officiel domicile, tissu respirant haute performance."},
                {"id":2,"name":"Maillot RevoltX Away 2024","price":59.99,"stock":28,"category":"Maillots","color":"#1d3557","image":"M","desc":"Maillot exterieur edition limitee, design exclusif."},
                {"id":3,"name":"Hoodie RevoltX Logo","price":74.99,"stock":15,"category":"Vetements","color":"#2d2d2d","image":"H","desc":"Hoodie premium brode, confort maximal."},
                {"id":4,"name":"Casquette RevoltX Snapback","price":29.99,"stock":60,"category":"Accessoires","color":"#f5c400","image":"C","desc":"Snapback ajustable, broderie 3D haute qualite."},
                {"id":5,"name":"Tapis de souris XL RevoltX","price":24.99,"stock":80,"category":"Gaming","color":"#2d2d2d","image":"T","desc":"Surface optimisee 90x40cm, base antiderapante."},
                {"id":6,"name":"Pack Fan Kit 2024","price":99.99,"stock":10,"category":"Packs","color":"#f5c400","image":"P","desc":"Maillot + Casquette + Tapis de souris, edition collector."},
            ],
            "competitions": [
                {"id":1,"name":"Paris Open 2024","game":"Fortnite","date":"2024-03-05","result":"1er place","prize":"5,000 EUR","status":"Termine"},
                {"id":2,"name":"France Esport Cup","game":"Valorant","date":"2024-04-20","result":"-","prize":"10,000 EUR","status":"A venir"},
                {"id":3,"name":"RevoltX Invitational","game":"Fortnite","date":"2024-05-10","result":"-","prize":"2,500 EUR","status":"En cours"},
            ],
            "team": [
                {"id":1,"name":"ShadowX","role":"IGL / Fragger","game":"Fortnite","avatar":"S","wins":142,"kd":3.8,"epic":"ShadowX_RVX"},
                {"id":2,"name":"NeonKill","role":"Support","game":"Fortnite","avatar":"N","wins":98,"kd":2.9,"epic":"NeonKill_RVX"},
                {"id":3,"name":"VortexAim","role":"Entry Fragger","game":"Valorant","avatar":"V","wins":211,"kd":4.1,"epic":"VortexAim_RVX"},
                {"id":4,"name":"IceSniper","role":"AWPer","game":"Valorant","avatar":"I","wins":176,"kd":3.5,"epic":"IceSniper_RVX"},
            ]
        }
    with open(DB_FILE, encoding='utf-8') as f:
        return json.load(f)

def save_db(db):
    with open(DB_FILE, 'w', encoding='utf-8') as f:
        json.dump(db, f, indent=2, ensure_ascii=True)

# ─── Tracker.gg API ───────────────────────────────────────────
def get_fortnite_stats(username):
    try:
        encoded = urllib.parse.quote(username)
        url = f"https://public-api.tracker.gg/v2/fortnite/standard/profile/epic/{encoded}"
        req = urllib.request.Request(url)
        req.add_header('TRN-Api-Key', TRACKER_API_KEY)
        req.add_header('Accept', 'application/json')
        req.add_header('Accept-Encoding', 'identity')

        with urllib.request.urlopen(req, timeout=8) as resp:
            data = json.loads(resp.read().decode('utf-8'))

        segments = data.get('data', {}).get('segments', [])
        overview = next((s for s in segments if s.get('type') == 'overview'), None)

        if not overview:
            return None

        stats = overview.get('stats', {})

        wins       = stats.get('wins', {}).get('value', 0)
        kd         = stats.get('kd', {}).get('value', 0)
        matches    = stats.get('matches', {}).get('value', 0)
        kills      = stats.get('kills', {}).get('value', 0)
        winrate    = stats.get('winRate', {}).get('displayValue', '0%')
        top10      = stats.get('top10', {}).get('value', 0)
        score      = stats.get('score', {}).get('displayValue', '0')
        platform   = data.get('data', {}).get('platformInfo', {}).get('platformSlug', 'PC').upper()

        return {
            "wins": int(wins) if wins else 0,
            "kd": round(float(kd), 2) if kd else 0,
            "matches": int(matches) if matches else 0,
            "kills": int(kills) if kills else 0,
            "winrate": winrate if winrate else "0%",
            "top10": int(top10) if top10 else 0,
            "score": score if score else "0",
            "platform": platform if platform else "PC",
            "source": "tracker.gg"
        }

    except urllib.error.HTTPError as e:
        print(f"Tracker.gg HTTP error: {e.code} - {e.reason}")
        return None
    except Exception as e:
        print(f"Tracker.gg error: {e}")
        return None

def get_valorant_stats(username):
    try:
        import urllib.parse
        # Format attendu: nom#tag
        if '#' in username:
            name, tag = username.split('#', 1)
        else:
            name, tag = username, '0000'

        encoded_name = urllib.parse.quote(name)
        encoded_tag  = urllib.parse.quote(tag)
        url = f"https://public-api.tracker.gg/v2/valorant/standard/profile/riot/{encoded_name}%23{encoded_tag}"

        req = urllib.request.Request(url)
        req.add_header('TRN-Api-Key', TRACKER_API_KEY)
        req.add_header('Accept', 'application/json')
        req.add_header('Accept-Encoding', 'identity')

        with urllib.request.urlopen(req, timeout=8) as resp:
            data = json.loads(resp.read().decode('utf-8'))

        segments = data.get('data', {}).get('segments', [])
        overview = next((s for s in segments if s.get('type') == 'overview'), None)

        if not overview:
            return None

        stats = overview.get('stats', {})

        kills    = stats.get('kills', {}).get('value', 0)
        kd       = stats.get('kDRatio', {}).get('value', 0)
        matches  = stats.get('matchesPlayed', {}).get('value', 0)
        wins     = stats.get('matchesWon', {}).get('value', 0)
        winrate  = stats.get('matchesWinPct', {}).get('displayValue', '0%')
        rank     = stats.get('rank', {}).get('displayValue', 'Non classe')
        hs_pct   = stats.get('headshotsPercentage', {}).get('displayValue', '0%')

        return {
            "wins": int(wins) if wins else 0,
            "kd": round(float(kd), 2) if kd else 0,
            "matches": int(matches) if matches else 0,
            "kills": int(kills) if kills else 0,
            "winrate": winrate if winrate else "0%",
            "rank": rank if rank else "Non classe",
            "headshots": hs_pct if hs_pct else "0%",
            "platform": "PC",
            "source": "tracker.gg"
        }

    except urllib.error.HTTPError as e:
        print(f"Tracker.gg Valorant HTTP error: {e.code} - {e.reason}")
        return None
    except Exception as e:
        print(f"Tracker.gg Valorant error: {e}")
        return None

import urllib.parse

def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'user_id' not in session:
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated

def admin_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'user_id' not in session:
            return redirect(url_for('login'))
        db = load_db()
        user = next((u for u in db['users'] if u['id'] == session['user_id']), None)
        if not user or not user.get('is_admin'):
            flash('Acces refuse - reserve aux admins.', 'error')
            return redirect(url_for('index'))
        return f(*args, **kwargs)
    return decorated

# ─── Auth ────────────────────────────────────────────────────
@app.route('/register', methods=['GET','POST'])
def register():
    if request.method == 'POST':
        db = load_db()
        username = request.form['username'].strip()
        email    = request.form['email'].strip()
        password = request.form['password']
        if any(u['email'] == email for u in db['users']):
            flash('Email deja utilise.', 'error')
            return render_template('auth.html', mode='register')
        user = {
            "id": str(uuid.uuid4()),
            "username": username,
            "email": email,
            "password": generate_password_hash(password),
            "is_admin": len(db['users']) == 0,
            "epic_username": "",
            "epic_game": "Fortnite",
            "epic_stats": {},
            "joined": datetime.now().strftime("%Y-%m-%d"),
            "avatar": username[0].upper()
        }
        db['users'].append(user)
        save_db(db)
        session['user_id']  = user['id']
        session['username'] = user['username']
        session['is_admin'] = user['is_admin']
        return redirect(url_for('index'))
    return render_template('auth.html', mode='register')

@app.route('/login', methods=['GET','POST'])
def login():
    if request.method == 'POST':
        db       = load_db()
        email    = request.form['email'].strip()
        password = request.form['password']
        user     = next((u for u in db['users'] if u['email'] == email), None)
        if user and check_password_hash(user['password'], password):
            session['user_id']  = user['id']
            session['username'] = user['username']
            session['is_admin'] = user.get('is_admin', False)
            return redirect(url_for('index'))
        flash('Identifiants incorrects.', 'error')
    return render_template('auth.html', mode='login')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('login'))

# ─── Pages principales ────────────────────────────────────────
@app.route('/')
def index():
    db   = load_db()
    user = None
    if 'user_id' in session:
        user = next((u for u in db['users'] if u['id'] == session['user_id']), None)
    return render_template('index.html', news=db['news'][:3], team=db['team'], user=user)

@app.route('/team')
def team():
    db   = load_db()
    user = None
    if 'user_id' in session:
        user = next((u for u in db['users'] if u['id'] == session['user_id']), None)
    return render_template('team.html', team=db['team'], user=user)

@app.route('/competitions')
def competitions():
    db   = load_db()
    user = None
    if 'user_id' in session:
        user = next((u for u in db['users'] if u['id'] == session['user_id']), None)
    return render_template('competitions.html', competitions=db['competitions'], user=user)

@app.route('/shop')
def shop():
    db   = load_db()
    user = None
    if 'user_id' in session:
        user = next((u for u in db['users'] if u['id'] == session['user_id']), None)
    return render_template('shop.html', products=db['products'], user=user)

@app.route('/news')
def news():
    db   = load_db()
    user = None
    if 'user_id' in session:
        user = next((u for u in db['users'] if u['id'] == session['user_id']), None)
    return render_template('news.html', news=db['news'], user=user)

@app.route('/apply', methods=['GET','POST'])
@login_required
def apply():
    db   = load_db()
    user = next((u for u in db['users'] if u['id'] == session['user_id']), None)
    if request.method == 'POST':
        already = any(a['user_id'] == session['user_id'] and a['status'] == 'En attente' for a in db['applications'])
        if already:
            flash('Tu as deja une candidature en attente.', 'error')
        else:
            app_data = {
                "id":           str(uuid.uuid4()),
                "user_id":      session['user_id'],
                "username":     session['username'],
                "game":         request.form['game'],
                "role":         request.form['role'],
                "message":      request.form['message'],
                "epic_username": request.form.get('epic_username',''),
                "epic_stats":   user.get('epic_stats', {}),
                "status":       "En attente",
                "date":         datetime.now().strftime("%Y-%m-%d")
            }
            db['applications'].append(app_data)
            if request.form.get('epic_username'):
                for u in db['users']:
                    if u['id'] == session['user_id']:
                        u['epic_username'] = request.form.get('epic_username','')
            save_db(db)
            flash('Candidature envoyee !', 'success')
            return redirect(url_for('apply'))
    return render_template('apply.html', user=user)

@app.route('/profile')
@login_required
def profile():
    db      = load_db()
    user    = next((u for u in db['users'] if u['id'] == session['user_id']), None)
    my_apps = [a for a in db['applications'] if a['user_id'] == session['user_id']]
    return render_template('profile.html', user=user, applications=my_apps)

# ─── Connexion Epic / Tracker.gg ─────────────────────────────
@app.route('/connect-epic', methods=['POST'])
@login_required
def connect_epic():
    db             = load_db()
    epic_username  = request.form.get('epic_username','').strip()
    game           = request.form.get('game', 'Fortnite')

    flash('Recuperation des stats en cours...', 'success')

    # Appel API tracker.gg selon le jeu
    if game == 'Valorant':
        stats = get_valorant_stats(epic_username)
    else:
        stats = get_fortnite_stats(epic_username)

    if stats:
        for u in db['users']:
            if u['id'] == session['user_id']:
                u['epic_username'] = epic_username
                u['epic_game']     = game
                u['epic_stats']    = stats
        save_db(db)
        flash(f'Compte {game} "{epic_username}" connecte ! Stats reelles recuperees via tracker.gg', 'success')
    else:
        # Stats non trouvees - sauvegarder quand meme le pseudo
        for u in db['users']:
            if u['id'] == session['user_id']:
                u['epic_username'] = epic_username
                u['epic_game']     = game
                u['epic_stats']    = {}
        save_db(db)
        flash(f'Pseudo "{epic_username}" sauvegarde mais stats introuvables. Verifie ton pseudo ou rends ton profil public sur tracker.gg', 'error')

    return redirect(url_for('profile'))

# ─── Admin ────────────────────────────────────────────────────
@app.route('/admin')
@admin_required
def admin():
    db   = load_db()
    user = next((u for u in db['users'] if u['id'] == session['user_id']), None)
    return render_template('admin.html',
        applications=db['applications'],
        users=db['users'],
        user=user,
        stats={
            "users":    len(db['users']),
            "apps":     len(db['applications']),
            "pending":  sum(1 for a in db['applications'] if a['status']=='En attente'),
            "products": len(db['products'])
        }
    )

@app.route('/admin/application/<app_id>/<action>')
@admin_required
def admin_app_action(app_id, action):
    db = load_db()
    for a in db['applications']:
        if a['id'] == app_id:
            a['status'] = 'Accepte' if action == 'accept' else 'Refuse'
    save_db(db)
    return redirect(url_for('admin'))

@app.route('/admin/news/add', methods=['POST'])
@admin_required
def admin_add_news():
    db      = load_db()
    news_id = max((n['id'] for n in db['news']), default=0) + 1
    db['news'].insert(0, {
        "id":       news_id,
        "title":    request.form['title'],
        "content":  request.form['content'],
        "date":     datetime.now().strftime("%Y-%m-%d"),
        "category": request.form['category'],
        "author":   session['username'],
        "image":    request.form.get('image','★')
    })
    save_db(db)
    flash('Article publie !', 'success')
    return redirect(url_for('admin'))

# ─── API stats live ──────────────────────────────────────────
@app.route('/api/stats/<game>/<username>')
@login_required
def api_stats(game, username):
    if game == 'valorant':
        stats = get_valorant_stats(username)
    else:
        stats = get_fortnite_stats(username)
    if stats:
        return jsonify({"success": True, "stats": stats})
    return jsonify({"success": False, "error": "Joueur introuvable ou profil prive"}), 404

if __name__ == '__main__':
    app.run(debug=True, port=5000)
