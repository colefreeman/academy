import pandas as pd
import requests


@data_loader
def fetch_iris_dataset_from_open_api(*args, **kwargs):
    """
    Fetches the Iris dataset from an open API and returns it as a pandas DataFrame.
    """

    # Define the API endpoint URL for the Iris dataset
    api_url = "https://api.open-meteo.com/v1/iris"  # Placeholder URL, replace with actual API if available

    # Send GET request to the API
    response = requests.get(api_url)

    # Raise an exception if the request was unsuccessful
    response.raise_for_status()

    # Parse the JSON response
    data = response.json()

    # Assuming the dataset is in a key called 'data' in the response
    # Adjust the key based on actual API response structure
    iris_data = data.get("data", [])

    # Convert the data to a pandas DataFrame
    df = pd.DataFrame(iris_data)

    return df
