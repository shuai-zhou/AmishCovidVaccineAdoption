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
log using "$results/s1.3_amishdata.log", replace

*==========================================================
* Amish population percentage
*==========================================================
import excel "$data/2020 USRC Group Detail_0.xlsx", firstrow case(lower) sheet("2020 Group by County") clear
compress
keep if groupname == "Amish Groups, undifferentiated"
rename fips countyfips
rename adherentsasoftotalpopulati amishpct
replace amishpct = amishpct * 100
gen fullname = countyname + ", " + statename
des, s

tempfile amish_pct
save `amish_pct'

*==========================================================
* Evangelical protestant
*==========================================================
import delimited "$data/EvangelicalProtestant.csv", clear
rename (county percent) (fullname evangpct)
keep fullname evangpct
des, s

tempfile evangpct
save `evangpct'

*==========================================================
* merge and save data
*==========================================================
use `amish_pct', clear
merge 1:1 fullname using `evangpct', gen(mg)
tab mg, mi
keep if mg == 3

keep countyfips countyname amishpct evangpct
order countyfips countyname amishpct evangpct
nmissing
des, s
sum
save "$data/amishdata.dta", replace

*==========================================================
* end logging
*==========================================================
log close _all

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

