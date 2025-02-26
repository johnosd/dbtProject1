
WITH
markup AS (
SELECT 
    *,
    first_value(customer_id)
        over(
            partition by company_name, contact_name 
            order by company_name
            rows between unbounded preceding and unbounded following
            ) as result
FROM {{source('sources','customers')}}
)
, removed as (
    SELECT Distinct result from markup
)
, final as (
select *
from {{source('sources','customers')}}
where customer_id in (
    Select result from removed)
)
Select * from final