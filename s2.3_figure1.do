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
log using "$results/s2.3_figure1.log", replace

*==========================================================
* histogram plot of monthly vaccination rate
*==========================================================
use "$data/resdata_monthly.dta", clear
sum mr
histogram mr, frequency ///
	xlabel(0 "0.0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6" 0.7 "0.7" 0.8 "0.8" 0.9 "0.9" 1 "1.0" 1.1 "1.1") ///
	name(fig1, replace)
graph export "$results/histo_mr.png", as(png) width(800) height(600) replace


// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

