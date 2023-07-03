--ALTER TABLE ds_salaries
--alter COLUMN salary_in_usd int ;
-- step 1 : cleaning data by deleting salary and salary currency columns--

select salary , salary_currency
from ds_salaries



--ALTER TABLE ds_salaries
--DROP COLUMN salary , salary_currency;

select *
from ds_salaries

--step 2 : start the analysis
--what's the AVG salary for euch experience level of job title

SELECT job_title, AVG(salary_in_usd) as avg_salary , experience_level
FROM ds_salaries
--where job_title = 'Analytics Engineer'
GROUP BY  experience_level  , job_title
ORDER by experience_level

--what is The highest paid country
select company_location , sum(salary_in_usd) as sum_of_salary
from [dbo].[ds_salaries]
group by company_location
order by sum(salary_in_usd) desc

-- the highest country in avg salary

select company_location , avg(salary_in_usd) as AVG_of_salary
from [dbo].[ds_salaries]
group by company_location
order by avg (salary_in_usd) desc


-- avg and sum of salary for company size 

select company_size , avg(salary_in_usd) as AVG_of_salary
from [dbo].[ds_salaries]
group by company_size
order by avg (salary_in_usd) desc

select company_size , sum(salary_in_usd) as SUM_of_salary
from [dbo].[ds_salaries]
group by company_size
order by sum (salary_in_usd) desc

-- salary for employment_type and remote_ratio

select employment_type , remote_ratio , avg(salary_in_usd) as AVG_Salary
from [dbo].[ds_salaries]
group by employment_type , remote_ratio
order by avg(salary_in_usd) desc

--industry growth

select work_year , sum(salary_in_usd) as sum_of_salary
from [dbo].[ds_salaries]
group by work_year
order by work_year