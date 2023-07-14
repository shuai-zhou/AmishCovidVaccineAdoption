*==========================================================
* Set up environment
*==========================================================
clear
set more off
macro drop _all
set scheme lean1

cap cd "D:/AmishCovid/"
global data  = "$pwd" + "data"
global  results = "$pwd" + "results"

*==========================================================
* start logging
*==========================================================
log close _all
log using "$results/s3.4_nbreg.log", replace

*==========================================================
* macro IVs
*==========================================================
local ivs amishpct evang_no_amish trump2020 hhincmed1000

*==========================================================
* select 01/19/2022
*==========================================================
** 01/19/2022 has the most weekly COVID cases
** see here: https://covid.cdc.gov/covid-data-tracker/#trends_weeklycases_select_00
use "$data/resdata_daily.dta", clear
unique countyfips // n = 357

keep if date == "01/19/2022"
unique countyfips // n = 357

save "$data/resdata_daily_20220119.dta", replace
// tempfile daily_20220119
// save `daily_20220119'

*==========================================================
* daily model: all counties
*==========================================================
use "$data/resdata_daily_20220119.dta", clear
sum dr

nbreg dr `ivs' i.b1.met, vce(robust)
collin `ivs' met
return list

predict drhat
gen resid2 = (dr - drhat) ^ 2
gen ssr = sum(resid2)
egen drmean = mean(dr)
gen diff2 = (dr - drmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]

outreg2 using "$results/nbreg_coef.doc", replace stats(coef se) ///
	label nodepvar ctitle("daily_all") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* daily model: 1%
*==========================================================
use "$data/resdata_daily_20220119.dta", clear
drop if amishpct < 1

nbreg dr `ivs' i.b1.met, vce(robust)
collin `ivs' met
return list

predict drhat
gen resid2 = (dr - drhat) ^ 2
gen ssr = sum(resid2)
egen drmean = mean(dr)
gen diff2 = (dr - drmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]

outreg2 using "$results/nbreg_coef.doc", append stats(coef se) ///
	label nodepvar ctitle("daily_all") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* overdispersion test
*==========================================================
** all counties
use "$data/resdata_daily_20220119.dta", clear
sum dr
drop if dr < 0
overdisp dr `ivs' i.b1.met

** > 1% counties
use "$data/resdata_daily_20220119.dta", clear
drop if amishpct < 1
sum dr
drop if dr < 0
overdisp dr `ivs' i.b1.met

*==========================================================
* end logging
*==========================================================
// clear
log close _all

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

