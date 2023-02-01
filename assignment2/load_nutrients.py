import requests
import pandas as pd
import xml.etree.ElementTree as ET

'''The structure of the XML file is as follows:
<root>
    <LivsmedelsLista>
        <Livsmedel>
            <Nummer></Nummer>
            <Namn></Namn>
            <ViktGram></ViktGram>
            <Huvudgrupp></Huvudgrupp>
            <Naringsvarden>
                <Naringsvarde>
                    <Namn></Namn>
                    <Forkortning></Forkortning>
                    <Varde></Varde>
                    <Enhet></Enhet>
                    <SenastAndrad></SenastAndrad>
                    <VardeTyp></VardeTyp>
                    <Ursprung></Ursprung>
                    <Publikation></Publikation>
                    <Metodtyp></Metodtyp>
                    <Framtagningsmetod></Framtagningsmetod>
                    <Referenstyp></Referenstyp>
                </Naringsvarde>
            </Naringsvarden>
            <Klassificeringar>
                <Klassificering>
                    <Namn></Namn>
                    <Varden>
                        <KlassificeringsVarde>
                            <Namn></Namn>
                            <Kod></Kod>
                        </KlassificeringsVarde>
                    </Varden>
                </Klassificering>
            </Klassificeringar>
        </Livsmedel>
    </LivsmedelsLista>
</root>
'''

url = 'http://www7.slv.se/apilivsmedel/LivsmedelService.svc/Livsmedel/Naringsvarde/20221118'

g = requests.get(url)

root = ET.fromstring(g.text)

data = []
for food_product in root.find('LivsmedelsLista'):
    data_point = {}
    data_point['Namn'] = food_product.find('Namn').text
    for naringsvarde in food_product.find('Naringsvarden'):
        namn = naringsvarde.find('Namn').text
        varde = naringsvarde.find('Varde').text.replace(',', '.').replace('\xa0', '')
        data_point[namn] = float(varde)
        data_point[namn + ' Enhet'] = naringsvarde.find('Enhet').text
    data.append(data_point)

pd.DataFrame(data).to_csv('matdata.csv', index=False)