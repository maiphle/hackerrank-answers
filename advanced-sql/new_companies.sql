SET NOCOUNT ON;
/*
company_code,
founder_name,
total_number_lead_mgr,
total_number_senior_mgr,
total_number_mgr,
total_number_employees
order by company_code asc -- company code ie. C_1, C_10, C_2
*/
with lm as (
    select 
    company_code,
    count(distinct lead_manager_code) total_number_lead_mgr
    from lead_manager
    group by company_code
), sr as (
    select 
    company_code,
    count(distinct senior_manager_code) total_number_senior_mgr
    from senior_manager
    group by company_code
), mgr as (
    select 
    company_code,
    count(distinct manager_code) total_number_mgr
    from manager
    group by company_code
), emp as (
    select 
    company_code,
    count(distinct employee_code) total_number_employees
    from employee
    group by company_code
)
select 
co.company_code,
co.founder founder_name,
lm.total_number_lead_mgr,
sr.total_number_senior_mgr,
mgr.total_number_mgr,
emp.total_number_employees
from company co
left join lm on co.company_code = lm.company_code
left join sr on co.company_code = sr.company_code
left join mgr on co.company_code = mgr.company_code
left join emp on co.company_code = emp.company_code
order by co.company_code asc;
/*
Enter your query here.
Please append a semicolon ";" at the end of the query and enter your query in a single line to avoid error.
*/

go