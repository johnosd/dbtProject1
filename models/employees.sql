WITH 
calc_employees AS (
SELECT 
    date_part('year', current_date) - date_part('year', birth_date) age,
    date_part('year', current_date) - date_part('year', hire_date) lenghtofservice,
    first_name ||' '|| last_name name,
    * 
FROM {{source("sources","employees")}}
)
SELECT * FROM calc_employees