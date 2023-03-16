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
log using "$results/s4.1_test_vif.log", replace

*==========================================================
* macro IVs
*==========================================================
local ivs amishpct evang_no_amish trump2020

*==========================================================
* monthly model: all counties
*==========================================================
use "$data/resdata_monthly.dta", clear
xtset countynum monthly

xtnbreg mr `ivs' i.b1.met, pa vce(robust)
vif, uncentered

*==========================================================
* monthly model: 1%
*==========================================================
use "$data/resdata_monthly.dta", clear
drop if amishpct < 1
xtset countynum monthly

xtnbreg mr `ivs' i.b1.met, pa vce(robust)
vif, uncentered

*==========================================================
* end logging
*==========================================================
clear
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

