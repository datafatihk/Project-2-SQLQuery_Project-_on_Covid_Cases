--select * from CovidDeaths order by location

--select data that we are going to be using

select location,date,total_cases,new_cases,total_deaths,population 
from CovidDeaths
order by location,date --you can also use 1,2 for the first and second column for order by

--looking at Total Cases vs Total Deaths to see likelihood of dying if you contact covid in your country

select location,date,total_cases,total_deaths, round(((total_deaths/total_cases)*100),2) as 'Death Percentage'
from CovidDeaths
order by location,date

select location,date,total_cases,total_deaths, round(((total_deaths/total_cases)*100),2) as "Death Percentage"
from CovidDeaths
where location like '%states%'
order by location,date

--looking at total cases vs population to see percentage of covid-infected within population

select location,date,total_cases,population, round(((total_cases/population)*100),3) as "Case Percentage"
from CovidDeaths
order by location,date

--looking at countries with highest infection rate compared to population

select location,population,max(total_cases) as 'Highest Infection Count', max(round(((total_cases/population)*100),2)) as "Max Case Percentage"
from CovidDeaths
group by location,population
order by 'max case percentage' desc


--showing continents and countries with highest death count per population

select location,max(cast(total_deaths as int)) as 'Total Deaths'
from CovidDeaths
where continent is null
group by location
order by 'Total Deaths' desc

select location,max(cast(total_deaths as int)) as 'Total Deaths'
from CovidDeaths
group by location
order by 'Total Deaths' desc

select continent,max(cast(total_deaths as int)) as 'Total Deaths'
from CovidDeaths
where continent is not null
group by continent
order by 'Total Deaths' desc


--Global Numbers

select date, sum(new_cases) as totalnewcases,sum(cast(new_deaths as int)) as totalnewdeaths,round((sum(cast(new_deaths as int))/sum(new_cases))*100,2) as DeathPercentage
from CovidDeaths
where continent is not null
group by date

select sum(new_cases) as totalnewcases,sum(cast(new_deaths as int)) as totalnewdeaths,round((sum(cast(new_deaths as int))/sum(new_cases))*100,2) as DeathPercentage
from CovidDeaths
where continent is not null

--Total Population vs Vaccinations 

select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations ,sum(cast(cv.new_vaccinations as int)) over(partition by cd.location) as 'Country Partition'
from CovidDeaths as cd
join CovidVaccinations as cv
on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
order by 1,2,3

--Appointing CTE

With PopvsVac (continent,location,date,population,new_vaccination,CountryPartition)
As (
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations ,sum(cast(cv.new_vaccinations as int)) over(partition by cd.location) as CountryPartition
from CovidDeaths as cd
join CovidVaccinations as cv
on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
)
select * ,round((countrypartition/population)*100 as vacparticipation
from PopvsVac

-- Creating View to store data for later visualizations

create view PercentPopVac as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations ,sum(cast(cv.new_vaccinations as int)) over(partition by cd.location) as 'Country Partition'
from CovidDeaths as cd
join CovidVaccinations as cv
on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null


