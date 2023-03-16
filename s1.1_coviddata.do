*==========================================================
* Set up environment
*==========================================================
clear
set more off
macro drop _all
// set scheme lean1 // plotplain s2mono s1color s1mono lean1

cap cd "F:/OneDrive - The Pennsylvania State University/Academic/Publication_Sub/AmishCovid202302_Census2020Pop/"
cap cd "C:/Users/sxz217/OneDrive - The Pennsylvania State University/Academic/Publication_Sub/AmishCovid202302_Census2020Pop/"
global data  = "$pwd" + "data"
global  results = "$pwd" + "results"

*==========================================================
* start logging
*==========================================================
log close _all
log using "$results/s1.1_coviddata.log", replace

*==========================================================
* covid data
*==========================================================
** read data
import delimited "$data/COVID-19_Vaccinations_in_the_United_States_County.csv", clear
compress
drop if fips == "UNK"
rename (fips recip_county recip_state series_complete_yes series_complete_pop_pct metro_status census2019) ///
	(countyfips countyname statename vacnum vacpct metro pop)
keep date countyfips countyname statename vacnum vacpct metro pop
foreach v of varlist _all {
	label variable `v' ""
}

** save data
save "$data/covid.dta", replace

*==========================================================
* end logging
*==========================================================
log close _all

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

