
  
  create view "dev"."main"."stg_medical_patients__dbt_tmp" as (
    -- models/staging/stg_medical_patients.sql



WITH source_data as (
    SELECT
        patient_id,
        name,
        ssn,
        address,
        insurance_provider,
        dob,
        diastolic_bp,
        systolic_bp,
        pulse,
        height,
        weight,
        age,
        age_score,
        bp_score,
        pulse_score,
        bmi_score,
        health_score,
        '2025-11-14 16:13:07.563326+00:00' AS load_ts_utc
    FROM 
        "dev"."main"."mage_academy_mage_pro___dbt__fetch_medical_data"
),

hashed_keys AS (
    SELECT
        md5(cast(coalesce(cast(patient_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(load_ts_utc as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS score_hkey,
        md5(cast(coalesce(cast(patient_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(name as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(ssn as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(dob as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS score_hdiff,
        *
    FROM source_data
)

SELECT *
FROM hashed_keys
  );
