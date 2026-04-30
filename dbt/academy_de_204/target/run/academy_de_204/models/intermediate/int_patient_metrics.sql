
        
            delete from "dev"."main"."int_patient_metrics"
            where (
                score_hkey) in (
                select (score_hkey)
                from "int_patient_metrics__dbt_tmp20251114162254984429"
            );

        
    

    insert into "dev"."main"."int_patient_metrics" ("score_hkey", "patient_id", "load_ts_utc", "name", "ssn", "address", "insurance_provider", "dob", "diastolic_bp", "systolic_bp", "pulse", "height", "weight", "age", "age_score", "bp_score", "pulse_score", "bmi_score", "health_score", "health_risk")
    (
        select "score_hkey", "patient_id", "load_ts_utc", "name", "ssn", "address", "insurance_provider", "dob", "diastolic_bp", "systolic_bp", "pulse", "height", "weight", "age", "age_score", "bp_score", "pulse_score", "bmi_score", "health_score", "health_risk"
        from "int_patient_metrics__dbt_tmp20251114162254984429"
    )
  