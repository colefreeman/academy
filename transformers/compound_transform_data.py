@transformer
def transform(df, **kwargs):
    top_n = int(kwargs['TOP_N'])

    df = df.sort_values('revenue', ascending=False)
    df = df.head(top_n)
    df['rank'] = range(1, top_n + 1)
    return df