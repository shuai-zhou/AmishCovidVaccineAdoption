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
log using "$results/s3.5_overdisp.log", replace

*==========================================================
* macro IVs
*==========================================================
local ivs amishpct evang_no_amish trump2020 hhincmed1000

*==========================================================
* test for over-dispersion using overdisp command
*==========================================================
use "$data/resdata_daily.dta", clear
overdisp dr `ivs' i.b1.met

use "$data/resdata_daily.dta", clear
drop if amishpct < 1
overdisp dr `ivs' i.b1.met

use "$data/resdata_weekly.dta", clear
overdisp wr `ivs' i.b1.met

use "$data/resdata_weekly.dta", clear
drop if amishpct < 1
overdisp wr `ivs' i.b1.met

use "$data/resdata_monthly.dta", clear
overdisp mr `ivs' i.b1.met

use "$data/resdata_monthly.dta", clear
drop if amishpct < 1
overdisp mr `ivs' i.b1.met

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

