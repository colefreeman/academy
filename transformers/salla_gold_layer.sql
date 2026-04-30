CREATE TABLE IF NOT EXISTS `lyrical-drive-439810-j7`.`Mage_Academy`.`{{ insurance_provider }}_patients_prod`
(
    patient_id STRING,
    insurance_provider STRING,
    dob STRING,
    age INT64,
    diastolic_bp INT64,
    systolic_bp INT64,
    pulse INT64,
    height FLOAT64,
    weight FLOAT64,
    age_score INT64,
    bp_score INT64,
    pulse_score INT64,
    bmi_score INT64,
    health_score INT64,
    risk_label STRING
);

INSERT INTO `lyrical-drive-439810-j7`.`Mage_Academy`.`{{ insurance_provider }}_patients_prod`
(
    patient_id,
    insurance_provider,
    dob,
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
    risk_label
)
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
      END AS risk_label
FROM `lyrical-drive-439810-j7`.`Mage_Academy`.`stg_{{ insurance_provider }}_patients`
WHERE patient_id NOT IN (
    SELECT patient_id 
    FROM `lyrical-drive-439810-j7`.`Mage_Academy`.`{{ insurance_provider }}_patients_prod`
)