-- location dim

CREATE TABLE IF NOT EXISTS `lyrical-drive-439810-j7.Mage_Academy.dim_location` (
    location_key INT64,
    borough STRING,
    incident_zip STRING
);

WITH max_key AS (
    SELECT COALESCE(MAX(location_key), 0) as max_existing_key
    FROM `lyrical-drive-439810-j7.Mage_Academy.dim_location`
),
new_locations AS (
    SELECT DISTINCT
        borough,
        incident_zip
    FROM `lyrical-drive-439810-j7.Mage_Academy.silver_nyc311`
    WHERE borough IS NOT NULL
        AND incident_zip IS NOT NULL
),
locations_with_keys AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY borough, incident_zip) + max_key.max_existing_key as location_key,
        borough,
        incident_zip
    FROM new_locations
    CROSS JOIN max_key
)
MERGE `lyrical-drive-439810-j7.Mage_Academy.dim_location` AS target
USING locations_with_keys AS source
ON target.borough = source.borough 
    AND target.incident_zip = source.incident_zip

WHEN NOT MATCHED THEN INSERT (
    location_key,
    borough,
    incident_zip
) VALUES (
    source.location_key,
    source.borough,
    source.incident_zip
);