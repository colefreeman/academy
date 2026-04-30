{{
    config(
        materialized='table',
        schema=block_output(1)["insurance_provider"].lower() ~ '_prod',
        tags=['prod', 'CareGuard', 'HealthPlus', 'MediTrust', 'SecureCare', 'WellnessFirst']
    )
}}

{% set provider_schema = block_output(1)["insurance_provider"].lower() %}

SELECT
    patient_id
    , insurance_provider
    , dob
    , age
    , diastolic_bp
    , systolic_bp
    , pulse
    , height
    , weight
    , age_score
    , bp_score
    , pulse_score
    , bmi_score
    , health_score
    , CASE
        WHEN health_score = 0             THEN 'high risk'
        WHEN health_score BETWEEN 1 AND 2 THEN 'medium risk'
        ELSE                                   'low risk'
      END                                 AS risk_label
FROM {{ provider_schema }}.medical_patients
WHERE insurance_provider = '{{ block_output(1)["insurance_provider"] }}'