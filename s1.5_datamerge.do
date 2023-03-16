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
log using "$results/s1.5_datamerge.log", replace

*==========================================================
* merge data
*==========================================================
use "$data/acs2020.dta", clear
merge 1:1 countyfips using "$data/amishdata.dta", gen(mg)
tab mg, mi
keep if mg == 3
drop mg

merge 1:1 countyfips using "$data/voting2020.dta", gen(mg)
tab mg, mi
keep if mg == 3
drop mg

merge 1:m countyfips using "$data/covid.dta", gen(mg)
tab mg, mi
keep if mg == 3
drop mg

*==========================================================
* save data
*==========================================================
** gen numeric county
destring countyfips, gen(countynum)

** gen time variable
gen datevar = date(date, "MDY", 2099)
format datevar %td
gen quarterly = qofd(datevar)
format quarterly %tq

gen month = month(datevar)
gen day = day(datevar)
gen year = year(datevar)
gen monthly = ym(year, month)
format monthly %tm
gen week = week(datevar)
gen weekly = yw(year, week)
format weekly %tw

** gen lag variable
sort countyfips datevar
by countyfips: gen vacnumlag = vacnum[_n-1]

** gen daily vaccination rate
gen dailynum = vacnum - vacnumlag
gen dr = dailynum / totpop * 100

** gen metro
gen met = 1 if metro == "Metro"
replace met = 0 if metro == "Non-metro"
label define met 1 "Metro" 0 "Non-metro"
label values met met
tab metro, mi
tab met, mi

** keep Amish county from Cory
keep if ///
	statename == "OH" | statename == "PA" | statename == "IN" | statename == "WI" | statename == "NY" | ///
	statename == "MI" | statename == "MO" | statename == "KY" | statename == "IA" | statename == "IL"

** generate Evangelical
** because the US Religion Census includes the Amish in the aggregated category “evangelical”
** their numbers should be subtracted from the category “evangelical”
gen evang_no_amish = evangpct - amishpct

** generate median income in 1000
gen hhincmed1000 = hhinc_med / 1000

** save data
compress
order countyfips date datevar day week weekly month monthly year ///
	vacnum vacnumlag dailynum ///
	dr totpop amishpct evang_no_amish colle hhincmed1000 trump2020 ///
	met countynum fullname
keep countyfips date datevar day week weekly month monthly year ///
	vacnum vacnumlag dailynum ///
	dr totpop amishpct evang_no_amish colle hhincmed1000 trump2020 ///
	met countynum fullname

label var dailynum "Daily vaccination person"
label var vacnum "Vaccination person"
label var vacnumlag "Lagged vaccination person"
label var dr "Daily Vaccination Rate"
label var amishpct "% Amish population"
label var evang_no_amish "% Evangelical protestant"
label var colle "% College graduate"
label var hhincmed1000 "Median household income (in $1,000)"
label var trump2020 "% Voting for Republican in 2020"
label var met "Metropolitan county"
label var totpop "Total population in 2020"

** keep 2021-02-01 to 2022-11-01
drop if datevar < date("01feb2021", "DMY")
drop if datevar > date("01nov2022", "DMY")
sum
save "$data/resdata.dta", replace

*==========================================================
* end logging
*==========================================================
log close _all

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

