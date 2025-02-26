
WITH
prod as (
    select
        ct.category_name,
        sp.company_name suppliers,
        pd.product_name,
        pd.unit_price,
        pd.product_id

    from {{source("sources","products")}} pd
    left join {{source("sources","suppliers")}} sp on sp.supplier_id = pd.supplier_id
    left join {{source("sources","categories")}} ct on ct.category_id = pd.category_id
)
, orddetail as (
    select
        pd.*,
        od.order_id,
        od.quantity,
        od.discount
    from {{ref("orderdetails")}} od
    left join prod pd on od.product_id = pd.product_id
)

, ordrs as (
    Select 
        ord.order_date,
        ord.order_id,
        cs.company_name customer,
        em.name employee,
        em.age,
        em.lenghtofservice
    from {{source("sources","orders")}} ord
    LEFT JOIN {{ref("customers")}} cs on ord.customer_id = cs.customer_id
    LEFT JOIN {{ref("employees")}} em on ord.employee_id = em.employee_id
    LEFT JOIN {{source("sources","shippers")}} sh on ord.ship_via = sh.shipper_id
)
, finaljoin as (
    select 
        od.*,
        ord.order_date,
        ord.customer,
        ord.employee,
        ord.age,
        ord.lenghtofservice
    from orddetail od
    inner join ordrs ord on (od.order_id = ord.order_id)
)

SELECT * FROM finaljoin
