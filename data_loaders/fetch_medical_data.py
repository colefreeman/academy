import pandas as pd
from io import StringIO
import requests

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader

@data_loader
def load_data(*args, **kwargs):
    url = 'https://raw.githubusercontent.com/mage-ai/datasets/master/medical.csv'
    response = requests.get(url)
    response.raise_for_status()
    df = pd.read_csv(StringIO(response.text))

    data = []
    metadata = []

    for provider, group in df.groupby('insurance_provider'):
        print(f"Loading provider: {provider} ({len(group)} patients)")
        data.append({
            'insurance_provider': provider,
            'data': group.to_dict(orient='records'),
            'patient_count': len(group),
        })
        metadata.append({
            'block_uuid': provider.lower().replace(' ', '_'),
        })

    return [data, metadata]