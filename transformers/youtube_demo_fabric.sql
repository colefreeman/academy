-- Docs: https://docs.mage.ai/guides/sql-blocks
-- Configure your connection in io_config.yaml under the project folder.
SELECT
    category_col,
    string_col,
    int_col,
    float_col,

    -- Simple calculated field
    int_col * float_col AS score,

    -- Rank rows within each category
    RANK() OVER (
        PARTITION BY category_col 
        ORDER BY int_col DESC
    ) AS rank_in_category,

    -- Average float value within the category
    AVG(float_col) OVER (
        PARTITION BY category_col
    ) AS category_avg_float

FROM dbo.test_table10;

