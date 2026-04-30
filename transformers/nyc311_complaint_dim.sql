-- complaint dim

CREATE TABLE IF NOT EXISTS `lyrical-drive-439810-j7.Mage_Academy.dim_complaint_type` (
    complaint_type_key STRING,
    complaint_type STRING,
    descriptor STRING
);

WITH new_complaint_types AS (
    SELECT DISTINCT
        complaint_type_key,
        complaint_type,
        descriptor
    FROM `lyrical-drive-439810-j7.Mage_Academy.silver_nyc311`
    WHERE complaint_type IS NOT NULL
)
MERGE `lyrical-drive-439810-j7.Mage_Academy.dim_complaint_type` AS target
USING new_complaint_types AS source
ON target.complaint_type_key = source.complaint_type_key

WHEN NOT MATCHED THEN INSERT (
    complaint_type_key,
    complaint_type,
    descriptor
) VALUES (
    source.complaint_type_key,
    source.complaint_type,
    source.descriptor
);