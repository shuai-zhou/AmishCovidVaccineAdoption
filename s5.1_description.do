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
log using "$results/s5.1_description.log", replace

*==========================================================
* read data and generate time variables
*==========================================================
use "$data/covid.dta", clear

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

order countyfips date year monthly weekly

keep if countyfips == "39075" // Holmes County, Ohio
keep if countyfips == "18087" // LaGrange County, Indiana
sort year monthly weekly day

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

