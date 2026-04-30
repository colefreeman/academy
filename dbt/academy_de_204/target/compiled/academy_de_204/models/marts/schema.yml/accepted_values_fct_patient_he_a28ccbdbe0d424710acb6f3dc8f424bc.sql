
    
    

with all_values as (

    select
        health_risk as value_field,
        count(*) as n_records

    from "dev"."main"."fct_patient_health"
    group by health_risk

)

select *
from all_values
where value_field not in (
    'low','medium','high'
)


