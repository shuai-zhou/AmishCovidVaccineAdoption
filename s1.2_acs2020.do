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
log using "$results/s1.2_acs2020.log", replace

*==========================================================
* acs 2020
*==========================================================
clear
infile using "$data/R13253557.dct", using("$data/R13253557_SL050.txt")
compress
rename (FIPS NAME A00001_001) (countyfips acscounty totpop)
gen hhinc_med = A14006_001
gen hhinc_avg = A14008_001
gen colle = B12001_004 / B12001_001 * 100
gen fullname = QName
order countyfips fullname acscounty totpop hhinc* colle
keep countyfips fullname acscounty totpop hhinc* colle

*==========================================================
* merge population 2020 from census 2020
*==========================================================
merge 1:1 countyfips using "$data/pop2020.dta", gen(_mg)
tab _mg, mi
keep if _mg == 3
drop _mg

compare totpop pop2020
bro countyfips totpop pop2020
drop totpop
rename pop2020 totpop

 save "$data/acs2020.dta", replace

*==========================================================
* end logging
*==========================================================
log close _all

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

