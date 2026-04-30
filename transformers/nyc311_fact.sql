-- Fact Table: NYC 311 Complaints

CREATE TABLE IF NOT EXISTS `lyrical-drive-439810-j7.Mage_Academy.fact_nyc311` (
    complaint_id STRING,
    created_date TIMESTAMP,
    agency_key STRING,
    complaint_type_key STRING,
    location_key STRING,
    status STRING,
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

MERGE `lyrical-drive-439810-j7.Mage_Academy.fact_nyc311` AS target
USING (
    SELECT 
        s.complaint_id,
        s.created_date,
        s.agency_key,
        s.complaint_type_key,
        s.location_key,
        s.status,
        s.incident_address,
        s.latitude,
        s.longitude,
        s.resolution_action_updated_date,
        s.closed_date,
        s.resolution_description,
        s.loaded_at,
        s.first_seen_date,
        s.last_updated_date,
        s.days_since_created,
        s.days_since_last_action,
        s.days_to_close,
        s.is_open
    FROM `lyrical-drive-439810-j7.Mage_Academy.silver_nyc311` s
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
    last_updated_date = source.last_updated_date,
    days_since_created = source.days_since_created,
    days_since_last_action = source.days_since_last_action,
    days_to_close = source.days_to_close,
    is_open = source.is_open

WHEN NOT MATCHED THEN INSERT (
    complaint_id, created_date, agency_key, complaint_type_key, location_key,
    status, incident_address, latitude, longitude,
    resolution_action_updated_date, closed_date, resolution_description,
    loaded_at, first_seen_date, last_updated_date,
    days_since_created, days_since_last_action, days_to_close, is_open
) VALUES (
    source.complaint_id, source.created_date, source.agency_key, 
    source.complaint_type_key, source.location_key,
    source.status, source.incident_address, source.latitude, source.longitude,
    source.resolution_action_updated_date, source.closed_date, source.resolution_description,
    source.loaded_at, source.first_seen_date, source.last_updated_date,
    source.days_since_created, source.days_since_last_action, source.days_to_close, source.is_open
);