--select * 
--from [sql_portfolio]..[coved deaths]
--where continent <> ''
--order by 3,4

--select * 
--from [sql_portfolio]..[coved vac]
--order by 3,4

--select the data that we are going to use 

select location, date, total_cases, new_cases, total_deaths, population 
from [sql_portfolio]..[coved deaths]
order by 1,2

--looking at total cases vs total death

SELECT location, date, CONVERT(numeric,total_cases) as total_cases,CONVERT(numeric, total_deaths) as total_deaths, 
 (CONVERT(numeric, total_deaths)/CONVERT(numeric,total_cases))*100 AS death_percentage
FROM [sql_portfolio]..[coved deaths]
ORDER BY 1,2;


--total cases vs population

select location, date, CONVERT(numeric,total_cases) total_cases,
convert(numeric,population) population,
(CONVERT(numeric,total_cases)/convert(numeric,population))*100 infection_percentage
from [sql_portfolio]..[coved deaths]
order by 4,5 desc


--countries with highest infection rate compared to population 
 
SELECT location, max(total_cases) total_cases, population,
max((total_cases/population)*100) AS infection_percentage
FROM [sql_portfolio]..[coved deaths]
where continent <> ''
GROUP BY location, population
order by infection_percentage desc


--countries with highest death count per population 

SELECT location, max(total_deaths) total_deaths, population,
max((total_deaths/population)*100) AS death_percentage
FROM [sql_portfolio]..[coved deaths]
where continent <> ''
--where location = 'world'
GROUP BY location , population
order by total_deaths desc

--breakdown by continent

SELECT location, max(total_deaths) total_deaths

FROM [sql_portfolio]..[coved deaths]
where continent = ''
--where location = 'world'
GROUP BY location




-- global num 

SELECT date, CONVERT(numeric,SUM(new_cases)) AS total_cases,
CONVERT(numeric, SUM(new_deaths)) AS total_deaths,
(CONVERT(numeric, SUM(new_deaths)) / CONVERT(numeric,SUM(new_cases)))*100 AS death_percentage
FROM [sql_portfolio]..[coved deaths]

GROUP BY date
 having sum(new_cases) <>0 and SUM(new_deaths) <> 0
ORDER BY 1,2;

--total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location ORDER BY dea.location ,
dea.date) as RollingPeoplevaccinated
from [sql_portfolio].[dbo].[coved deaths] dea
join[sql_portfolio].[dbo].[coved vac] vac
	on dea.location = vac.location 
	and dea.date = vac.date
	where dea.continent <> ''
	ORDER BY 1,2,3
	
--use cte

with pop_vs_vac (continent , location , date , population , new_vaccinations, RollingPeoplevaccinated )
	as 
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location ORDER BY dea.location ,
dea.date) as RollingPeoplevaccinated
from [sql_portfolio].[dbo].[coved deaths] dea
join[sql_portfolio].[dbo].[coved vac] vac
	on dea.location = vac.location 
	and dea.date = vac.date
	where dea.continent <> ''
	)
select *, (RollingPeoplevaccinated/population)*100
from pop_vs_vac


-- temp table 
drop table if exists #rolling_percentage
create table #rolling_percentage
(continent nvarchar (255) , location nvarchar (255) , date nvarchar (255) , population numeric , new_vaccinations numeric , RollingPeoplevaccinated numeric )

insert into #rolling_percentage
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location ORDER BY dea.location ,
dea.date) as RollingPeoplevaccinated
from [sql_portfolio].[dbo].[coved deaths] dea
join[sql_portfolio].[dbo].[coved vac] vac
	on dea.location = vac.location 
	and dea.date = vac.date
	where dea.continent <> ''
select *, (RollingPeoplevaccinated/population)*100
from #rolling_percentage


--creating view

create view breakdownBYcontinent as
(SELECT location, max(total_deaths) total_deaths

FROM [sql_portfolio]..[coved deaths]
where continent = ''
--where location = 'world'
GROUP BY location)
select *
from breakdownBYcontinent







--alter table [sql_portfolio].[dbo].[coved deaths]
--alter column date date




