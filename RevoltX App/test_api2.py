import urllib.request
import urllib.parse
import json

API_KEY = '9ceb62c2-1b22-4819-836f-fb980fe0b53a'
USERNAME = 'RvX Swaill'

print(f"Test tracker.gg pour : {USERNAME}")
print("=" * 50)

encoded = urllib.parse.quote(USERNAME)
url = f"https://public-api.tracker.gg/v2/fortnite/standard/profile/epic/{encoded}"
print(f"URL : {url}\n")

req = urllib.request.Request(url)
req.add_header('TRN-Api-Key', API_KEY)
req.add_header('Accept', 'application/json')
req.add_header('Accept-Encoding', 'identity')
req.add_header('User-Agent', 'Mozilla/5.0')

try:
    with urllib.request.urlopen(req, timeout=10) as resp:
        data = json.loads(resp.read().decode('utf-8'))
        segments = data.get('data', {}).get('segments', [])
        overview = next((s for s in segments if s.get('type') == 'overview'), None)
        if overview:
            stats = overview.get('stats', {})
            print("SUCCES ! Stats trouvees :")
            print(f"  Wins    : {stats.get('wins',{}).get('value','?')}")
            print(f"  K/D     : {stats.get('kd',{}).get('value','?')}")
            print(f"  Matches : {stats.get('matches',{}).get('value','?')}")
            print(f"  Kills   : {stats.get('kills',{}).get('value','?')}")
            print(f"  WinRate : {stats.get('winRate',{}).get('displayValue','?')}")
        else:
            print("Segments:", [s.get('type') for s in segments])

except urllib.error.HTTPError as e:
    print(f"ERREUR HTTP {e.code}: {e.reason}")
    print(e.read().decode('utf-8')[:300])
except Exception as e:
    print(f"ERREUR: {e}")
