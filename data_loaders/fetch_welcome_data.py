import random
import pandas as pd

@data_loader
def load_data(*args, **kwargs):
    regions = ['us', 'eu', 'latam']
    orders = []

    for region in regions:
        for i in range(2):
            orders.append({
                "region": region,
                "amount": random.randint(100, 500),
            })

    return pd.DataFrame(orders)