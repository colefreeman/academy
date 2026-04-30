@transformer
def transform(data, *args, **kwargs):
    """
    Sum amounts for the region passed from dynamic parent.
    This is a dynamic child block - one instance created per region.
    """
    # data is the first element from the yielded list
    orders = data[0] if isinstance(data, list) else data
    
    # Calculate sum for this region
    total_amount = sum(order['amount'] for order in orders)
    region = orders[0]['region']  # Get region name from first order
    
    result = {
        'region': region,
        'total_amount': total_amount,
        'order_count': len(orders)
    }
    
    print(f"Region: {region}, Total: ${total_amount}, Orders: {len(orders)}")
    
    return result