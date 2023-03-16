*==========================================================
* Set up environment
*==========================================================
clear
set more off
macro drop _all
// set scheme lean1 // plotplain s2mono s1color s1mono lean1

cap cd "~/work/amishcovid/"
cap cd "F:/OneDrive - The Pennsylvania State University/Academic/Publication_Sub/AmishCovid202302_Census2020Pop/"
cap cd "C:/Users/sxz217/OneDrive - The Pennsylvania State University/Academic/Publication_Sub/AmishCovid202302_Census2020Pop/"
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
* randomly select date
*==========================================================
// set seed 20230103
// scalar rdm_num = floor(185640 *runiform() + 1)
// dis rdm_num
// scalar rdm_date = date[`rdm_num']
// dis rdm_date

*==========================================================
* select 01/19/2022
*==========================================================
** 01/19/2022 has the most weekly COVID cases
** see here: https://covid.cdc.gov/covid-data-tracker/#trends_weeklycases_select_00
use "$data/resdata_daily.dta", clear
unique countyfips // n = 357

keep if date == "01/19/2022"
unique countyfips // n = 357

tempfile daily_20220119
save `daily_20220119'

*==========================================================
* daily model: all counties
*==========================================================
use `daily_20220119', clear

sum dr
drop if dr < 0

nbreg dr `ivs' i.b1.met, vce(robust)
collin `ivs' met
outreg2 using "$results/nbreg_coef.doc", replace stats(coef se) ///
	label nodepvar ctitle("daily_all") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* daily model: 1%
*==========================================================
use `daily_20220119', clear
drop if amishpct < 1

sum dr
drop if dr < 0

nbreg dr `ivs' i.b1.met, vce(robust)
collin `ivs' met
outreg2 using "$results/nbreg_coef.doc", append stats(coef se) ///
	label nodepvar ctitle("daily_all") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* end logging
*==========================================================
// clear
log close _all

*==========================================================
* erase txt files
*==========================================================
cd "$results"
local txtfiles: dir . files "*.txt"
foreach txt of local txtfiles {
	erase `txt'
}

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

