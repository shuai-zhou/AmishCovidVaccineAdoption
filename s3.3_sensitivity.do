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
log using "$results/s3.3_sensitivity.log", replace

*==========================================================
* macro IVs
*==========================================================
local ivs amishpct evang_no_amish trump2020

*==========================================================
* daily model: all counties
*==========================================================
use "$data/resdata_daily.dta", clear

set seed 20230103
scalar rdm_num = floor(185640 *runiform() + 1)
dis rdm_num
scalar rdm_date = date[`rdm_num']
dis rdm_date

keep if date == "04/30/2021"

nbreg dr `ivs' i.b1.met, vce(robust)
// vif, uncentered
predict dr_predict if e(sample)
corr dr dr_predict if e(sample)
di r(rho) ^ 2

*==========================================================
* daily model: 1%
*==========================================================
use "$data/resdata_daily.dta", clear

set seed 20230103
scalar rdm = floor(185640 *runiform() + 1)
dis rdm // random number = 66649; date = 04/30/2021
keep if date == "04/30/2021"
drop if amishpct < 1

nbreg dr `ivs' i.b1.met, vce(robust)
// vif, uncentered
predict dr_predict if e(sample)
corr dr dr_predict if e(sample)
di r(rho) ^ 2

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

