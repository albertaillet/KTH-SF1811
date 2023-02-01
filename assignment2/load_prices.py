# %%
import re
import json
import requests
import pandas as pd
from bs4 import BeautifulSoup
from tqdm import tqdm
from IPython.display import clear_output

# %% Load saved data from livsmedelsverket API
df = pd.read_csv('matdata.csv')
df

# %% Url to Ica Maxi Stormarknad Lindhagen search
pris_url = 'https://handlaprivatkund.ica.se/stores/1003418/search?q='

# %% Reset scraped data
scraped_data = {}
i = 0

# %% Load already scraped data
with open('scraped_data.json', 'r') as f:
    scraped_data = json.load(f)
i = len(scraped_data)


# %% Find all divs containing product info, which is divs with data-test='fop-body'
names = df['Namn'].values[i:]
for name in tqdm(names, desc='Scraping ICA'):
    name_info = requests.get(pris_url + name)
    soup = BeautifulSoup(name_info.text, 'html.parser')
    divs = soup.find_all('div', {'data-test': 'fop-body'})
    prices = [div.text.replace('\xa0', '') for div in divs if div.text != '']
    scraped_data[name] = prices
    i += 1
    with open('scraped_data.json', 'w') as f:
        json.dump(scraped_data, f, indent=4, ensure_ascii=False)

# %% Reset manually cleaned data
cleaned_data = {}

# %% Load previously cleaned data
with open('cleaned_data.json', 'r') as f:
    cleaned_data = json.load(f)

# %% Clean scraped data by printing all found prices and asking for input to choose which price to use
for n, l in tqdm(scraped_data.items()):
    if n not in cleaned_data:
        if len(l) < 1:
            cleaned_data[n] = None
            continue
        print(n)
        print(*map('{} -> {}'.format, range(len(l)), l), sep='\n')
        i = input('Which one? ')
        if i != '':
            cleaned_data[n] = l[int(i)]
        else:
            cleaned_data[n] = None
        clear_output()
        with open('cleaned_data.json', 'w') as f:
            json.dump(cleaned_data, f, indent=4, ensure_ascii=False)

# %% Get price data from cleaned data using regex
prices = []
find = re.compile(r'\((\d+,\d+)kr/(\w+)')
for name, price_string in cleaned_data.items():
    if price_string is not None:
        found = find.findall(price_string)
        if len(found) == 1:
            prices.append(
                {
                    'Namn': name,
                    'Pris': float(found[0][0].replace(',', '.')),
                    'Enhet': found[0][1],
                }
            )
        elif len(found) > 1:
            raise ValueError(f'Found more than one price for {name}: {found}')
        elif len(found) == 0:
            raise ValueError(f'No price found for {name}, {price_string}')
    else:
        prices.append({'Namn': name, 'Pris': None, 'Enhet': None})

pd.DataFrame(prices).to_csv('pris.csv', index=False)
