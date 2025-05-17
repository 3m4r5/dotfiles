#!/usr/bin/env python3
# Credit: https://github.com/3m4r5/dotfiles/blob/main/scripts/prayer.py
# todo: cache requests
import requests, bs4, json, datetime
times = [div.find_all("span")[1].text.strip() for div in bs4.BeautifulSoup(requests.get("http://www.awqaf.gov.jo/EN/Pages/Vision_and_Mission").content, 'html.parser').find('div', class_='modal-body').find('div', class_='row').find_all('div')]
data = {}
data['tooltip'] = '<b>Prayer Times:</b>' + ''.join([f'\n{prayer}: {div}' for prayer, div in zip(('Fajr', 'Shorouk', 'Duhr', 'Asr', 'Maghreb', 'Esha'), times)])
for i in range(len(times)): times[i] = int(times[i].replace(':', ''))
for i in range(3, 6): times[i] += 1200
table = {k: v for k, v in zip(('Fajr', 'Shorouk', 'Duhr', 'Asr', 'Maghreb', 'Esha'), times)}
current_time = int(datetime.datetime.now().strftime("%H%M"))
for prayer, time in table.items():
    if time > current_time:
        if time > 1300: time -= 1200
        data['text'] = f'{prayer} {str(time)[:-2]}:{str(time)[-2:]}'
        break
else:
    data['text'] = f'Fajr {str(times[0])[:-2]}:{str(times[0])[-2:]}'
print(json.dumps(data))