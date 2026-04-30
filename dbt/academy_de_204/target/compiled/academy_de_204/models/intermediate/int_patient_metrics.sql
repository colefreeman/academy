-- models/intermediate/int_patient_metrics.sql



WITH base_patients AS (
    SELECT
        score_hkey,
        patient_id,
        load_ts_utc,
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
        health_score
    FROM "dev"."main"."stg_medical_patients"
    
    
),

add_health_risk AS (
    SELECT
        *,
        CASE
            WHEN health_score <= 3 THEN 'high'
            WHEN health_score BETWEEN 4 AND 7 THEN 'medium'
            ELSE 'low'
        END AS health_risk
    FROM base_patients
)

SELECT * FROM add_health_risk