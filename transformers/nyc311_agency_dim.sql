-- Agency Dimension Table

CREATE TABLE IF NOT EXISTS `lyrical-drive-439810-j7.Mage_Academy.dim_agency` (
    agency_key STRING,
    agency_code STRING,
    agency_name STRING
);

WITH new_agencies AS (
    SELECT DISTINCT
        agency_key,
        agency as agency_code,
        agency as agency_name
    FROM `lyrical-drive-439810-j7.Mage_Academy.silver_nyc311`
    WHERE agency IS NOT NULL
)
MERGE `lyrical-drive-439810-j7.Mage_Academy.dim_agency` AS target
USING new_agencies AS source
ON target.agency_key = source.agency_key

WHEN NOT MATCHED THEN INSERT (
    agency_key,
    agency_code,
    agency_name
) VALUES (
    source.agency_key,
    source.agency_code,
    source.agency_name
);