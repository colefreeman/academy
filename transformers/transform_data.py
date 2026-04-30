@transformer
def transform(df, *args, **kwargs):
    df['name'] = df['name'].str.title()
    df['tier'] = df['revenue'].apply(
        lambda x: 'premium' if x > 200 else 'standard'
    )
    df['active'] = df['active'].astype(bool)
    return df