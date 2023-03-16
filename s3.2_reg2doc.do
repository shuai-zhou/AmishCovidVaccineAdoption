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
log using "$results/s3.2_reg2doc.log", replace

*==========================================================
* daily model: all counties
*==========================================================
** read regression results
import excel "$data/xtnbreg_irr.xlsx", firstrow case(lower) sheet("daily_all") clear

** generate SIG level
gen sig = "***" if pval < 0.001
replace sig = "**" if pval >= 0.001 & pval < 0.01
replace sig = "*" if pval >= 0.01 & pval < 0.05
replace sig = "+" if pval >= 0.05 & pval < 0.1

** format IRR and STDERR and keep three decimals
gen irr3 = string(real(string(round(irr, 0.001))), "%05.3f")
gen stderr3 = string(real(string(round(stderr, 0.001))), "%05.3f")

** concatenate IRR and SIG
gen irr_sig = irr3 + sig

** order variables
order var irr_sig stderr3

*==========================================================
* daily model: 1%
*==========================================================
** read regression results
import excel "$data/xtnbreg_irr.xlsx", firstrow case(lower) sheet("daily_1pct") clear

** generate SIG level
gen sig = "***" if pval < 0.001
replace sig = "**" if pval >= 0.001 & pval < 0.01
replace sig = "*" if pval >= 0.01 & pval < 0.05
replace sig = "+" if pval >= 0.05 & pval < 0.1

** format IRR and STDERR and keep three decimals
gen irr3 = string(real(string(round(irr, 0.001))), "%05.3f")
gen stderr3 = string(real(string(round(stderr, 0.001))), "%05.3f")

** concatenate IRR and SIG
gen irr_sig = irr3 + sig

** order variables
order var irr_sig stderr3

*==========================================================
* weekly model: all counties
*==========================================================
** read regression results
import excel "$data/xtnbreg_irr.xlsx", firstrow case(lower) sheet("weekly_all") clear

** generate SIG level
gen sig = "***" if pval < 0.001
replace sig = "**" if pval >= 0.001 & pval < 0.01
replace sig = "*" if pval >= 0.01 & pval < 0.05
replace sig = "+" if pval >= 0.05 & pval < 0.1

** format IRR and STDERR and keep three decimals
gen irr3 = string(real(string(round(irr, 0.001))), "%05.3f")
gen stderr3 = string(real(string(round(stderr, 0.001))), "%05.3f")

** concatenate IRR and SIG
gen irr_sig = irr3 + sig

** order variables
order var irr_sig stderr3

*==========================================================
* weekly model: 1%
*==========================================================
** read regression results
import excel "$data/xtnbreg_irr.xlsx", firstrow case(lower) sheet("weekly_1pct") clear

** generate SIG level
gen sig = "***" if pval < 0.001
replace sig = "**" if pval >= 0.001 & pval < 0.01
replace sig = "*" if pval >= 0.01 & pval < 0.05
replace sig = "+" if pval >= 0.05 & pval < 0.1

** format IRR and STDERR and keep three decimals
gen irr3 = string(real(string(round(irr, 0.001))), "%05.3f")
gen stderr3 = string(real(string(round(stderr, 0.001))), "%05.3f")

** concatenate IRR and SIG
gen irr_sig = irr3 + sig

** order variables
order var irr_sig stderr3

*==========================================================
* monthly model: all counties
*==========================================================
** read regression results
import excel "$data/xtnbreg_irr.xlsx", firstrow case(lower) sheet("monthly_all") clear

** generate SIG level
gen sig = "***" if pval < 0.001
replace sig = "**" if pval >= 0.001 & pval < 0.01
replace sig = "*" if pval >= 0.01 & pval < 0.05
replace sig = "+" if pval >= 0.05 & pval < 0.1

** format IRR and STDERR and keep three decimals
gen irr3 = string(real(string(round(irr, 0.001))), "%05.3f")
gen stderr3 = string(real(string(round(stderr, 0.001))), "%05.3f")

** concatenate IRR and SIG
gen irr_sig = irr3 + sig

** order variables
order var irr_sig stderr3

*==========================================================
* monthly model: 1%
*==========================================================
** read regression results
import excel "$data/xtnbreg_irr.xlsx", firstrow case(lower) sheet("monthly_1pct") clear

** generate SIG level
gen sig = "***" if pval < 0.001
replace sig = "**" if pval >= 0.001 & pval < 0.01
replace sig = "*" if pval >= 0.01 & pval < 0.05
replace sig = "+" if pval >= 0.05 & pval < 0.1

** format IRR and STDERR and keep three decimals
gen irr3 = string(real(string(round(irr, 0.001))), "%05.3f")
gen stderr3 = string(real(string(round(stderr, 0.001))), "%05.3f")

** concatenate IRR and SIG
gen irr_sig = irr3 + sig

** order variables
order var irr_sig stderr3

// *==========================================================
// * clear memory and exit
// *==========================================================
// exit, clear STATA


*=========================== END ===========================

