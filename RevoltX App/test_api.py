import urllib.request
import urllib.parse
import json

API_KEY = '9ceb62c2-1b22-4819-836f-fb980fe0b53a'
USERNAME = 'Swaill'

print(f"Test de l'API tracker.gg pour : {USERNAME}")
print("=" * 50)

encoded = urllib.parse.quote(USERNAME)
url = f"https://public-api.tracker.gg/v2/fortnite/standard/profile/epic/{encoded}"

print(f"URL : {url}")

req = urllib.request.Request(url)
req.add_header('TRN-Api-Key', API_KEY)
req.add_header('Accept', 'application/json')
req.add_header('Accept-Encoding', 'identity')
req.add_header('User-Agent', 'Mozilla/5.0')

try:
    with urllib.request.urlopen(req, timeout=10) as resp:
        raw = resp.read().decode('utf-8')
        data = json.loads(raw)

        segments = data.get('data', {}).get('segments', [])
        print(f"Segments trouves : {len(segments)}")

        overview = next((s for s in segments if s.get('type') == 'overview'), None)
        if overview:
            stats = overview.get('stats', {})
            print("\nStats disponibles :")
            for key, val in list(stats.items())[:15]:
                print(f"  {key}: {val.get('displayValue', val.get('value', '?'))}")
        else:
            print("Pas d'overview trouve")
            print("Types de segments:", [s.get('type') for s in segments])

except urllib.error.HTTPError as e:
    body = e.read().decode('utf-8')
    print(f"ERREUR HTTP {e.code}: {e.reason}")
    print(f"Reponse: {body[:500]}")
except Exception as e:
    print(f"ERREUR: {e}")
