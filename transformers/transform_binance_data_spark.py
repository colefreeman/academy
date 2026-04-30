if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test
from pyspark.sql import DataFrame
from pyspark.sql.functions import col, round as spark_round


@transformer
def transform(df: DataFrame, *args, **kwargs) -> DataFrame:
    """
    Calculate trade value (price * quantity)
    """
    spark = kwargs.get('spark')
    
    print("Calculating trade values...")
    
    # Add trade_value_usd column
    df = df.withColumn(
        "trade_value_usd",
        spark_round(col("price") * col("quantity"), 2)
    )
    
    # Reorder columns
    result = df.select(
        col("batch_id"),
        col("batch_timestamp"),
        col("symbol"),
        col("trade_id"),
        col("price"),
        col("quantity"),
        col("trade_value_usd"),
        col("trade_side"),
        col("trade_timestamp"),
        col("buyer_maker"),
        col("exchange")
    )
    
    print(f"Processed {result.count()} trades")
    result.show(20, truncate=False)
    
    return result
