
    
    

select
    score_hkey as unique_field,
    count(*) as n_records

from "dev"."main"."fct_patient_health"
where score_hkey is not null
group by score_hkey
having count(*) > 1


