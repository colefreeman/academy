
    
    

with child as (
    select patient_id as from_field
    from "dev"."main"."fct_patient_health"
    where patient_id is not null
),

parent as (
    select patient_id as to_field
    from "dev"."main"."int_patient_metrics"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


