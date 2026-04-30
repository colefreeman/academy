
    
    

with child as (
    select dbt_scd_id as from_field
    from "dev"."main"."fct_patient_health"
    where dbt_scd_id is not null
),

parent as (
    select dbt_scd_id as to_field
    from "dev"."main"."dim_patients_snapshot"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


