
      
  
    
    

    create  table
      "dev"."main"."dim_patients_snapshot"
  
    as (
      
    

    select *,
        md5(coalesce(cast(patient_id as varchar ), '')
         || '|' || coalesce(cast(now()::timestamp as varchar ), '')
        ) as dbt_scd_id,
        now()::timestamp as dbt_updated_at,
        now()::timestamp as dbt_valid_from,
        
  
  coalesce(nullif(now()::timestamp, now()::timestamp), null)
  as dbt_valid_to

    from (
        



WITH source_data AS (
    SELECT
        patient_id,
        name,
        ssn,
        address,
        insurance_provider,
        dob,
        load_ts_utc
    FROM "dev"."main"."int_patient_metrics"
),

ranked_patients AS (
    SELECT
        patient_id,
        name,
        ssn,
        address,
        insurance_provider,
        dob,
        ROW_NUMBER() OVER (
            PARTITION BY patient_id 
            ORDER BY load_ts_utc DESC
        ) AS row_num
    FROM source_data
)

SELECT
    patient_id,
    name,
    ssn,
    address,
    insurance_provider,
    dob
FROM ranked_patients
WHERE row_num = 1

    ) sbq



    );
  
  
  