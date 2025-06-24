#!/usr/bin/env python3
# Credit: https://github.com/3m4r5/dotfiles/blob/main/scripts/prayer.py
import requests, bs4, json, datetime, os
CACHE_PATH = os.path.expanduser("~/.cache/prayer_times.json")
now = datetime.datetime.now()
cache_valid = False
if os.path.exists(CACHE_PATH):
    try:
        with open(CACHE_PATH, 'r') as f: cache = json.load(f)
        cache_date = cache.get('date')
        if cache_date == now.strftime('%Y-%m-%d'): times, cache_valid = cache['times'], True
    except Exception: pass
if not cache_valid:
    times = [div.find_all("span")[1].text.strip() for div in bs4.BeautifulSoup(requests.get("http://www.awqaf.gov.jo/EN/Pages/Vision_and_Mission").content, 'html.parser').find('div', class_='modal-body').find('div', class_='row').find_all('div')]
    os.makedirs(os.path.dirname(CACHE_PATH), exist_ok=True)
    with open(CACHE_PATH, 'w') as f: json.dump({'date': now.strftime('%Y-%m-%d'), 'times': times}, f)
prayer_names = ('Fajr', 'Shorouk', 'Duhr', 'Asr', 'Maghreb', 'Esha')# Parse times as datetime.time objects
prayer_times = [datetime.time(*map(int, t.split(':'))) for t in times]
data = {"tooltip": '<b>Prayer Times:</b>' + ''.join([f'\n{prayer}: {div}' for prayer, div in zip(prayer_names, times)])}
# Adjust Asr, Maghreb, Esha by adding 12 hours if needed (for 24h format)
for i in range(3, 6):
    if prayer_times[i].hour < 12: prayer_times[i] = (datetime.datetime.combine(now.date(), prayer_times[i]) + datetime.timedelta(hours=12)).time()
table = {k: v for k, v in zip(prayer_names, prayer_times)}
current_time = datetime.datetime.now().time()
# Find the next or current prayer
for idx, (prayer, time) in enumerate(table.items()):
    prayer_dt = datetime.datetime.combine(now.date(), time)
    current_dt = datetime.datetime.combine(now.date(), current_time)
    minutes_diff = (current_dt - prayer_dt).total_seconds() // 60
    if minutes_diff <= 30:
        delta = f"{int(minutes_diff):+}m" if minutes_diff > -60 else f"{int(minutes_diff // 60):+}h"
        data['text'] = f'{prayer} {time.strftime("%I:%M %p")} ({delta})'
        break
else:
    fajr_time = prayer_times[0]
    fajr_dt = datetime.datetime.combine((now + datetime.timedelta(days=1)).date(), fajr_time)
    current_dt = datetime.datetime.combine(now.date(), current_time)
    minutes_diff = (current_dt - fajr_dt).total_seconds() // 60
    delta = f"{int(minutes_diff):+}m" if minutes_diff > -60 else f"{int(minutes_diff // 60):+}h"
    data['text'] = f'Fajr {fajr_time.strftime("%I:%M %p")} ({delta})'
print(json.dumps(data))