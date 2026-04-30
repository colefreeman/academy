-- Silver Layer: Type 1 SCD with Time Metrics and Hash Keys

CREATE TABLE IF NOT EXISTS `lyrical-drive-439810-j7.Mage_Academy.silver_nyc311` (
    complaint_id STRING,
    created_date TIMESTAMP,
    agency STRING,
    agency_key STRING,
    complaint_type STRING,
    descriptor STRING,
    complaint_type_key STRING,
    status STRING,
    borough STRING,
    incident_zip STRING,
    location_key STRING,
    incident_address STRING,
    latitude FLOAT64,
    longitude FLOAT64,
    resolution_action_updated_date TIMESTAMP,
    closed_date TIMESTAMP,
    resolution_description STRING,
    loaded_at TIMESTAMP,
    first_seen_date DATE,
    last_updated_date DATE,
    days_since_created INT64,
    days_since_last_action INT64,
    days_to_close INT64,
    is_open BOOLEAN
);

MERGE `lyrical-drive-439810-j7.Mage_Academy.silver_nyc311` AS target
USING (
    SELECT 
        unique_key as complaint_id,
        TIMESTAMP(created_date) as created_date,
        COALESCE(agency, 'Unknown') as agency,
        TO_HEX(SHA256(COALESCE(agency, 'Unknown'))) as agency_key,
        COALESCE(complaint_type, 'Other') as complaint_type,
        COALESCE(descriptor, 'No Description') as descriptor,
        TO_HEX(SHA256(CONCAT(COALESCE(complaint_type, 'Other'), '|', COALESCE(descriptor, 'No Description')))) as complaint_type_key,
        COALESCE(status, 'Unknown') as status,
        COALESCE(borough, 'Unknown') as borough,
        COALESCE(incident_zip, 'Unknown') as incident_zip,
        TO_HEX(SHA256(CONCAT(COALESCE(borough, 'Unknown'), '|', COALESCE(incident_zip, 'Unknown')))) as location_key,
        COALESCE(incident_address, 'Address Not Provided') as incident_address,
        CAST(latitude AS FLOAT64) as latitude,
        CAST(longitude AS FLOAT64) as longitude,
        TIMESTAMP(resolution_action_updated_date) as resolution_action_updated_date,
        TIMESTAMP(closed_date) as closed_date,
        COALESCE(resolution_description, '') as resolution_description,
        TIMESTAMP(loaded_at) as loaded_at,
        DATE_DIFF(CURRENT_DATE(), DATE(created_date), DAY) as days_since_created,
        DATE_DIFF(CURRENT_DATE(), DATE(COALESCE(resolution_action_updated_date, created_date)), DAY) as days_since_last_action,
        CASE 
            WHEN closed_date IS NOT NULL 
            THEN DATE_DIFF(DATE(closed_date), DATE(created_date), DAY)
            ELSE NULL 
        END as days_to_close,
        CASE WHEN UPPER(status) NOT IN ('CLOSED', 'RESOLVED') THEN TRUE ELSE FALSE END as is_open
    FROM `lyrical-drive-439810-j7.Mage_Academy.bronze_nyc311`
    WHERE DATE(loaded_at) = (SELECT MAX(DATE(loaded_at)) FROM `lyrical-drive-439810-j7.Mage_Academy.bronze_nyc311`)
) AS source
ON target.complaint_id = source.complaint_id

WHEN MATCHED THEN UPDATE SET
    agency_key = source.agency_key,
    complaint_type_key = source.complaint_type_key,
    location_key = source.location_key,
    status = source.status,
    resolution_action_updated_date = source.resolution_action_updated_date,
    closed_date = source.closed_date,
    resolution_description = source.resolution_description,
    loaded_at = source.loaded_at,
    last_updated_date = CURRENT_DATE(),
    days_since_created = source.days_since_created,
    days_since_last_action = source.days_since_last_action,
    days_to_close = source.days_to_close,
    is_open = source.is_open

WHEN NOT MATCHED THEN INSERT (
    complaint_id, created_date, agency, agency_key, complaint_type, descriptor, complaint_type_key,
    status, borough, incident_zip, location_key, incident_address, latitude, longitude,
    resolution_action_updated_date, closed_date, resolution_description,
    loaded_at, first_seen_date, last_updated_date,
    days_since_created, days_since_last_action, days_to_close, is_open
) VALUES (
    source.complaint_id, source.created_date, source.agency, source.agency_key,
    source.complaint_type, source.descriptor, source.complaint_type_key,
    source.status, source.borough, source.incident_zip, source.location_key,
    source.incident_address, source.latitude, source.longitude,
    source.resolution_action_updated_date, source.closed_date, source.resolution_description,
    source.loaded_at, CURRENT_DATE(), CURRENT_DATE(),
    source.days_since_created, source.days_since_last_action, source.days_to_close, source.is_open
);