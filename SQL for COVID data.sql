select *
from PortfolioProject..CovidDeath$
Order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeath$
order by 1,2

select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath$
where location like '%Australia%'
order by 1,2

select Location, date, total_cases,population, total_cases, (total_cases/population)*100 as DeathPercentage
from PortfolioProject..CovidDeath$
where location like '%Australia%'
order by 1,2


select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeath$
Group by Location, Population
order by PercentPopulationInfected Desc

select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeath$
Where continent is not null
Group by Location
order by TotalDeathCount Desc

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeath$
Where continent is null
Group by location
order by TotalDeathCount Desc

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeath$
where continent is not null
Group by date
order by 1,2


With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Convert(int,vac.new_vaccinations)) OVER(partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath$ dea
Join PortfolioProject..CovidVaccinations$ vac
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent varchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Convert(int,vac.new_vaccinations)) OVER(partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath$ dea
Join PortfolioProject..CovidVaccinations$ vac
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(Convert(int,vac.new_vaccinations)) OVER(partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath$ dea
Join PortfolioProject..CovidVaccinations$ vac
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated