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
log using "$results/s1.5_amishpct.log", replace

*==========================================================
* voting data 2020
*==========================================================
import delimited "$data/countypres_2000-2020.csv", clear
rename county_fips countyfips
keep if year == 2020
drop if countyfips == "NA"
keep if candidate == "DONALD J TRUMP"
keep countyfips candidatevotes totalvotes mode

gen mode_no_space = subinstr(mode," ","",.) // remove space from mode
gen modes = subinstr(mode_no_space, "-","",.) // remove dash from mode_no_space
drop mode mode_no_space
rename candidatevotes nvotes
reshape wide nvotes totalvotes, i(countyfips) j(modes, string)

drop if totalvotesTOTAL == "NA"
foreach v of varlist nvotes2NDABSENTEE-totalvotesTOTAL {
	destring `v', replace
}
gen status = 0
replace status = 1 if nvotesTOTAL != .

rename nvotesTOTAL ntotal
gen trump2020 = ntotal / totalvotesTOTAL * 100 if status == 1

egen rowsum = rowtotal(nvotes*)
replace trump2020 = rowsum / totalvotesPROVISIONAL * 100 if status == 0
replace trump2020 = rowsum / totalvotesPROV * 100 if status == 0 & trump2020 == .
replace trump2020 = rowsum / totalvotesELECTIONDAY * 100 if status == 0 & trump2020 == .
nmissing trump2020

order countyfips trump2020
keep countyfips trump2020
save "$data/voting2020.dta", replace

*==========================================================
* end logging
*==========================================================
log close _all

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

