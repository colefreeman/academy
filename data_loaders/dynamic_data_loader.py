from typing import List, Dict
import random


@data_loader
def load_data(*args, **kwargs) -> List[Dict]:
    regions = ['us_east', 'us_west', 'eu', 'apac', 'latam']

    rows = []
    for i, region in enumerate(regions, start=1):
        rows.append({
            "order_id": i,
            "region": region,
            "amount": random.randint(100, 500),
        })

    return rows