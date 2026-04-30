

  create or replace view `lyrical-drive-439810-j7`.`Mage_Academy_BRONZE`.`chi_crimes_bronze`
  OPTIONS()
  as 

WITH src_data_crimes AS (
    SELECT
        id AS crimes_id,                      -- NUMBER
        case_number AS case_number,           -- TEXT
        arrest_date AS crime_date,            -- DATETIME
        block AS address,                     -- TEXT
        iucr AS iucr,                         -- TEXT
        primary_type AS crime_type,           -- TEXT
        description AS crime_description,     -- TEXT
        location_description AS location_description, -- TEXT
        arrest AS arrest_made,                -- BOOLEAN
        beat AS beat,                         -- NUMBER
        district AS district,                 -- NUMBER
        ward AS ward,                         -- NUMBER
        community_area AS community_area,     -- NUMBER
        fbi_code AS fbi_code,                 -- TEXT
        arrest_year AS arrest_year,           -- NUMBER
        TIMESTAMP(updated_on) AS last_source_update,  -- TIMESTAMP
        lat AS lat,                           -- NUMBER
        lng AS lng,                           -- NUMBER
        updated_on,                           -- DATETIME
        'SOURCE_CRIME_DATA.CRIMES' AS record_source
    FROM `lyrical-drive-439810-j7`.`Mage_Academy`.`mage_mage_academy_dbt_fetch_chicago_crimes_data`
),

hashed_keys AS (
    SELECT
        to_hex(md5(cast(coalesce(cast(crimes_id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(case_number as string), '_dbt_utils_surrogate_key_null_') as string))) AS crimes_hkey,
        to_hex(md5(cast(coalesce(cast(crimes_id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(case_number as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(lat as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(lng as string), '_dbt_utils_surrogate_key_null_') as string))) AS crimes_hdiff,
        *,
        '2025-12-09 00:01:13.407327+00:00' AS load_ts_utc
    FROM src_data_crimes
)

SELECT *
FROM hashed_keys;

