CREATE TABLE IF NOT EXISTS `lyrical-drive-439810-j7`.`Mage_Academy`.`stg_{{ block_output(1)[0]['insurance_provider'] }}_patients` AS

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
FROM `lyrical-drive-439810-j7`.`Mage_Academy`.`{{ block_output(1)[0]['insurance_provider'] }}_patients`;

SELECT
    insurance_provider
    , COUNT(*) AS row_count
    , CONCAT('lyrical-drive-439810-j7.Mage_Academy.stg_', insurance_provider, '_patients') AS table_id
FROM `lyrical-drive-439810-j7`.`Mage_Academy`.`stg_{{ block_output(1)[0]['insurance_provider'] }}_patients`
GROUP BY insurance_provider