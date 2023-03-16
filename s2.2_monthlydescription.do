*==========================================================
* Set up environment
*==========================================================
clear
set more off
macro drop _all
set scheme lean1 // plotplain s2mono s1color s1mono lean1

cap cd "F:/OneDrive - The Pennsylvania State University/Academic/Publication_Sub/AmishCovid202302_Census2020Pop/"
cap cd "C:/Users/sxz217/OneDrive - The Pennsylvania State University/Academic/Publication_Sub/AmishCovid202302_Census2020Pop/"
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
// pwcorr mr amishpct evang_no_amish trump2020, star(0.05)
// graph matrix mr amishpct evang_no_amish trump2020, half msymbol(Oh) msize(vsmall)

*==========================================================
* descriptive statistics
*==========================================================
// use "$data/resdata_monthly.dta", clear
// order countyfips monthly mr amishpct evang_no_amish colle trump2020 hhincmed1000 met
// local vars mr amishpct evang_no_amish colle trump2020 hhincmed1000 met
// outreg2 using "$results/descriptive_statistics.doc", replace label dec(2) sum(log) keep(`vars') eqkeep(N mean sd min max)

*==========================================================
* monthly vaccination rate
*==========================================================
// use "$data/resdata_monthly.dta", clear
// histogram mr, frequency ///
// 	xlabel(-0.2 "-0.2" -0.1 "-0.1" 0 "0.0" 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6" 0.7 "0.7" 0.8 "0.8" 0.9 "0.9" 1 "1.0") ///
// 	name(fig1, replace)
// graph export "$results/histo_mr.png", as(png) width(800) height(600) replace

// twoway (scatter mr monthly) (lfit mr monthly), name(fig2, replace)
// twoway (scatter mr monthly) (lfit mr monthly), by(amishpct4) name(fig3, replace)

*==========================================================
* Spearman's rank correlation
*==========================================================
** all sample
spearman mr amishpct, stats(rho p)
// pwcorr mr amishpct, obs sig

** top quarter, more Amish population
spearman mr amishpct if amishpct4 == 4, stats(rho p)
// pwcorr mr amishpct if amishpct4 == 4, obs sig

** bottom quarter, less Amish population
spearman mr amishpct if amishpct4 == 1, stats(rho p)
// pwcorr mr amishpct if amishpct4 == 1, obs sig

// ** rural counties
// spearman mr amishpct if met == 0, stats(rho p) // rural
// pwcorr mr amishpct if met == 0, obs sig

// ** urban counties
// spearman mr amishpct if met == 1, stats(rho p) // urban
// pwcorr mr amishpct if met == 1, obs sig

// *==========================================================
// * May 2022
// *==========================================================
// use "$data/resdata_monthly.dta", clear
// keep if month == 5 & year == 2022

// twoway (scatter mr amishpct if amishpct4 == 1) (lfit mr amishpct if amishpct4 == 1), ///
// 	title("(1) Bottom quartile of the Amish counties", size(medsmall)) ///
// 	legend(label(1 "Monthly vaccination rate") label(2 "Fitted line") row(1) size(small)) ///
// 	name(fig4, replace) saving("$results/fig4", replace)
// twoway (scatter mr amishpct if amishpct4 == 4) (lfit mr amishpct if amishpct4 == 4), ///
// 	title("(2) Top quartile of the Amish counties", size(medsmall)) ///
// 	legend(label(1 "Monthly vaccination rate") label(2 "Fitted line") row(1) size(small)) ///
// 	name(fig5, replace) saving("$results/fig5", replace)
// grc1leg "$results/fig4" "$results/fig5", ///
// 	l1title("Monthly vaccination rate", size(small))
// graph export "$results/mr_top_bottom.png", as(png) width(800) height(600) replace

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

