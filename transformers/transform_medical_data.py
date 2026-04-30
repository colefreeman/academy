if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

@transformer
def transform_medical_data(df, *args, **kwargs):
    """
    Add a 'heart_health_risk' column for risk classification based on 'health_score'.
    Lower scores are better.
    """
    def classify_risk(score):
        if score <= 2:
            return "Low"
        elif score <= 4:
            return "Medium"
        else:
            return "High"
    df = df.copy()
    df["heart_health_risk"] = df["health_score"].apply(classify_risk)
    return df

@test
def test_output(output, *args) -> None:
    """
    Test that the output DataFrame has the new risk column.
    """
    assert output is not None, 'The output is undefined'
    assert "heart_health_risk" in output.columns, "Missing 'heart_health_risk' column"