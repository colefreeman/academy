if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, LongType, BooleanType, TimestampType
import requests
from datetime import datetime


@data_loader
def load_data(*args, **kwargs):
    """
    Fetch recent trades from Binance Spot market
    """
    spark = SparkSession.builder.getOrCreate()
    
    symbols = ["BTCUSDT", "ETHUSDT", "BNBUSDT", "SOLUSDT", "ADAUSDT", "MATICUSDT"]
    
    schema = StructType([
        StructField("symbol", StringType(), False),
        StructField("trade_id", LongType(), False),
        StructField("price", DoubleType(), False),
        StructField("quantity", DoubleType(), False),
        StructField("trade_timestamp", TimestampType(), False),
        StructField("buyer_maker", BooleanType(), False),
        StructField("trade_side", StringType(), False),
        StructField("batch_timestamp", TimestampType(), False),
        StructField("batch_id", LongType(), False),
        StructField("exchange", StringType(), False)
    ])
    
    print("=" * 80)
    print("BINANCE SPOT TRADES")
    print("=" * 80)
    
    all_trades = []
    batch_time = datetime.now()
    batch_id = int(batch_time.timestamp() * 1000)
    
    for symbol in symbols:
        try:
            url = "https://api.binance.us/api/v3/trades"
            params = {'symbol': symbol, 'limit': 50}
            
            resp = requests.get(url, params=params, timeout=10)
            
            if resp.status_code == 200:
                trades = resp.json()
                
                for trade in trades:
                    price = float(trade['price'])
                    qty = float(trade['qty'])
                    
                    record = (
                        symbol,
                        int(trade['id']),
                        price,
                        qty,
                        datetime.fromtimestamp(int(trade['time']) / 1000),
                        trade['isBuyerMaker'],
                        "SELL" if trade['isBuyerMaker'] else "BUY",
                        batch_time,
                        batch_id,
                        "binance_spot"
                    )
                    
                    all_trades.append(record)
                
                if trades:
                    latest = trades[-1]
                    p = float(latest['price'])
                    q = float(latest['qty'])
                    side = "SELL" if latest['isBuyerMaker'] else "BUY"
                    ts = datetime.fromtimestamp(int(latest['time']) / 1000).strftime("%H:%M:%S")
                    
                    print(f"{ts} | {symbol:8} | {side:4} | ${p:>10.4f} | Qty: {q:>12.6f}")
                
            else:
                print(f"Error {symbol}: {resp.status_code}")
                
        except Exception as e:
            print(f"Error {symbol}: {e}")
    
    df = spark.createDataFrame(all_trades, schema=schema)
    
    print("=" * 80)
    print(f"Batch: {batch_id} | Trades: {df.count()} | Time: {batch_time.strftime('%H:%M:%S')}")
    print("=" * 80)
    
    return df