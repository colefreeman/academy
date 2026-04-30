from mage_ai.settings.repo import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_big_query(*args, **kwargs) -> dict:
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    # With [data, metadata] format, Mage passes each item as positional arg
    item = args[0] if args else None
    
    # Fallback to kwargs if args is empty
    if item is None:
        provider = kwargs.get('insurance_provider')
        records = kwargs.get('data', [])
    else:
        if isinstance(item, list):
            item = item[0]
        provider = item.get('insurance_provider')
        records = item.get('data', [])

    if not provider:
        raise ValueError(f"No provider found. args={args}, kwargs keys={list(kwargs.keys())}")

    df = DataFrame(records)
    df = df.drop(columns=['name', 'ssn', 'address'], errors='ignore')

    table_id = f'lyrical-drive-439810-j7.Mage_Academy.{provider}_patients'

    print(f"Writing {len(df)} rows to {table_id}")

    BigQuery.with_config(
        ConfigFileLoader(config_path, config_profile)
    ).export(df, table_id, if_exists='replace')

    output = dict(
        insurance_provider=provider,
        table_id=table_id,
        row_count=len(df),
    )

    print("EXPORTER OUTPUT:", output)
    return output