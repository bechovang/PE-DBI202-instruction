select 
ORD.staff_id,
STA.first_name,
STA.last_name

from 
orders ORD

join
staffs STA on STA.staff_id = ORD.staff_id

join
customers CUS on CUS.customer_id = ORD.customer_id

WHERE
CUS.state like 'CA'