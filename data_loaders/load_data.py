import pandas as pd


@data_loader
def load_data(*args, **kwargs):
    return pd.DataFrame({
        'id': [1, 2, 3, 4, 5],
        'name': ['alice', 'bob', 'carol', 'dave', 'eve'],
        'revenue': [120, 340, 85, 210, 460],
        'active': [1, 0, 1, 1, 0]
    })