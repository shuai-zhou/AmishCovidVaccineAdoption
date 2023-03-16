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
log using "$results/s2.1_dailyweeklymonthly.log", replace

*==========================================================
* daily vaccination rate
*==========================================================
use "$data/resdata.dta", clear
keep countyfips date datevar year dr ///
	amishpct evang_no_amish colle hhincmed1000 trump2020 met countynum fullname day week month year
egen amishpct4 = xtile(amishpct), nq(4)
compress
save "$data/resdata_daily.dta", replace

*==========================================================
* weekly vaccination rate
*==========================================================
** county data
use "$data/resdata.dta", clear
keep countyfips weekly amishpct evang_no_amish colle hhincmed1000 trump2020 met countynum fullname day week month year
bysort countyfips weekly: gen var1 = _n
keep if var1 == 1
drop var1
egen amishpct4 = xtile(amishpct), nq(4)
tempfile county_data_weekly
save `county_data_weekly'

** weekly vaccination data
** see how to calculate weighted average using "collapse"
** https://stackoverflow.com/questions/37764573/weighted-average-in-statas-collapse-command
use "$data/resdata.dta", clear
keep countyfips weekly dr totpop
collapse (mean) wr = dr [w=totpop], by(countyfips weekly)
tempfile vac_weekly
save `vac_weekly'

** merge county and weekly vaccination data
use `county_data_weekly', clear
merge 1:1 countyfips weekly using `vac_weekly', gen(mg)
tab mg, mi
drop mg
label variable wr "Weekly vaccination rate"
order countyfips weekly wr

compress
save "$data/resdata_weekly.dta", replace

*==========================================================
* monthly vaccination rate
*==========================================================
** county data
use "$data/resdata.dta", clear
keep countyfips monthly amishpct evang_no_amish colle hhincmed1000 trump2020 met countynum fullname day week month year
bysort countyfips monthly: gen var1 = _n
keep if var1 == 1
drop var1
egen amishpct4 = xtile(amishpct), nq(4)
tempfile county_data_monthly
save `county_data_monthly'

** monthly vaccination data
** see how to calculate weighted average using "collapse"
** https://stackoverflow.com/questions/37764573/weighted-average-in-statas-collapse-command
use "$data/resdata.dta", clear
keep countyfips monthly dr totpop
collapse (mean) mr = dr [w=totpop], by(countyfips monthly)
tempfile vac_monthly
save `vac_monthly'

** merge county and monthly vaccination data
use `county_data_monthly', clear
merge 1:1 countyfips monthly using `vac_monthly', gen(mg)
tab mg, mi
drop mg
label variable mr "Monthly vaccination rate"
order countyfips monthly mr

compress
save "$data/resdata_monthly.dta", replace

*==========================================================
* end logging
*==========================================================
log close _all

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

