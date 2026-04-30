import pandas as pd

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader

@data_loader
def load_data(**kwargs):
    return pd.DataFrame({
        'name':    ['Alice', 'Bob', 'Carol', 'Dave', 'Eve',
                    'Frank', 'Grace', 'Hank', 'Ivy', 'Jake'],
        'revenue': [920, 340, 780, 210, 460,
                    630, 890, 120, 540, 310],
        'region':  ['West', 'East', 'West', 'North', 'South',
                    'East', 'West', 'North', 'South', 'East'],
    })