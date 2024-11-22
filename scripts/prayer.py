#!/usr/bin/env python3
# Credit: https://github.com/3m4r5/dotfiles/blob/main/scripts/prayer.py
# todo: display in waybar according to time
# todo: cache each day
# pip install requests beautifulsoup4
import requests, bs4, json
data = {}
data['tooltip'] = '<b>Prayer Times:</b>' + ''.join([f'\n{prayer}: {div.find_all("span")[1].text.strip()}' for prayer, div in zip(('Fajr', 'Shorouk', 'Duhr', 'Asr', 'Maghreb', 'Esha'), bs4.BeautifulSoup(requests.get("http://www.awqaf.gov.jo/EN/Pages/Vision_and_Mission").content, 'html.parser').find('div', class_='modal-body').find('div', class_='row').find_all('div'))])
print(json.dumps(data))
