{{
    config(
        materialized='view',
        schema={{block_output('medical_to_bq', parse=lambda x, _: x['insurance_provider'])}},
        tags=['staging', 'CareGuard', 'HealthPlus', 'MediTrust', 'SecureCare', 'WellnessFirst']
    )
}}

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
FROM {{ source('mage_academy', {{block_output('medical_to_bq', parse=lambda x, _: x['insurance_provider'])}} ~ '_patients') }}
WHERE insurance_provider = '{{block_output("medical_to_bq", parse=lambda x, _: x["insurance_provider"])}'