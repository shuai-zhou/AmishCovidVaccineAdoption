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
log using "$results/s3.1_xtnbreg_coef.log", replace

*==========================================================
* tutorials
*==========================================================
** Non-negative Continuous Right-skewed Panel Data
** https://www.statalist.org/forums/forum/general-stata-discussion/general/1590559-non-negative-continuous-right-skewed-zero-inflated-panel-data-analysis

** Negative Binomial Regression
** https://stats.oarc.ucla.edu/stata/dae/negative-binomial-regression/

** Model A Continuous DV With [0, ∞] Range
** https://stats.stackexchange.com/questions/142134/how-should-i-model-a-continuous-dependent-variable-in-the-0-infty-range

*==========================================================
* macro IVs
*==========================================================
// local ivs amishpct evang_no_amish colle trump2020 hhincmed1000

local ivs amishpct evang_no_amish trump2020 hhincmed1000

// *==========================================================
// * compile median and average hhinc in 2020
// *==========================================================
// infile using "$data/R13277287.dct", using("$data/R13277287_SL050.txt")
// rename FIPS countyfips
// rename A14006_001 hhincmed2020
// rename A14008_001 hhincavg2020
// gen hhincmed_1000_2020 = hhincmed2020 / 1000
// gen hhincavg_1000_2020 = hhincavg2020 / 1000
// keep countyfips hhinc*

// tempfile hhinc2020
// save `hhinc2020'

*==========================================================
* daily model: all counties
*==========================================================
use "$data/resdata_daily.dta", clear

xtset countynum datevar

xtnbreg dr `ivs' i.b1.met, pa vce(robust)
collin `ivs' met
return list

predict drhat
gen resid2 = (dr - drhat) ^ 2
gen ssr = sum(resid2)
egen drmean = mean(dr)
gen diff2 = (dr - drmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]

outreg2 using "$results/xtnbreg_coef.doc", replace stats(coef se) ///
	label nodepvar ctitle("daily_all") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* daily model: 1%
*==========================================================
use "$data/resdata_daily.dta", clear
drop if amishpct < 1
xtset countynum datevar

xtnbreg dr `ivs' i.b1.met, pa vce(robust)
collin `ivs' met
return list

predict drhat
gen resid2 = (dr - drhat) ^ 2
gen ssr = sum(resid2)
egen drmean = mean(dr)
gen diff2 = (dr - drmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]

outreg2 using "$results/xtnbreg_coef.doc", append stats(coef se) ///
	label nodepvar ctitle("daily_1%") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* weekly model: all counties
*==========================================================
use "$data/resdata_weekly.dta", clear
xtset countynum weekly

xtnbreg wr `ivs' i.b1.met, pa vce(robust)
collin `ivs' met
return list

predict wrhat
gen resid2 = (wr - wrhat) ^ 2
gen ssr = sum(resid2)
egen wrmean = mean(wr)
gen diff2 = (wr - wrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]

outreg2 using "$results/xtnbreg_coef.doc", append stats(coef se) ///
	label nodepvar ctitle("weekly_all") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* weekly model: 1%
*==========================================================
use "$data/resdata_weekly.dta", clear
drop if amishpct < 1
xtset countynum weekly

xtnbreg wr `ivs' i.b1.met, pa vce(robust)
collin `ivs' met
return list

predict wrhat
gen resid2 = (wr - wrhat) ^ 2
gen ssr = sum(resid2)
egen wrmean = mean(wr)
gen diff2 = (wr - wrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]

outreg2 using "$results/xtnbreg_coef.doc", append stats(coef se) ///
	label nodepvar ctitle("weekly_1%") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* monthly model: all counties
*==========================================================
use "$data/resdata_monthly.dta", clear
xtset countynum monthly

xtnbreg mr `ivs' i.b1.met, pa vce(robust)
collin `ivs' met
return list

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]

outreg2 using "$results/xtnbreg_coef.doc", append stats(coef se) ///
	label nodepvar ctitle("monthly_all") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

*==========================================================
* monthly model: 1%
*==========================================================
use "$data/resdata_monthly.dta", clear
drop if amishpct < 1
xtset countynum monthly

xtnbreg mr `ivs' i.b1.met, pa vce(robust)
collin `ivs' met
return list

predict mrhat
gen resid2 = (mr - mrhat) ^ 2
gen ssr = sum(resid2)
egen mrmean = mean(mr)
gen diff2 = (mr - mrmean) ^ 2
egen sst = sum(diff2)
dis 1 - ssr[_N] / sst[_N]

outreg2 using "$results/xtnbreg_coef.doc", append stats(coef se) ///
	label nodepvar ctitle("monthly_1%") ///
	dec(3) alpha(0.001, 0.01, 0.05, 0.10) symbol(***, **, *, +)

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

