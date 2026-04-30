import pandas as pd

@transformer
def transform(data, *args, **kwargs):
    df = data.groupby('region').agg(
        total_amount=('amount', 'sum'),
        order_count=('amount', 'count')
    ).reset_index()

    print(df)

    return df