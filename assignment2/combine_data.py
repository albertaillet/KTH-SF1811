# %%
import pandas as pd

# %% Read nutrient data
(data_df := pd.read_csv("matdata.csv"))

# %% Read nutrient recommendations
(recom_df := pd.read_csv("rekomendationer.csv"))

# %% Read price data
(price_df := pd.read_csv("pris.csv"))

# %% drop na values
(price_df_nona := price_df.dropna())
prices_names = price_df_nona["Namn"]

# %%
lst1 = recom_df["Namn"].to_list()
lst2 = data_df.columns.to_list()
naring_columns = list(set(lst1) & set(lst2))
len(lst1), len(lst2), len(naring_columns)

# %% Get Enhet of each nutrient in "naring_columns" form data_df 
units_1 = data_df[
    data_df.columns[data_df.columns.str.endswith('Enhet')]
][[' '.join([c, 'Enhet']) for c in naring_columns]]
units_1 = units_1.reindex(sorted(units_1.columns), axis=1).iloc[4].T.reset_index().rename(columns={'index': 'Namn', 4: 'Enhet'})
units_1['Namn'] = units_1['Namn'].str.replace(' Enhet', '').reset_index(drop=True)
units_1

# %%
units_2 = recom_df[recom_df["Namn"].isin(naring_columns)].sort_values("Namn").reset_index(drop=True)
units_2

# %% Check if units are the same
assert all(units_1['Namn'] == units_2['Namn'])

for row1, row2 in zip(units_1.to_dict('records'), units_2.to_dict('records')):
    e1 = row1['Enhet']
    e2 = row2['Enhet']
    if e1 != e2:
        print(f"{e1} != {e2}, {row1['Namn']}")
        if row1['Namn'] != 'Vitamin A':
            raise ValueError(f"{e1} != {e2}, {row1['Namn']}")

# %%
A = (
    data_df
    [
        data_df["Namn"].isin(prices_names)
    ]
    .sort_values("Namn")
    [naring_columns]
    .fillna(0)
    .T
    .reset_index()
    .sort_values("index")
    .drop(columns="index")
    .values
    .astype(float)
)
# fill NaN with 0 (only for Jod column), assumed to be 0
A
# %%
b = (
    recom_df
    [recom_df["Namn"].isin(naring_columns)]
    .sort_values("Namn")
    ['Intag']
    .values
    .astype(float)
    .reshape(-1, 1)
)
b
# %%
c = (
    price_df_nona
    .sort_values("Namn")
    ['Pris']
    .values
    .astype(float)
    .reshape(-1, 1)
) / 10 # to convert to /100g
c
# %%
names = (
    price_df_nona
    .sort_values("Namn")
    ['Namn']
    .values
    .astype(str)
)
names
# %%
naringsvarden = sorted(naring_columns)
naringsvarden

# %%
from scipy import io
io.savemat(
    'data.mat', 
    {'A': A, 'b': b, 'c': c, 'names': names, 'naringsvarden': naringsvarden}
)
# %%
