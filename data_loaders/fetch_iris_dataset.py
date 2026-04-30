from typing import Optional
import pandas as pd
import io
import requests


@data_loader
def fetch_iris_dataset(*args, **kwargs):
    """
    Fetch the Iris dataset from a GitHub repository and return as a pandas DataFrame.

    Parameters:
    -----------
    timeout : int, optional
        Timeout in seconds for the HTTP request (default: 30)

    Returns:
    --------
    pd.DataFrame
        The Iris dataset as a pandas DataFrame

    Raises:
    -------
    requests.RequestException
        If the HTTP request fails or times out
    """
    # URL of the Iris dataset CSV file on GitHub
    timeout: Optional[int] = 30
    iris_api_url = (
        "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv"
    )

    try:
        # Fetch the CSV data directly with timeout
        iris_response = requests.get(iris_api_url, timeout=timeout)

        # Raise exception if the request was unsuccessful
        iris_response.raise_for_status()

        # Read CSV data into pandas DataFrame
        iris_df = pd.read_csv(io.StringIO(iris_response.text))

        return iris_df

    except requests.RequestException as e:
        raise requests.RequestException(
            f"Failed to fetch Iris dataset from {iris_api_url}: {str(e)}"
        ) from e