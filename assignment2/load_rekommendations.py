# %%
import requests
from bs4 import BeautifulSoup
import pandas as pd

# %% Url for recommendations table
url = 'https://www.livsmedelsverket.se/matvanor-halsa--miljo/kostrad/naringsrekommendationer/naringsvarde'

# %% Get html from url and find the table
g = requests.get(url)
soup = BeautifulSoup(g.text, 'html.parser')
table = soup.find('table', {'border': '0', 'class': 'rs_content'}).find('tbody')

# %% Parse the table
namn = []
intag = []
for row in table.find_all('tr'):
    cells = row.find_all('td')
    if len(cells) == 2:
        namn.append(cells[0].text.replace('\xa0', ''))
        intag.append(float(cells[1].text.replace(',', '.')))

# %% Save the parsed data to a dataframe
df = pd.DataFrame({'Namn': namn, 'Intag': intag})
df[['Namn', 'Enhet']] = df['Namn'].str.rsplit(' ', 1, expand=True)
df['Enhet'] = df['Enhet'].map(
    {
        'mikrogram': 'µg',
        'milligram': 'mg',
    }
)

# %% Adding Fibrer, Vatten, Kolhydrater, Protein, Summa enkelomättade fettsyror, Summa fleromättade fettsyror
add_df = pd.DataFrame(
    [
        ['Fibrer', 25, 'g'],  # Source: https://www.livsmedelsverket.se/livsmedel-och-innehall/naringsamne/fibrer
        ['Vatten', 2500, 'g'],  # Source: https://ki.se/forskning/sluta-klunka-du-dricker-inte-for-lite-vatten
        ['Kolhydrater', 250, 'g'], # Source: https://www.livsmedelsverket.se/livsmedel-och-innehall/naringsamne/kolhydrater
        ['Protein', 70, 'g'],  # Source: https://www.livsmedelsverket.se/livsmedel-och-innehall/naringsamne/protein
        ['Summa enkelomättade fettsyror', 40, 'g'],  # Source: https://www.livsmedelsverket.se/livsmedel-och-innehall/naringsamne/fett/enkelomattat-fett
        ['Summa fleromättade fettsyror', 2.5, 'g'],  # Source: https://www.livsmedelsverket.se/livsmedel-och-innehall/naringsamne/fett/fleromattat-fett-omega-3-och-omega-6
    ],
    columns=['Namn', 'Intag', 'Enhet'],
)

# %% Add to df and save as csv
pd.concat([df, add_df], ignore_index=True).to_csv('rekomendationer.csv', index=False)
