import random


@data_loader
def load_data(*args, **kwargs):
    """
    Generate orders and yield each region's data.
    This block should be marked as DYNAMIC with STREAM mode enabled.
    """
    regions = ['us', 'eu', 'latam']

    # Process and yield each region one at a time
    for region in regions:
        region_orders = []
        
        # Create 2 orders for this region
        for i in range(2):
            region_orders.append({
                "region": region,
                "amount": random.randint(100, 500),
            })
        
        # Yield this region's orders as a list
        yield [region_orders]