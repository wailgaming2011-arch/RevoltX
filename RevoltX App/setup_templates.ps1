# ============================================
# RevoltX - Script de setup des templates
# Lance ce fichier depuis ton dossier RevoltX App
# ============================================

Write-Host "⚡ RevoltX - Création des templates..." -ForegroundColor Red

# Créer le dossier templates
New-Item -ItemType Directory -Force -Path "templates" | Out-Null

# Déplacer les HTML existants
Get-ChildItem -Filter "*.html" -File | ForEach-Object {
    Move-Item $_.FullName "templates\" -Force
}
Write-Host "✓ Fichiers HTML déplacés dans templates/" -ForegroundColor Green

# ============================================
# auth.html
# ============================================
@'
{% extends "base.html" %}
{% block title %}{% if mode=='login' %}Connexion{% else %}Inscription{% endif %} — RevoltX{% endblock %}
{% block extra_css %}
<style>
.auth-page { min-height:100vh; display:flex; align-items:center; justify-content:center; padding:6rem 1rem 4rem; position:relative; overflow:hidden; }
.auth-bg { position:absolute; inset:0; background: radial-gradient(ellipse 60% 60% at 30% 50%, rgba(230,57,70,0.08) 0%, transparent 60%), radial-gradient(ellipse 40% 40% at 70% 50%, rgba(230,57,70,0.05) 0%, transparent 60%); }
.auth-card { position:relative; z-index:2; background:var(--card); border:1px solid var(--border2); border-radius:12px; width:100%; max-width:440px; padding:2.5rem; box-shadow:0 30px 60px rgba(0,0,0,0.5); }
.auth-card::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:linear-gradient(to right, var(--red), transparent); border-radius:12px 12px 0 0; }
.auth-logo { text-align:center; margin-bottom:2rem; }
.auth-logo .logo-hex { width:56px; height:56px; background:var(--red); clip-path:polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%); display:flex; align-items:center; justify-content:center; font-size:1.5rem; margin:0 auto 1rem; box-shadow:0 0 30px var(--red-glow); }
.auth-logo h2 { font-family:'Orbitron'; font-weight:900; font-size:1.4rem; letter-spacing:.15em; color:var(--white); }
.auth-logo h2 b { color:var(--red); }
.auth-logo p { color:var(--text2); font-size:.9rem; margin-top:.25rem; }
.form-group { margin-bottom:1.25rem; }
.form-group label { display:block; font-size:.8rem; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--text2); margin-bottom:.5rem; }
.form-group input { width:100%; background:var(--bg); border:1px solid var(--border2); border-radius:6px; padding:.75rem 1rem; color:var(--white); font-family:'Rajdhani'; font-size:1rem; font-weight:500; transition:border-color .2s; outline:none; }
.form-group input:focus { border-color:var(--red); box-shadow:0 0 0 3px rgba(230,57,70,0.1); }
.form-group input::placeholder { color:var(--text2); }
.auth-submit { width:100%; background:var(--red); color:#fff; border:none; border-radius:6px; padding:.85rem; font-family:'Orbitron'; font-weight:700; font-size:.9rem; letter-spacing:.1em; text-transform:uppercase; cursor:pointer; transition:all .2s; margin-top:.5rem; box-shadow:0 0 20px rgba(230,57,70,0.3); }
.auth-submit:hover { background:#f24a57; box-shadow:0 0 35px rgba(230,57,70,0.5); transform:translateY(-1px); }
.auth-switch { text-align:center; margin-top:1.5rem; color:var(--text2); font-size:.9rem; }
.auth-switch a { color:var(--red); text-decoration:none; font-weight:700; }
.auth-tabs { display:flex; background:var(--bg); border-radius:8px; padding:.25rem; margin-bottom:2rem; gap:.25rem; }
.auth-tab { flex:1; text-align:center; padding:.6rem; border-radius:6px; font-weight:700; font-size:.85rem; letter-spacing:.05em; text-transform:uppercase; text-decoration:none; transition:all .2s; color:var(--text2); }
.auth-tab.active { background:var(--red); color:#fff; box-shadow:0 0 15px rgba(230,57,70,0.3); }
</style>
{% endblock %}
{% block content %}
<div class="auth-page">
  <div class="auth-bg"></div>
  <div class="auth-card">
    <div class="auth-logo">
      <div class="logo-hex">⚡</div>
      <h2>REVOLT<b>X</b></h2>
      <p>{% if mode=='login' %}Connexion à ton compte{% else %}Rejoins la communauté{% endif %}</p>
    </div>
    <div class="auth-tabs">
      <a href="/login" class="auth-tab {% if mode=='login' %}active{% endif %}">Connexion</a>
      <a href="/register" class="auth-tab {% if mode=='register' %}active{% endif %}">Inscription</a>
    </div>
    {% if mode == 'register' %}
    <form method="post" action="/register">
      <div class="form-group"><label>Pseudo</label><input type="text" name="username" placeholder="TonPseudo" required autocomplete="off"></div>
      <div class="form-group"><label>Email</label><input type="email" name="email" placeholder="email@exemple.com" required></div>
      <div class="form-group"><label>Mot de passe</label><input type="password" name="password" placeholder="••••••••" required minlength="6"></div>
      <button class="auth-submit" type="submit">Créer mon compte</button>
    </form>
    <div class="auth-switch">Déjà membre ? <a href="/login">Se connecter</a></div>
    {% else %}
    <form method="post" action="/login">
      <div class="form-group"><label>Email</label><input type="email" name="email" placeholder="email@exemple.com" required></div>
      <div class="form-group"><label>Mot de passe</label><input type="password" name="password" placeholder="••••••••" required></div>
      <button class="auth-submit" type="submit">Se connecter</button>
    </form>
    <div class="auth-switch">Pas encore de compte ? <a href="/register">S'inscrire</a></div>
    {% endif %}
  </div>
</div>
{% endblock %}
'@ | Out-File -FilePath "templates\auth.html" -Encoding UTF8
Write-Host "✓ auth.html" -ForegroundColor Green

# ============================================
# team.html
# ============================================
@'
{% extends "base.html" %}
{% block title %}Team — RevoltX{% endblock %}
{% block extra_css %}
<style>
.page-hero { padding:6rem 2rem 3rem; text-align:center; background:radial-gradient(ellipse 80% 50% at 50% 0%,rgba(230,57,70,.1),transparent 70%); }
.page-hero h1 { font-family:'Orbitron'; font-weight:900; font-size:2.2rem; color:var(--white); margin-bottom:.5rem; }
.page-hero h1 span { color:var(--red); }
.page-hero p { color:var(--text2); }
.team-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:2rem; max-width:900px; margin:0 auto; padding:2rem 2rem 5rem; }
.player-full { background:var(--card); border:1px solid var(--border2); border-radius:12px; padding:2rem; display:flex; gap:1.5rem; align-items:flex-start; transition:all .3s; position:relative; overflow:hidden; }
.player-full::before { content:''; position:absolute; top:0; left:0; right:0; height:2px; background:linear-gradient(to right, var(--red), transparent); opacity:0; transition:opacity .3s; }
.player-full:hover { border-color:var(--border); transform:translateY(-2px); box-shadow:0 12px 40px rgba(0,0,0,.4); }
.player-full:hover::before { opacity:1; }
.pf-avatar { width:72px; height:72px; flex-shrink:0; background:linear-gradient(135deg,var(--red-dark),#1a0a0d); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:2rem; border:2px solid var(--border); box-shadow:0 0 20px rgba(230,57,70,.2); }
.pf-info h3 { font-family:'Orbitron'; font-weight:700; font-size:1.1rem; color:var(--white); }
.pf-info .pf-role { color:var(--text2); font-size:.9rem; margin:.2rem 0; }
.pf-game { display:inline-block; background:rgba(230,57,70,.1); border:1px solid rgba(230,57,70,.2); color:var(--red); font-size:.75rem; font-weight:700; padding:.15rem .5rem; border-radius:3px; }
.pf-epic { font-size:.8rem; color:var(--text2); margin-top:.4rem; }
.pf-epic b { color:#60a5fa; }
.pf-stats { display:flex; gap:1rem; margin-top:1rem; }
.pf-stat { text-align:center; background:var(--bg); border:1px solid var(--border2); border-radius:6px; padding:.6rem .8rem; }
.pf-stat .v { font-family:'Orbitron'; font-weight:700; font-size:1.1rem; color:var(--white); }
.pf-stat .l { font-size:.7rem; color:var(--text2); text-transform:uppercase; letter-spacing:.05em; }
@media(max-width:700px){ .team-grid{grid-template-columns:1fr;} .player-full{flex-direction:column;align-items:center;text-align:center;} }
</style>
{% endblock %}
{% block content %}
<div class="page-hero">
  <div class="section-tag" style="display:inline-block;margin-bottom:1rem">Roster officiel</div>
  <h1>NOTRE <span>TEAM</span></h1>
  <p>Les joueurs qui représentent RevoltX en compétition</p>
</div>
<div class="team-grid">
  {% for p in team %}
  <div class="player-full">
    <div class="pf-avatar">{{ p.avatar }}</div>
    <div class="pf-info">
      <h3>{{ p.name }}</h3>
      <div class="pf-role">{{ p.role }}</div>
      <span class="pf-game">{{ p.game }}</span>
      <div class="pf-epic">Epic: <b>{{ p.epic }}</b></div>
      <div class="pf-stats">
        <div class="pf-stat"><div class="v">{{ p.wins }}</div><div class="l">Wins</div></div>
        <div class="pf-stat"><div class="v">{{ p.kd }}</div><div class="l">K/D</div></div>
      </div>
    </div>
  </div>
  {% endfor %}
</div>
{% endblock %}
'@ | Out-File -FilePath "templates\team.html" -Encoding UTF8
Write-Host "✓ team.html" -ForegroundColor Green

# ============================================
# competitions.html
# ============================================
@'
{% extends "base.html" %}
{% block title %}Compétitions — RevoltX{% endblock %}
{% block extra_css %}
<style>
.page-hero { padding:6rem 2rem 3rem; text-align:center; background:radial-gradient(ellipse 80% 50% at 50% 0%,rgba(230,57,70,.1),transparent 70%); }
.page-hero h1 { font-family:'Orbitron'; font-weight:900; font-size:2.2rem; color:var(--white); margin-bottom:.5rem; }
.page-hero h1 span { color:var(--red); }
.page-hero p { color:var(--text2); }
.comp-section { padding:2rem 2rem 5rem; max-width:900px; margin:0 auto; }
.comp-card { background:var(--card); border:1px solid var(--border2); border-radius:10px; padding:1.5rem 2rem; margin-bottom:1.25rem; display:flex; align-items:center; justify-content:space-between; gap:1rem; transition:all .3s; }
.comp-card:hover { border-color:var(--border); transform:translateX(4px); }
.comp-left h3 { font-family:'Rajdhani'; font-weight:700; font-size:1.1rem; color:var(--white); margin-bottom:.3rem; }
.comp-left .comp-meta { display:flex; gap:1.5rem; font-size:.85rem; color:var(--text2); flex-wrap:wrap; }
.comp-right { text-align:right; }
.comp-result { font-family:'Orbitron'; font-weight:700; font-size:1rem; color:var(--white); margin-bottom:.3rem; }
.comp-prize { color:var(--gold); font-size:.85rem; font-weight:700; }
@media(max-width:600px){ .comp-card{flex-direction:column;align-items:flex-start;} .comp-right{text-align:left;} }
</style>
{% endblock %}
{% block content %}
<div class="page-hero">
  <div class="section-tag" style="display:inline-block;margin-bottom:1rem">Palmarès</div>
  <h1>COMPÉ<span>TITIONS</span></h1>
  <p>Nos performances sur la scène compétitive française et internationale</p>
</div>
<div class="comp-section">
  {% for c in competitions %}
  <div class="comp-card">
    <div class="comp-left">
      <h3>{{ c.name }}</h3>
      <div class="comp-meta">
        <span>🎮 {{ c.game }}</span>
        <span>📅 {{ c.date }}</span>
        <span class="badge {% if c.status=='Terminé' %}badge-accepted{% elif c.status=='À venir' %}badge-upcoming{% else %}badge-pending{% endif %}">{{ c.status }}</span>
      </div>
    </div>
    <div class="comp-right">
      <div class="comp-result">{{ c.result }}</div>
      <div class="comp-prize">💰 {{ c.prize }}</div>
    </div>
  </div>
  {% endfor %}
</div>
{% endblock %}
'@ | Out-File -FilePath "templates\competitions.html" -Encoding UTF8
Write-Host "✓ competitions.html" -ForegroundColor Green

# ============================================
# shop.html
# ============================================
@'
{% extends "base.html" %}
{% block title %}Boutique — RevoltX{% endblock %}
{% block extra_css %}
<style>
.page-hero { padding:6rem 2rem 3rem; text-align:center; background:radial-gradient(ellipse 80% 50% at 50% 0%, rgba(230,57,70,.1),transparent 70%); }
.page-hero h1 { font-family:'Orbitron'; font-weight:900; font-size:2.2rem; color:var(--white); margin-bottom:.5rem; }
.page-hero h1 span { color:var(--red); }
.page-hero p { color:var(--text2); }
.shop-section { padding:2rem 2rem 5rem; }
.product-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:1.5rem; max-width:1100px; margin:0 auto; }
.product-card { background:var(--card); border:1px solid var(--border2); border-radius:10px; overflow:hidden; transition:all .3s; }
.product-card:hover { border-color:var(--border); transform:translateY(-4px); box-shadow:0 12px 40px rgba(0,0,0,.5); }
.product-img { height:160px; display:flex; align-items:center; justify-content:center; font-size:5rem; }
.product-body { padding:1.25rem; }
.product-cat { font-size:.7rem; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--red); margin-bottom:.4rem; }
.product-name { font-weight:700; font-size:1rem; color:var(--white); margin-bottom:.4rem; }
.product-desc { color:var(--text2); font-size:.85rem; line-height:1.5; margin-bottom:1rem; }
.product-footer { display:flex; align-items:center; justify-content:space-between; }
.product-price { font-family:'Orbitron'; font-weight:700; font-size:1.2rem; color:var(--white); }
.product-price span { font-size:.75rem; color:var(--text2); font-family:'Rajdhani'; }
.stock-low { font-size:.75rem; color:#ffd60a; }
.btn-buy { background:var(--red); color:#fff; border:none; padding:.45rem 1rem; border-radius:5px; font-family:'Rajdhani'; font-weight:700; font-size:.85rem; cursor:pointer; transition:all .2s; }
.btn-buy:hover { background:#f24a57; box-shadow:0 0 15px rgba(230,57,70,.4); }
@media(max-width:900px){ .product-grid{grid-template-columns:repeat(2,1fr);} }
@media(max-width:600px){ .product-grid{grid-template-columns:1fr;} }
</style>
{% endblock %}
{% block content %}
<div class="page-hero">
  <div class="section-tag" style="display:inline-block;margin-bottom:1rem">Boutique officielle</div>
  <h1>SHOP <span>REVOLTX</span></h1>
  <p>Maillots, accessoires et équipements officiels RevoltX Esport</p>
</div>
<div class="shop-section">
  <div class="product-grid">
    {% for p in products %}
    <div class="product-card">
      <div class="product-img" style="background:linear-gradient(135deg,{{ p.color }}22,var(--card))">{{ p.image }}</div>
      <div class="product-body">
        <div class="product-cat">{{ p.category }}</div>
        <div class="product-name">{{ p.name }}</div>
        <div class="product-desc">{{ p.desc }}</div>
        <div class="product-footer">
          <div>
            <div class="product-price">{{ p.price }}€ <span>TTC</span></div>
            {% if p.stock < 20 %}<div class="stock-low">⚠ Plus que {{ p.stock }} en stock</div>{% endif %}
          </div>
          <button class="btn-buy" onclick="addToCart('{{ p.name }}')">Acheter</button>
        </div>
      </div>
    </div>
    {% endfor %}
  </div>
</div>
{% endblock %}
{% block extra_js %}
<script>
function addToCart(name){
  const msg = document.createElement('div');
  msg.className='flash success';
  msg.style.cssText='position:fixed;top:80px;right:1.5rem;z-index:9999;padding:.75rem 1.2rem;background:#06d6a020;border:1px solid #06d6a060;color:#06d6a0;border-radius:6px;font-weight:600;';
  msg.innerHTML='✓ '+name+' ajouté au panier !';
  document.body.appendChild(msg);
  setTimeout(()=>{msg.style.opacity='0';msg.style.transition='opacity .4s';setTimeout(()=>msg.remove(),400);},2500);
}
</script>
{% endblock %}
'@ | Out-File -FilePath "templates\shop.html" -Encoding UTF8
Write-Host "✓ shop.html" -ForegroundColor Green

# ============================================
# news.html
# ============================================
@'
{% extends "base.html" %}
{% block title %}Actualités — RevoltX{% endblock %}
{% block extra_css %}
<style>
.page-hero { padding:6rem 2rem 3rem; text-align:center; background:radial-gradient(ellipse 80% 50% at 50% 0%,rgba(230,57,70,.1),transparent 70%); }
.page-hero h1 { font-family:'Orbitron'; font-weight:900; font-size:2.2rem; color:var(--white); margin-bottom:.5rem; }
.page-hero h1 span { color:var(--red); }
.page-hero p { color:var(--text2); }
.news-section { padding:2rem 2rem 5rem; max-width:900px; margin:0 auto; }
.news-full { background:var(--card); border:1px solid var(--border2); border-radius:10px; padding:2rem; margin-bottom:1.5rem; display:flex; gap:1.5rem; transition:all .3s; }
.news-full:hover { border-color:var(--border); box-shadow:0 8px 30px rgba(0,0,0,.4); }
.news-full .n-emoji { font-size:3rem; flex-shrink:0; }
.news-full .n-cat { font-size:.7rem; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--red); margin-bottom:.4rem; }
.news-full h3 { font-family:'Rajdhani'; font-weight:700; font-size:1.2rem; color:var(--white); margin-bottom:.6rem; }
.news-full p { color:var(--text2); font-size:.9rem; line-height:1.7; }
.news-full .n-meta { display:flex; gap:1.5rem; font-size:.8rem; color:var(--text2); margin-top:1rem; }
@media(max-width:600px){ .news-full{flex-direction:column;} }
</style>
{% endblock %}
{% block content %}
<div class="page-hero">
  <div class="section-tag" style="display:inline-block;margin-bottom:1rem">Actualités</div>
  <h1>DERNIÈRES <span>NEWS</span></h1>
  <p>Toute l'actualité de RevoltX Esport</p>
</div>
<div class="news-section">
  {% for article in news %}
  <div class="news-full">
    <div class="n-emoji">{{ article.image }}</div>
    <div>
      <div class="n-cat">{{ article.category }}</div>
      <h3>{{ article.title }}</h3>
      <p>{{ article.content }}</p>
      <div class="n-meta">
        <span>✍ {{ article.author }}</span>
        <span>📅 {{ article.date }}</span>
      </div>
    </div>
  </div>
  {% endfor %}
</div>
{% endblock %}
'@ | Out-File -FilePath "templates\news.html" -Encoding UTF8
Write-Host "✓ news.html" -ForegroundColor Green

# ============================================
# apply.html
# ============================================
@'
{% extends "base.html" %}
{% block title %}Candidater — RevoltX{% endblock %}
{% block extra_css %}
<style>
.apply-page { padding:6rem 2rem 4rem; max-width:700px; margin:0 auto; }
.apply-header { text-align:center; margin-bottom:3rem; }
.apply-header h1 { font-family:'Orbitron'; font-weight:900; font-size:2rem; color:var(--white); margin-bottom:.5rem; }
.apply-header h1 span { color:var(--red); }
.apply-header p { color:var(--text2); font-size:1rem; line-height:1.6; }
.apply-card { background:var(--card); border:1px solid var(--border2); border-radius:12px; padding:2.5rem; position:relative; }
.apply-card::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:linear-gradient(to right, var(--red), transparent); border-radius:12px 12px 0 0; }
.form-group { margin-bottom:1.5rem; }
.form-group label { display:block; font-size:.8rem; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--text2); margin-bottom:.5rem; }
.form-group input, .form-group select, .form-group textarea { width:100%; background:var(--bg); border:1px solid var(--border2); border-radius:6px; padding:.75rem 1rem; color:var(--white); font-family:'Rajdhani'; font-size:1rem; font-weight:500; outline:none; transition:border-color .2s; }
.form-group input:focus,.form-group select:focus,.form-group textarea:focus { border-color:var(--red); box-shadow:0 0 0 3px rgba(230,57,70,.1); }
.form-group select option { background:var(--card); }
.form-group textarea { resize:vertical; min-height:120px; }
.form-row { display:grid; grid-template-columns:1fr 1fr; gap:1rem; }
.epic-note { padding:1rem; background:rgba(37,99,235,.08); border:1px solid rgba(37,99,235,.2); border-radius:8px; margin-bottom:1.5rem; display:flex; align-items:center; gap:.75rem; font-size:.9rem; color:#93c5fd; }
.submit-btn { width:100%; background:var(--red); color:#fff; border:none; border-radius:6px; padding:.9rem; font-family:'Orbitron'; font-weight:700; font-size:.9rem; letter-spacing:.1em; text-transform:uppercase; cursor:pointer; transition:all .2s; box-shadow:0 0 20px rgba(230,57,70,.3); }
.submit-btn:hover { background:#f24a57; box-shadow:0 0 35px rgba(230,57,70,.5); transform:translateY(-1px); }
.req-list { background:var(--card2); border:1px solid var(--border2); border-radius:12px; padding:1.5rem; margin-bottom:2rem; }
.req-list h3 { font-family:'Rajdhani'; font-weight:700; color:var(--white); margin-bottom:1rem; font-size:1rem; text-transform:uppercase; letter-spacing:.08em; }
.req-item { display:flex; align-items:center; gap:.75rem; padding:.5rem 0; border-bottom:1px solid var(--border2); font-size:.9rem; color:var(--text2); }
.req-item:last-child { border-bottom:none; }
.req-item .check { color:var(--red); }
</style>
{% endblock %}
{% block content %}
<div class="apply-page">
  <div class="apply-header">
    <h1>Rejoins <span>RevoltX</span></h1>
    <p>Tu penses avoir le niveau ? Dépose ta candidature et notre staff examinera ton profil et tes stats.</p>
  </div>
  <div class="req-list">
    <h3>Prérequis</h3>
    <div class="req-item"><span class="check">⚡</span> Être sérieux et disponible pour les entraînements</div>
    <div class="req-item"><span class="check">⚡</span> Avoir un compte Epic Games actif</div>
    <div class="req-item"><span class="check">⚡</span> Être âgé de 15 ans minimum</div>
    <div class="req-item"><span class="check">⚡</span> Avoir un bon niveau compétitif</div>
  </div>
  {% if user.epic_stats %}
  <div class="epic-note"><span>🎮</span>Tes stats Epic Games (<b>{{ user.epic_username }}</b>) seront automatiquement jointes à ta candidature.</div>
  {% else %}
  <div class="epic-note"><span>💡</span><span>Connecte ton <a href="/profile" style="color:#60a5fa">compte Epic Games</a> pour renforcer ta candidature avec tes stats !</span></div>
  {% endif %}
  <div class="apply-card">
    <form method="post" action="/apply">
      <div class="form-row">
        <div class="form-group"><label>Jeu</label><select name="game" required><option value="">Choisir un jeu...</option><option value="Fortnite">Fortnite</option><option value="Valorant">Valorant</option><option value="CS2">CS2</option><option value="Rocket League">Rocket League</option></select></div>
        <div class="form-group"><label>Rôle / Poste</label><select name="role" required><option value="">Choisir un rôle...</option><option value="IGL">IGL</option><option value="Fragger">Entry Fragger</option><option value="Support">Support</option><option value="Sniper">AWPer / Sniper</option><option value="Flex">Flex</option></select></div>
      </div>
      <div class="form-group"><label>Pseudo Epic Games</label><input type="text" name="epic_username" placeholder="TonPseudoEpic" value="{{ user.epic_username or '' }}"></div>
      <div class="form-group"><label>Présente-toi / Pourquoi RevoltX ?</label><textarea name="message" placeholder="Parle-nous de toi, de ton expérience..." required></textarea></div>
      <button type="submit" class="submit-btn">Envoyer ma candidature 🎯</button>
    </form>
  </div>
</div>
{% endblock %}
'@ | Out-File -FilePath "templates\apply.html" -Encoding UTF8
Write-Host "✓ apply.html" -ForegroundColor Green

# ============================================
# profile.html
# ============================================
@'
{% extends "base.html" %}
{% block title %}Mon Profil — RevoltX{% endblock %}
{% block extra_css %}
<style>
.profile-page { padding:6rem 2rem 4rem; max-width:900px; margin:0 auto; }
.profile-header { display:flex; align-items:center; gap:2rem; padding:2rem; margin-bottom:2rem; background:var(--card); border:1px solid var(--border2); border-radius:12px; position:relative; overflow:hidden; }
.profile-header::before { content:''; position:absolute; top:0; left:0; right:0; height:3px; background:linear-gradient(to right, var(--red), transparent); }
.profile-avatar { width:80px; height:80px; background:linear-gradient(135deg, var(--red), var(--red-dark)); border-radius:50%; display:flex; align-items:center; justify-content:center; font-family:'Orbitron'; font-weight:900; font-size:2rem; color:#fff; box-shadow:0 0 30px var(--red-glow); flex-shrink:0; }
.profile-info h2 { font-family:'Orbitron'; font-weight:700; font-size:1.4rem; color:var(--white); }
.profile-info .p-email { color:var(--text2); font-size:.9rem; margin:.2rem 0 .5rem; }
.profile-badges { display:flex; gap:.5rem; flex-wrap:wrap; margin-top:.5rem; }
.epic-section { background:var(--card); border:1px solid var(--border2); border-radius:12px; padding:2rem; margin-bottom:2rem; }
.epic-header { display:flex; align-items:center; gap:.75rem; margin-bottom:1.5rem; }
.epic-icon { width:40px; height:40px; background:linear-gradient(135deg,#2563eb,#1d4ed8); border-radius:8px; display:flex; align-items:center; justify-content:center; font-size:1.2rem; }
.epic-header h3 { font-family:'Rajdhani'; font-weight:700; font-size:1.1rem; color:var(--white); }
.epic-header p { color:var(--text2); font-size:.85rem; }
.stats-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:1rem; margin-top:1rem; }
.stat-box { background:var(--bg); border:1px solid var(--border2); border-radius:8px; padding:1rem; text-align:center; }
.stat-box .s-val { font-family:'Orbitron'; font-weight:700; font-size:1.5rem; color:var(--white); }
.stat-box .s-label { font-size:.75rem; color:var(--text2); text-transform:uppercase; letter-spacing:.08em; margin-top:.25rem; }
.connect-form { display:flex; gap:1rem; margin-top:1rem; }
.connect-form input { flex:1; background:var(--bg); border:1px solid var(--border2); border-radius:6px; padding:.7rem 1rem; color:var(--white); font-family:'Rajdhani'; font-size:1rem; outline:none; transition:border-color .2s; }
.connect-form input:focus { border-color:var(--red); }
.applications-section { background:var(--card); border:1px solid var(--border2); border-radius:12px; padding:2rem; }
.app-item { display:flex; align-items:center; justify-content:space-between; padding:1rem; background:var(--bg); border:1px solid var(--border2); border-radius:8px; margin-bottom:.75rem; }
.app-info h4 { font-weight:700; color:var(--white); }
.app-info p { color:var(--text2); font-size:.85rem; margin-top:.2rem; }
.section-title { font-family:'Rajdhani'; font-weight:700; font-size:1.1rem; color:var(--white); margin-bottom:1.5rem; display:flex; align-items:center; gap:.75rem; }
.section-title::after { content:''; flex:1; height:1px; background:var(--border2); }
</style>
{% endblock %}
{% block content %}
<div class="profile-page">
  <div class="profile-header">
    <div class="profile-avatar">{{ user.avatar }}</div>
    <div class="profile-info">
      <h2>{{ user.username }}</h2>
      <p class="p-email">{{ user.email }}</p>
      <div class="profile-badges">
        <span class="badge" style="background:rgba(230,57,70,.1);border:1px solid rgba(230,57,70,.3);color:var(--red)">Membre depuis {{ user.joined }}</span>
        {% if user.is_admin %}<span class="badge" style="background:rgba(255,214,10,.1);border:1px solid rgba(255,214,10,.3);color:#ffd60a">⭐ Admin</span>{% endif %}
        {% if user.epic_username %}<span class="badge" style="background:rgba(37,99,235,.1);border:1px solid rgba(37,99,235,.3);color:#60a5fa">🎮 Epic connecté</span>{% endif %}
      </div>
    </div>
  </div>
  <div class="epic-section">
    <div class="epic-header">
      <div class="epic-icon">🎮</div>
      <div><h3>Epic Games</h3><p>Connecte ton compte pour afficher tes stats Fortnite</p></div>
    </div>
    {% if user.epic_username and user.epic_stats %}
    <div style="display:flex;align-items:center;gap:.75rem;margin-bottom:1rem;padding:.75rem 1rem;background:rgba(37,99,235,.1);border:1px solid rgba(37,99,235,.3);border-radius:8px;">
      <span style="color:#60a5fa;font-size:1.2rem">✓</span>
      <div><div style="font-weight:700;color:#fff">{{ user.epic_username }}</div><div style="font-size:.8rem;color:#60a5fa">Compte Epic Games connecté</div></div>
    </div>
    <div class="stats-grid">
      <div class="stat-box"><div class="s-val">{{ user.epic_stats.wins }}</div><div class="s-label">Victoires</div></div>
      <div class="stat-box"><div class="s-val">{{ user.epic_stats.kd }}</div><div class="s-label">K/D Ratio</div></div>
      <div class="stat-box"><div class="s-val">{{ user.epic_stats.matches }}</div><div class="s-label">Parties</div></div>
      <div class="stat-box"><div class="s-val">{{ user.epic_stats.top10 }}</div><div class="s-label">Top 10</div></div>
      <div class="stat-box"><div class="s-val">{{ user.epic_stats.winrate }}</div><div class="s-label">Win Rate</div></div>
      <div class="stat-box"><div class="s-val">{{ user.epic_stats.platform }}</div><div class="s-label">Plateforme</div></div>
    </div>
    <form class="connect-form" method="post" action="/connect-epic" style="margin-top:1rem">
      <input type="text" name="epic_username" placeholder="Changer de compte Epic..." value="{{ user.epic_username }}">
      <button type="submit" class="btn btn-outline">Mettre à jour</button>
    </form>
    {% else %}
    <p style="color:var(--text2);margin-bottom:1rem;">Entre ton pseudo Epic Games pour récupérer automatiquement tes statistiques.</p>
    <form class="connect-form" method="post" action="/connect-epic">
      <input type="text" name="epic_username" placeholder="Ton pseudo Epic Games..." required>
      <button type="submit" class="btn btn-red">Connecter</button>
    </form>
    {% endif %}
  </div>
  <div class="applications-section">
    <div class="section-title">Mes candidatures</div>
    {% if applications %}
      {% for app in applications %}
      <div class="app-item">
        <div class="app-info"><h4>{{ app.game }} — {{ app.role }}</h4><p>Soumise le {{ app.date }}</p></div>
        <span class="badge {% if app.status=='En attente' %}badge-pending{% elif app.status=='Accepté' %}badge-accepted{% else %}badge-rejected{% endif %}">{{ app.status }}</span>
      </div>
      {% endfor %}
    {% else %}
    <div style="text-align:center;padding:2rem;color:var(--text2)">
      <div style="font-size:2rem;margin-bottom:.5rem">🎯</div>
      Aucune candidature pour le moment.<br>
      <a href="/apply" class="btn btn-red" style="margin-top:1rem;display:inline-flex">Candidater maintenant</a>
    </div>
    {% endif %}
  </div>
</div>
{% endblock %}
'@ | Out-File -FilePath "templates\profile.html" -Encoding UTF8
Write-Host "✓ profile.html" -ForegroundColor Green

# ============================================
# admin.html
# ============================================
@'
{% extends "base.html" %}
{% block title %}Administration — RevoltX{% endblock %}
{% block extra_css %}
<style>
.admin-page { padding:6rem 2rem 4rem; max-width:1100px; margin:0 auto; }
.admin-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:2rem; }
.admin-header h1 { font-family:'Orbitron'; font-weight:900; font-size:1.6rem; color:var(--white); }
.admin-header h1 span { color:var(--red); }
.stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:1rem; margin-bottom:2rem; }
.stat-card { background:var(--card); border:1px solid var(--border2); border-radius:10px; padding:1.25rem; text-align:center; }
.stat-card .s-icon { font-size:1.8rem; margin-bottom:.4rem; }
.stat-card .s-val { font-family:'Orbitron'; font-weight:900; font-size:2rem; color:var(--white); }
.stat-card .s-label { font-size:.75rem; color:var(--text2); text-transform:uppercase; letter-spacing:.08em; margin-top:.2rem; }
.admin-section { background:var(--card); border:1px solid var(--border2); border-radius:12px; padding:2rem; margin-bottom:2rem; }
.admin-section h2 { font-family:'Rajdhani'; font-weight:700; font-size:1.1rem; color:var(--white); text-transform:uppercase; letter-spacing:.1em; margin-bottom:1.5rem; display:flex; align-items:center; gap:.75rem; }
.admin-section h2::after { content:''; flex:1; height:1px; background:var(--border2); }
.app-row { background:var(--bg); border:1px solid var(--border2); border-radius:8px; margin-bottom:1rem; overflow:hidden; }
.app-row-header { padding:1rem 1.25rem; display:flex; align-items:center; justify-content:space-between; gap:1rem; cursor:pointer; transition:background .2s; }
.app-row-header:hover { background:var(--card2); }
.app-row-main h4 { font-weight:700; color:var(--white); font-size:1rem; }
.app-row-main p { font-size:.85rem; color:var(--text2); margin-top:.2rem; }
.btn-accept { background:rgba(6,214,160,.15); border:1px solid rgba(6,214,160,.4); color:#06d6a0; padding:.4rem .9rem; border-radius:5px; font-family:'Rajdhani'; font-weight:700; font-size:.8rem; text-decoration:none; transition:all .2s; letter-spacing:.05em; }
.btn-accept:hover { background:rgba(6,214,160,.25); }
.btn-reject { background:rgba(230,57,70,.1); border:1px solid rgba(230,57,70,.3); color:var(--red); padding:.4rem .9rem; border-radius:5px; font-family:'Rajdhani'; font-weight:700; font-size:.8rem; text-decoration:none; transition:all .2s; letter-spacing:.05em; }
.btn-reject:hover { background:rgba(230,57,70,.2); }
.app-detail { padding:1.25rem; border-top:1px solid var(--border2); display:none; }
.app-detail.open { display:block; }
.epic-stats-mini { display:grid; grid-template-columns:repeat(3,1fr); gap:.5rem; margin-top:.75rem; }
.epic-stat-box { background:var(--card); border:1px solid var(--border2); border-radius:6px; padding:.6rem; text-align:center; }
.epic-stat-box .v { font-family:'Orbitron'; font-weight:700; font-size:1rem; color:var(--white); }
.epic-stat-box .l { font-size:.7rem; color:var(--text2); text-transform:uppercase; }
.form-group { margin-bottom:1rem; }
.form-group label { display:block; font-size:.8rem; font-weight:700; letter-spacing:.08em; text-transform:uppercase; color:var(--text2); margin-bottom:.4rem; }
.form-group input, .form-group select, .form-group textarea { width:100%; background:var(--bg2); border:1px solid var(--border2); border-radius:6px; padding:.6rem .9rem; color:var(--white); font-family:'Rajdhani'; font-size:.95rem; outline:none; transition:border-color .2s; }
.form-group input:focus,.form-group select:focus,.form-group textarea:focus { border-color:var(--red); }
.form-group select option { background:var(--card); }
.form-group textarea { resize:vertical; min-height:80px; }
.news-form { display:grid; grid-template-columns:1fr 1fr; gap:1rem; }
.news-form-full { grid-column:1/-1; }
@media(max-width:800px){ .stats-row{grid-template-columns:repeat(2,1fr);} .news-form{grid-template-columns:1fr;} }
</style>
{% endblock %}
{% block content %}
<div class="admin-page">
  <div class="admin-header">
    <h1>⭐ ADMIN <span>PANEL</span></h1>
    <span class="badge badge-pending">Accès restreint</span>
  </div>
  <div class="stats-row">
    <div class="stat-card"><div class="s-icon">👥</div><div class="s-val">{{ stats.users }}</div><div class="s-label">Membres</div></div>
    <div class="stat-card"><div class="s-icon">📋</div><div class="s-val">{{ stats.apps }}</div><div class="s-label">Candidatures</div></div>
    <div class="stat-card"><div class="s-icon">⏳</div><div class="s-val" style="color:var(--gold)">{{ stats.pending }}</div><div class="s-label">En attente</div></div>
    <div class="stat-card"><div class="s-icon">🛍️</div><div class="s-val">{{ stats.products }}</div><div class="s-label">Produits</div></div>
  </div>
  <div class="admin-section">
    <h2>Candidatures reçues</h2>
    {% if applications %}
      {% for app in applications %}
      <div class="app-row">
        <div class="app-row-header" onclick="toggleApp('app-{{ app.id }}')">
          <div class="app-row-main">
            <h4>{{ app.username }} — {{ app.game }} / {{ app.role }}</h4>
            <p>Soumise le {{ app.date }}{% if app.epic_username %} · 🎮 <b style="color:#60a5fa">{{ app.epic_username }}</b>{% endif %}</p>
          </div>
          <div style="display:flex;align-items:center;gap:1rem">
            <span class="badge {% if app.status=='En attente' %}badge-pending{% elif app.status=='Accepté' %}badge-accepted{% else %}badge-rejected{% endif %}">{{ app.status }}</span>
            {% if app.status == 'En attente' %}
            <a href="/admin/application/{{ app.id }}/accept" class="btn-accept">✓ Accepter</a>
            <a href="/admin/application/{{ app.id }}/reject" class="btn-reject">✗ Refuser</a>
            {% endif %}
          </div>
        </div>
        <div class="app-detail" id="app-{{ app.id }}">
          <p style="color:var(--text2);font-size:.9rem;line-height:1.6;margin-bottom:.75rem"><b style="color:var(--text)">Message :</b> {{ app.message }}</p>
          {% if app.epic_stats %}
          <div style="font-size:.8rem;font-weight:700;color:var(--text2);text-transform:uppercase;letter-spacing:.08em;margin-bottom:.5rem">Stats Epic Games</div>
          <div class="epic-stats-mini">
            <div class="epic-stat-box"><div class="v">{{ app.epic_stats.wins }}</div><div class="l">Wins</div></div>
            <div class="epic-stat-box"><div class="v">{{ app.epic_stats.kd }}</div><div class="l">K/D</div></div>
            <div class="epic-stat-box"><div class="v">{{ app.epic_stats.matches }}</div><div class="l">Parties</div></div>
            <div class="epic-stat-box"><div class="v">{{ app.epic_stats.top10 }}</div><div class="l">Top 10</div></div>
            <div class="epic-stat-box"><div class="v">{{ app.epic_stats.winrate }}</div><div class="l">Win Rate</div></div>
            <div class="epic-stat-box"><div class="v">{{ app.epic_stats.platform }}</div><div class="l">Plateforme</div></div>
          </div>
          {% else %}
          <p style="color:var(--text2);font-size:.85rem">Aucune stat Epic Games liée.</p>
          {% endif %}
        </div>
      </div>
      {% endfor %}
    {% else %}
    <p style="color:var(--text2);text-align:center;padding:2rem">Aucune candidature pour le moment.</p>
    {% endif %}
  </div>
  <div class="admin-section">
    <h2>Publier un article</h2>
    <form method="post" action="/admin/news/add">
      <div class="news-form">
        <div class="form-group"><label>Titre</label><input type="text" name="title" placeholder="Titre de l'article" required></div>
        <div class="form-group"><label>Catégorie</label><select name="category"><option>Organisation</option><option>Recrutement</option><option>Compétition</option><option>Annonce</option></select></div>
        <div class="form-group"><label>Emoji</label><input type="text" name="image" placeholder="📰" value="📰"></div>
        <div class="form-group news-form-full"><label>Contenu</label><textarea name="content" placeholder="Contenu de l'article..." required></textarea></div>
      </div>
      <button type="submit" class="btn btn-red" style="margin-top:1rem">Publier l'article</button>
    </form>
  </div>
  <div class="admin-section">
    <h2>Membres ({{ users|length }})</h2>
    {% for u in users %}
    <div style="display:flex;align-items:center;justify-content:space-between;padding:.75rem 1rem;background:var(--bg);border:1px solid var(--border2);border-radius:8px;margin-bottom:.5rem">
      <div style="display:flex;align-items:center;gap:.75rem">
        <div class="avatar-circle" style="width:36px;height:36px;font-size:.85rem">{{ u.avatar }}</div>
        <div><div style="font-weight:700;color:var(--white)">{{ u.username }}</div><div style="font-size:.8rem;color:var(--text2)">{{ u.email }} · {{ u.joined }}</div></div>
      </div>
      <div style="display:flex;gap:.5rem;align-items:center">
        {% if u.epic_username %}<span class="badge" style="background:rgba(37,99,235,.1);border:1px solid rgba(37,99,235,.3);color:#60a5fa;font-size:.7rem">🎮 {{ u.epic_username }}</span>{% endif %}
        {% if u.is_admin %}<span class="badge badge-pending">Admin</span>{% endif %}
      </div>
    </div>
    {% endfor %}
  </div>
</div>
{% endblock %}
{% block extra_js %}
<script>
function toggleApp(id){ document.getElementById(id).classList.toggle('open'); }
</script>
{% endblock %}
'@ | Out-File -FilePath "templates\admin.html" -Encoding UTF8
Write-Host "✓ admin.html" -ForegroundColor Green

# ============================================
# Résumé final
# ============================================
Write-Host ""
Write-Host "============================================" -ForegroundColor Red
Write-Host "  ⚡ RevoltX — Setup terminé !" -ForegroundColor White
Write-Host "============================================" -ForegroundColor Red
Write-Host ""
Write-Host "Fichiers dans templates/ :" -ForegroundColor Yellow
Get-ChildItem templates\ -Filter "*.html" | ForEach-Object { Write-Host "  ✓ $($_.Name)" -ForegroundColor Green }
Write-Host ""
Write-Host "Lance maintenant : python app.py" -ForegroundColor Cyan
Write-Host "Puis ouvre      : http://localhost:5000" -ForegroundColor Cyan
Write-Host ""
