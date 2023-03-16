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
log using "$results/s4.2_test_r2.log", replace

*==========================================================
* IMPORTANT TOTURIALS
*==========================================================
// https://www.stata.com/support/faqs/statistics/r-squared/
// https://www.statalist.org/forums/forum/general-stata-discussion/general/1498454-r-squared-negative-binomial
// https://www.statalist.org/forums/forum/general-stata-discussion/general/1638780-r2-for-xtnbreg-model
// https://stats.oarc.ucla.edu/stata/dae/negative-binomial-regression/
// https://www.statalist.org/forums/forum/general-stata-discussion/general/1351824-calculating-r2-with-xtpoisson

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
predict mr_predict if e(sample)
corr mr mr_predict if e(sample)
di r(rho) ^ 2

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

