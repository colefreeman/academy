
  
    
    

    create  table
      "dev"."main"."fct_patient_health"
  
    as (
      -- models/marts/healthcare/fct_patient_health.sql



WITH patient_metrics AS (
    SELECT
        score_hkey,
        patient_id,
        CAST(load_ts_utc AS TIMESTAMP) AS load_ts_utc,
        age,
        diastolic_bp,
        systolic_bp,
        pulse,
        height,
        weight,
        age_score,
        bp_score,
        pulse_score,
        bmi_score,
        health_score,
        health_risk
    FROM "dev"."main"."int_patient_metrics"
    
    
)

SELECT
    pm.score_hkey,
    pm.patient_id,
    dp.dbt_scd_id,
    pm.load_ts_utc,
    pm.age,
    pm.diastolic_bp,
    pm.systolic_bp,
    pm.pulse,
    pm.height,
    pm.weight,
    pm.age_score,
    pm.bp_score,
    pm.pulse_score,
    pm.bmi_score,
    pm.health_score,
    pm.health_risk
FROM patient_metrics pm
INNER JOIN "dev"."main"."dim_patients_snapshot" dp
    ON pm.patient_id = dp.patient_id
    AND dp.dbt_valid_to IS NULL
    );
  
  
  