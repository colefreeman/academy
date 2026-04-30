from typing import Dict, List

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer


@transformer
def convert_types(messages, *args, **kwargs):
    for message in messages:
        data = message.get('data', {})
        
        # Convert numeric fields to proper types
        if 'order_id' in data and data['order_id']:
            data['order_id'] = int(data['order_id'])
        if 'quantity' in data and data['quantity']:
            data['quantity'] = int(data['quantity'])
        if 'price' in data and data['price']:
            data['price'] = float(data['price'])
        if 'total_amount' in data and data['total_amount']:
            data['total_amount'] = float(data['total_amount'])
    
    return messages
