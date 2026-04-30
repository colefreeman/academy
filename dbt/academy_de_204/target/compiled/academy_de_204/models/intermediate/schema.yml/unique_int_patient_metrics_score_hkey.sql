
    
    

select
    score_hkey as unique_field,
    count(*) as n_records

from "dev"."main"."int_patient_metrics"
where score_hkey is not null
group by score_hkey
having count(*) > 1


