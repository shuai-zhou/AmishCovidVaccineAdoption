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
log using "$results/s2.2_monthlydescription.log", replace

*==========================================================
* correlation matrix
*==========================================================
use "$data/resdata_monthly.dta", clear
pwcorr colle hhincmed1000, star(0.05)
pwcorr colle trump2020, star(0.05)

*==========================================================
* descriptive statistics
*==========================================================
use "$data/resdata_monthly.dta", clear
unique countyfips

order countyfips monthly mr amishpct evang_no_amish colle trump2020 hhincmed1000 met
local vars mr amishpct evang_no_amish colle trump2020 hhincmed1000 met
outreg2 using "$results/descriptive_statistics.doc", replace label dec(2) sum(log) keep(`vars') eqkeep(N mean sd min max)

*==========================================================
* Spearman's rank correlation
*==========================================================
** read data
use "$data/resdata_monthly.dta", clear

** all sample
spearman mr amishpct, stats(rho p)
// pwcorr mr amishpct, obs sig

** top quarter, more Amish population
spearman mr amishpct if amishpct4 == 4, stats(rho p)
// pwcorr mr amishpct if amishpct4 == 4, obs sig

** bottom quarter, less Amish population
spearman mr amishpct if amishpct4 == 1, stats(rho p)
// pwcorr mr amishpct if amishpct4 == 1, obs sig


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

