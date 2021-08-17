* Michler et al., 2018
*	THIS FILE PRODUCES THE REGRESSION RESULTS IN THE PAPER AND APPENDICES

use mm.dta, clear


/*=========================================================================
							PREPPING DATA
===========================================================================*/

** Generate log transformed variables
  foreach var of varlist landowned mainrf {
	bysort qnno Year: gen log`var' = asinh(`var')
	}
	lab var loglandowned "Ln land owned"
	lab var logmainrf "Ln main season rainfall"	

** Generate dependent variables
gen lny = asinh(cpprodctn/cpland)
	lab var lny "Ln output (kg/ha)"
gen lncv = asinh(cpproductionvalue/cpland)
	lab var lncv "Ln value of home chickpea consumption (USD/ha)"
gen lnc = asinh(totalcost_sum/cultarea)
	lab var lnc "Ln total cost (USD/ha)"
gen lnr = asinh(salesinc_sum/cultarea)
	lab var lnr "Ln revenue from crop sales (USD/ha)"
gen lnp = asinh((salesinc_sum- totalcost_sum)/cultarea)
	lab var lnp "Ln crop sales profit (USD/ha)"

** Generate independent production variables
  foreach var of varlist cpseed cpchemfertqt cptotchemcost cplabour cptotallabourcost cpsalescost {
	bysort qnno Year: gen lny_`var' = asinh(`var'/cpland)
	}
	lab var lny_cpseed "Ln seed per ha"
	lab var lny_cpchemfertqt "Ln fertilizer per ha"
	lab var lny_cptotchemcost "Ln chemical cost per ha"
	lab var lny_cpsalescost "Ln transport cost per ha"
	lab var lny_cptotallabourcost "Ln hired labor cost per ha"
	lab var lny_cplabour "Ln family labor days per ha"

** Generate independent cost/revenue variables
  foreach var of varlist seedcost totfertcost totchemcost totallabour_sum totallabourcost_sum salescost {
	bysort qnno Year: gen lnc_`var' = asinh(`var'/cultarea)
	}
	lab var lnc_seedcost "Ln seed per ha"
	lab var lnc_totfertcost "Ln fertilizer per ha"
	lab var lnc_totchemcost "Ln chemical cost per ha"
	lab var lnc_salescost "Ln transport cost per ha"
	lab var lnc_totallabourcost_sum "Ln hired labor cost per ha"
	lab var lnc_totallabour_sum "Ln family labor days per ha"   

/*=========================================================================
							GENERATE DATA SETS
===========================================================================*/

	save "mm_long.dta", replace

reshape wide Head_gender- lnc_salescost, i(qnno) j(Year)
	save "mm_wide.dta", replace



/*=========================================================================
								OLS & FE
===========================================================================*/

use mm_long.dta, clear

********************
*** 1 Production ***
********************

*** OLS, Pooled, no covariates, district FE *** 
xi: reg lny icp i.Year i.District

*** OLS, Pooled, covariates, district FE *** 
local b1 lny_cpseed lny_cpchemfertqt lny_cptotchemcost lny_cplabour lny_cptotallabourcost lny_cpsalescost
local b2 Head_gender dependencyperc offincsource logmainrf shock loglandowned

xi: reg lny icp `b1' `b2' i.Year i.District

xtset qnno Year

*** FE, no covariates *** 
xi: xtreg lny icp i.Year, fe

*** FE, covariates *** 
local b1 lny_cpseed lny_cpchemfertqt lny_cptotchemcost lny_cplabour lny_cptotallabourcost lny_cpsalescost
local b2 Head_gender dependencyperc offincsource logmainrf shock loglandowned

xi: xtreg lny icp `b1' `b2' i.Year, fe

**************
*** 2 Cost ***
**************
*drop if lny == .

*** OLS, Pooled, no covariates, district FE *** 
xi: reg lnc icp i.Year i.District

*** OLS, Pooled, covariates, district FE *** 
local b1 lnc_seedcost lnc_totfertcost lnc_totchemcost lnc_totallabour_sum lnc_totallabourcost_sum lnc_salescost
local b2 Head_gender dependencyperc offincsource logmainrf shock loglandowned

xi: reg lnc icp `b1' `b2' i.Year i.District

xtset qnno Year

*** FE, no covariates *** 
xi: xtreg lnc icp i.Year, fe

*** FE, covariates *** 
local b1 lnc_seedcost lnc_totfertcost lnc_totchemcost lnc_totallabour_sum lnc_totallabourcost_sum  lnc_salescost
local b2 Head_gender dependencyperc offincsource logmainrf shock loglandowned

xi: xtreg lnc icp `b1' `b2' i.Year, fe

	
****************
*** 4 Profit ***
****************

*** OLS, Pooled, no covariates, district FE *** 
xi: reg lnp icp i.Year i.District

*** OLS, Pooled, covariates, district FE *** 
local b1 lnc_seedcost lnc_totfertcost lnc_totchemcost lnc_totallabour_sum lnc_totallabourcost_sum lnc_salescost
local b2 Head_gender dependencyperc offincsource logmainrf shock loglandowned

xi: reg lnp icp `b1' `b2' `b3' i.Year i.District

*** FE, no covariates *** 
xi: xtreg lnp icp i.Year, fe

*** FE, covariates *** 
local b1 lnc_seedcost lnc_totfertcost lnc_totchemcost lnc_totallabour_sum lnc_totallabourcost_sum lnc_salescost
local b2 Head_gender dependencyperc offincsource logmainrf shock loglandowned

xi: xtreg lnp icp `b1' `b2'  i.Year, fe

/*=========================================================================
								CRE
===========================================================================*/

use mm_wide.dta, clear


********************
*** 1 Production ***
********************

***CRE, without covariates
randcoef lny2008 lny2010 lny2014, choice(icp2008 icp2010 icp2014) method(CRE) showreg

***CRE, with covariates
	local maincovars1 lny_cpseed2008- lny_cpsalescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lny_cpseed2010- lny_cpsalescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lny_cpseed2014- lny_cpsalescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014

randcoef lny2008 lny2010 lny2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRE) showreg	

	
**************
*** 2 Cost ***
**************

***CRE, without covariates
randcoef lnc2008 lnc2010 lnc2014, choice(icp2008 icp2010 icp2014) method(CRE) showreg

***CRE, with covariates
	local maincovars1 lnc_seedcost2008- lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010- lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014- lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnc2008 lnc2010 lnc2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRE) showreg

	
****************
*** 4 Profit ***
****************

***CRE, without covariates
randcoef lnp2008 lnp2010 lnp2014, choice(icp2008 icp2010 icp2014) method(CRE) showreg 

***CRE, with covariates
	local maincovars1 lnc_seedcost2008- lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010- lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014- lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnp2008 lnp2010 lnp2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRE) showreg

	
/*=========================================================================
							THREE YEAR CRC
===========================================================================*/

********************
*** 1 Production ***
********************

use mm_wide.dta, clear

***CRC, without covariates
randcoef lny2008 lny2010 lny2014, choice(icp2008 icp2010 icp2014) meth(CRC)

***CRC, with covariates
	local maincovars1 lny_cpseed2008- lny_cpsalescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lny_cpseed2010- lny_cpsalescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lny_cpseed2014- lny_cpsalescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014

randcoef lny2008 lny2010 lny2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') meth(CRC) keep showreg

*Recover theta hat
egen h1_bar = mean(icp2008)
egen h2_bar = mean(icp2010)
egen h3_bar = mean(icp2014)
egen h12_bar = mean(int_4)
egen h13_bar = mean(int_5)
egen h23_bar = mean(int_6)
egen h123_bar = mean(int_7)
gen l0 = -_b[l1]*h1_bar - _b[l2]*h2_bar - _b[l3]*h3_bar - _b[l4]*h12_bar - _b[l5]*h13_bar - _b[l6]*h23_bar - _b[l7]*h123_bar
   
gen theta = l0 + _b[l1]*icp2008 + _b[l2]*icp2010 + _b[l3]*icp2014 + _b[l4]*int_4 + _b[l5]*int_5 + _b[l6]*int_6 + _b[l7]*int_7
	lab var theta "comparative advantage"

gen theta1 = l0 + _b[l1]*0 + _b[l2]*0 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta1 "never adopt"
gen theta2 = l0 + _b[l1]*1 + _b[l2]*1 + _b[l3]*1 + _b[l4]*1 + _b[l5]*1 + _b[l6]*1 + _b[l7]*1
	lab var theta2 "always adopt"
gen theta3 = l0 + _b[l1]*0 + _b[l2]*1 + _b[l3]*1 + _b[l4]*0 + _b[l5]*0 + _b[l6]*1 + _b[l7]*0
	lab var theta3 "early adopters"
gen theta4 = l0 + _b[l1]*0 + _b[l2]*0 + _b[l3]*1 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta4 "late adopters"
gen theta5 = l0 + _b[l1]*1 + _b[l2]*0 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta5 "early dis-adopters"
gen theta6 = l0 + _b[l1]*1 + _b[l2]*1 + _b[l3]*0 + _b[l4]*1 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta6 "late dis-adopters"
gen theta7 = l0 + _b[l1]*1 + _b[l2]*0 + _b[l3]*1 + _b[l4]*0 + _b[l5]*1 + _b[l6]*0 + _b[l7]*0
	lab var theta7 "mixed adopters"
gen theta8 = l0 + _b[l1]*0 + _b[l2]*1 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta8 "mixed dis-adopters"

*graph bar (mean) theta1 (mean) theta2 (mean) theta3 (mean) theta4 (mean) theta5 ///
* (mean) theta6 (mean) theta7 (mean) theta8
gen r1 = _b[b] + _b[phi]*theta1
	lab var r1 "returns for never adopters"
gen r2 = _b[b] + _b[phi]*theta2
	lab var r2 "returns for always adopters"
gen r3 = _b[b] + _b[phi]*theta3
	lab var r3 "returns for early adopters"
gen r4 = _b[b] + _b[phi]*theta4
	lab var r4 "returns for late adopters"
gen r5 = _b[b] + _b[phi]*theta5
	lab var r5 "returns for early dis-adopters"
gen r6 = _b[b] + _b[phi]*theta6
	lab var r6 "returns for late dis-adopters"
gen r7 = _b[b] + _b[phi]*theta7
	lab var r7 "returns for mixed adopters"
gen r8 = _b[b] + _b[phi]*theta8
	lab var r8 "returns for mixed dis-adopters"

graph bar (mean) r2 (mean) r3 (mean) r4 (mean) r7 (mean) r8 (mean) r6 (mean) r5 (mean) r1, ///
bar(1, color(navy)) bar(2, color(navy*0.75)) bar(3, color(navy*0.5)) bar(4, color(navy*0.25)) ///
bar(5, color(maroon*.25)) bar(6, color(maroon*0.5)) bar(7, color(maroon*0.75)) bar(8, color(maroon)) ///
legend(on order(1 3 5 7 2 4 6 8) col(4) lab(1 "Always adopter") lab(2 "Early adopter") lab(3 "Late adopter") ///
lab(4 "Mixed adopter") lab(5 "Mixed dis-adopter") lab(6 "Late dis-adopter") lab(7 "Early dis-adopter") ///
lab(8 "Never adopter") pos(6))

	
**************
*** 2 Cost ***
**************

use mm_wide.dta, clear

***CRC, without covariates
randcoef lnc2008 lnc2010 lnc2014, choice(icp2008 icp2010 icp2014) method(CRC)

***CRC, with covariates
	local maincovars1 lnc_seedcost2008- lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010- lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014- lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnc2008 lnc2010 lnc2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRC) keep showreg

*Recover theta hat
egen h1_bar = mean(icp2008)
egen h2_bar = mean(icp2010)
egen h3_bar = mean(icp2014)
egen h12_bar = mean(int_4)
egen h13_bar = mean(int_5)
egen h23_bar = mean(int_6)
egen h123_bar = mean(int_7)
gen l0 = -_b[l1]*h1_bar - _b[l2]*h2_bar - _b[l3]*h3_bar - _b[l4]*h12_bar - _b[l5]*h13_bar - _b[l6]*h23_bar - _b[l7]*h123_bar
   
gen theta = l0 + _b[l1]*icp2008 + _b[l2]*icp2010 + _b[l3]*icp2014 + _b[l4]*int_4 + _b[l5]*int_5 + _b[l6]*int_6 + _b[l7]*int_7
	lab var theta "comparative advantage"

gen theta1 = l0 + _b[l1]*0 + _b[l2]*0 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta1 "never adopt"
gen theta2 = l0 + _b[l1]*1 + _b[l2]*1 + _b[l3]*1 + _b[l4]*1 + _b[l5]*1 + _b[l6]*1 + _b[l7]*1
	lab var theta2 "always adopt"
gen theta3 = l0 + _b[l1]*0 + _b[l2]*1 + _b[l3]*1 + _b[l4]*0 + _b[l5]*0 + _b[l6]*1 + _b[l7]*0
	lab var theta3 "early adopters"
gen theta4 = l0 + _b[l1]*0 + _b[l2]*0 + _b[l3]*1 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta4 "late adopters"
gen theta5 = l0 + _b[l1]*1 + _b[l2]*0 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta5 "early dis-adopters"
gen theta6 = l0 + _b[l1]*1 + _b[l2]*1 + _b[l3]*0 + _b[l4]*1 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta6 "late dis-adopters"
gen theta7 = l0 + _b[l1]*1 + _b[l2]*0 + _b[l3]*1 + _b[l4]*0 + _b[l5]*1 + _b[l6]*0 + _b[l7]*0
	lab var theta7 "mixed adopters"
gen theta8 = l0 + _b[l1]*0 + _b[l2]*1 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta8 "mixed dis-adopters"

*graph bar (mean) theta1 (mean) theta2 (mean) theta3 (mean) theta4 (mean) theta5 ///
* (mean) theta6 (mean) theta7 (mean) theta8
gen r1 = _b[b] + _b[phi]*theta1
	lab var r1 "returns for never adopters"
gen r2 = _b[b] + _b[phi]*theta2
	lab var r2 "returns for always adopters"
gen r3 = _b[b] + _b[phi]*theta3
	lab var r3 "returns for early adopters"
gen r4 = _b[b] + _b[phi]*theta4
	lab var r4 "returns for late adopters"
gen r5 = _b[b] + _b[phi]*theta5
	lab var r5 "returns for early dis-adopters"
gen r6 = _b[b] + _b[phi]*theta6
	lab var r6 "returns for late dis-adopters"
gen r7 = _b[b] + _b[phi]*theta7
	lab var r7 "returns for mixed adopters"
gen r8 = _b[b] + _b[phi]*theta8
	lab var r8 "returns for mixed dis-adopters"

graph bar (mean) r2 (mean) r3 (mean) r4 (mean) r7 (mean) r8 (mean) r6 (mean) r5 (mean) r1, ///
bar(1, color(navy)) bar(2, color(navy*0.75)) bar(3, color(navy*0.5)) bar(4, color(navy*0.25)) ///
bar(5, color(maroon*.25)) bar(6, color(maroon*0.5)) bar(7, color(maroon*0.75)) bar(8, color(maroon)) ///
legend(on order(1 3 5 7 2 4 6 8) col(4) lab(1 "Always adopter") lab(2 "Early adopter") lab(3 "Late adopter") ///
lab(4 "Mixed adopter") lab(5 "Mixed dis-adopter") lab(6 "Late dis-adopter") lab(7 "Early dis-adopter") ///
lab(8 "Never adopter") pos(6))

	
****************
*** 4 Profit ***
****************

use mm_wide.dta, clear

***CRC, without covariates
randcoef lnp2008 lnp2010 lnp2014, choice(icp2008 icp2010 icp2014) method(CRC) 

***CRC, with covariates
	local maincovars1 lnc_seedcost2008- lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010- lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014- lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnp2008 lnp2010 lnp2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRC) keep showreg

*Recover theta hat
egen h1_bar = mean(icp2008)
egen h2_bar = mean(icp2010)
egen h3_bar = mean(icp2014)
egen h12_bar = mean(int_4)
egen h13_bar = mean(int_5)
egen h23_bar = mean(int_6)
egen h123_bar = mean(int_7)
gen l0 = -_b[l1]*h1_bar - _b[l2]*h2_bar - _b[l3]*h3_bar - _b[l4]*h12_bar - _b[l5]*h13_bar - _b[l6]*h23_bar - _b[l7]*h123_bar
   
gen theta = l0 + _b[l1]*icp2008 + _b[l2]*icp2010 + _b[l3]*icp2014 + _b[l4]*int_4 + _b[l5]*int_5 + _b[l6]*int_6 + _b[l7]*int_7
	lab var theta "comparative advantage"

gen theta1 = l0 + _b[l1]*0 + _b[l2]*0 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta1 "never adopt"
gen theta2 = l0 + _b[l1]*1 + _b[l2]*1 + _b[l3]*1 + _b[l4]*1 + _b[l5]*1 + _b[l6]*1 + _b[l7]*1
	lab var theta2 "always adopt"
gen theta3 = l0 + _b[l1]*0 + _b[l2]*1 + _b[l3]*1 + _b[l4]*0 + _b[l5]*0 + _b[l6]*1 + _b[l7]*0
	lab var theta3 "early adopters"
gen theta4 = l0 + _b[l1]*0 + _b[l2]*0 + _b[l3]*1 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta4 "late adopters"
gen theta5 = l0 + _b[l1]*1 + _b[l2]*0 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta5 "early dis-adopters"
gen theta6 = l0 + _b[l1]*1 + _b[l2]*1 + _b[l3]*0 + _b[l4]*1 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta6 "late dis-adopters"
gen theta7 = l0 + _b[l1]*1 + _b[l2]*0 + _b[l3]*1 + _b[l4]*0 + _b[l5]*1 + _b[l6]*0 + _b[l7]*0
	lab var theta7 "mixed adopters"
gen theta8 = l0 + _b[l1]*0 + _b[l2]*1 + _b[l3]*0 + _b[l4]*0 + _b[l5]*0 + _b[l6]*0 + _b[l7]*0
	lab var theta8 "mixed dis-adopters"

*graph bar (mean) theta1 (mean) theta2 (mean) theta3 (mean) theta4 (mean) theta5 ///
* (mean) theta6 (mean) theta7 (mean) theta8
gen r1 = _b[b] + _b[phi]*theta1
	lab var r1 "returns for never adopters"
gen r2 = _b[b] + _b[phi]*theta2
	lab var r2 "returns for always adopters"
gen r3 = _b[b] + _b[phi]*theta3
	lab var r3 "returns for early adopters"
gen r4 = _b[b] + _b[phi]*theta4
	lab var r4 "returns for late adopters"
gen r5 = _b[b] + _b[phi]*theta5
	lab var r5 "returns for early dis-adopters"
gen r6 = _b[b] + _b[phi]*theta6
	lab var r6 "returns for late dis-adopters"
gen r7 = _b[b] + _b[phi]*theta7
	lab var r7 "returns for mixed adopters"
gen r8 = _b[b] + _b[phi]*theta8
	lab var r8 "returns for mixed dis-adopters"

graph bar (mean) r2 (mean) r3 (mean) r4 (mean) r7 (mean) r8 (mean) r6 (mean) r5 (mean) r1, ///
bar(1, color(navy)) bar(2, color(navy*0.75)) bar(3, color(navy*0.5)) bar(4, color(navy*0.25)) ///
bar(5, color(maroon*.25)) bar(6, color(maroon*0.5)) bar(7, color(maroon*0.75)) bar(8, color(maroon)) ///
legend(on order(1 3 5 7 2 4 6 8) col(4) lab(1 "Always adopter") lab(2 "Early adopter") lab(3 "Late adopter") ///
lab(4 "Mixed adopter") lab(5 "Mixed dis-adopter") lab(6 "Late dis-adopter") lab(7 "Early dis-adopter") ///
lab(8 "Never adopter") pos(6))
	

/*=========================================================================
			APPENDIX B: POTENTIAL ENDOGENOUS COVARIATES
===========================================================================*/


use mm_long.dta, clear

  foreach var of varlist lny_cpseed lny_cpchemfertqt lny_cptotchemcost lny_cplabour lny_cptotallabourcost lny_cpsalescost ///
						lnc_seedcost lnc_totfertcost lnc_totchemcost lnc_totallabour_sum lnc_totallabourcost_sum lnc_salescost {
	gen i`var' = icp*`var'
	}

********************************	
**Heterogeneity by observables**
********************************

*** 1 Production ***

***FE, with covariates***
	local lcpcovars lny_cpseed lny_cpchemfertqt lny_cptotchemcost lny_cplabour lny_cptotallabourcost lny_cpsalescost
	local icpcovars icp ilny_cpseed ilny_cpchemfertqt ilny_cptotchemcost ilny_cplabour ilny_cptotallabourcost ilny_cpsalescost
	local controls Head_gender dependencyperc offincsource logmainrf shock loglandowned

xtreg lny `lcpcovars' `icpcovars' `controls' i.Year if icp != ., fe i(qnno)

test lny_cpseed = ilny_cpseed
test lny_cpchemfertqt = ilny_cpchemfertqt
test lny_cptotchemcost = ilny_cptotchemcost
test lny_cplabour = ilny_cplabour
test lny_cptotallabourcost = ilny_cptotallabourcost
test lny_cpsalescost = ilny_cpsalescost
	
*** 2 Cost ***

*** FE, covariates*** 
	local lcpcovars lnc_seedcost lnc_totfertcost lnc_totchemcost lnc_totallabour_sum lnc_totallabourcost_sum lnc_salescost
	local icpcovars icp ilnc_seedcost ilnc_totfertcost ilnc_totchemcost ilnc_totallabour_sum ilnc_totallabourcost_sum ilnc_salescost
	local controls Head_gender dependencyperc offincsource logmainrf shock loglandowned

xtreg lnc `lcpcovars' `icpcovars' `controls' i.Year if icp != ., fe i(qnno)

test lnc_seedcost = ilnc_seedcost
test lnc_totfertcost = ilnc_totfertcost
test lnc_totchemcost = ilnc_totchemcost
test lnc_totallabour_sum = ilnc_totallabour_sum
test lnc_totallabourcost_sum = ilnc_totallabourcost_sum
test lnc_salescost = ilnc_salescost

*** 4 Profit ***

***FE, with covariates***
	local lcpcovars lnc_seedcost lnc_totfertcost lnc_totchemcost lnc_totallabour_sum lnc_totallabourcost_sum lnc_salescost
	local icpcovars icp ilnc_seedcost ilnc_totfertcost ilnc_totchemcost ilnc_totallabour_sum ilnc_totallabourcost_sum ilnc_salescost
	local controls Head_gender dependencyperc offincsource logmainrf shock loglandowned

xtreg lnp `lcpcovars' `icpcovars' `controls' i.Year if icp != ., fe i(qnno)

test lnc_seedcost = ilnc_seedcost
test lnc_totfertcost = ilnc_totfertcost
test lnc_totchemcost = ilnc_totchemcost
test lnc_totallabour_sum = ilnc_totallabour_sum
test lnc_totallabourcost_sum = ilnc_totallabourcost_sum
test lnc_salescost = ilnc_salescost


***************************
***Endogeneity of inputs***
***************************

use mm_wide.dta, clear

***CRC, with covariates, chemical use endogenous
	local maincovars1 lnc_seedcost2008 lnc_totfertcost2008 lnc_totallabour_sum2008 lnc_totallabourcost_sum2008 lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010 lnc_totfertcost2010 lnc_totallabour_sum2010 lnc_totallabourcost_sum2010 lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014 lnc_totfertcost2014 lnc_totallabour_sum2014 lnc_totallabourcost_sum2014 lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnp2008 lnp2010 lnp2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') ///
	method(CRC) endo(lnc_totchemcost2008 lnc_totchemcost2010 lnc_totchemcost2014) keep

use mm_wide.dta, clear
	
***CRC, with covariates, family labor endogenous - takes around 2300 iterations
	local maincovars1 lnc_seedcost2008 lnc_totfertcost2008 lnc_totchemcost2008 lnc_totallabourcost_sum2008 lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010 lnc_totfertcost2010 lnc_totchemcost2010 lnc_totallabourcost_sum2010 lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014 lnc_totfertcost2014 lnc_totchemcost2014 lnc_totallabourcost_sum2014 lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnp2008 lnp2010 lnp2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') ///
	method(CRC) endo(lnc_totallabour_sum2008 lnc_totallabour_sum2010 lnc_totallabour_sum2014) keep

use mm_wide.dta, clear
	
***CRC, with covariates, fertilizer endogenous
	local maincovars1 lnc_seedcost2008 lnc_totchemcost2008 lnc_totallabour_sum2008 lnc_totallabourcost_sum2008 lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010 lnc_totchemcost2010 lnc_totallabour_sum2010 lnc_totallabourcost_sum2010 lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014 lnc_totchemcost2014 lnc_totallabour_sum2014 lnc_totallabourcost_sum2014 lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnp2008 lnp2010 lnp2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') ///
	method(CRC) endo(lnc_totfertcost2008 lnc_totfertcost2010 lnc_totfertcost2014) keep

	
/*=========================================================================
				APPENDIX C: SEPARABILITY OF LABOR
===========================================================================*/

use mm_long.dta, clear

*Real Wages from Bachewe et al., 2016
gen wage_b = 1.51 if Year == 2008
replace wage_b = 1.49 if Year == 2010
replace wage_b = 2.11 if Year == 2014
	lab var wage_b "wage from Bachewe et al. (2016)"

gen famlabourvalue_b = totallabour_sum*wage_b
	lab var famlabourvalue_b "family labour (USD)"
gen labour_Bachewe = famlabourvalue_b+totallabourcost_sum
	lab var labour_Bachewe "total labour (USD) Bachewe et al. (2016)"
gen cpfamlabour_b = cplabour*wage_b
	lab var cpfamlabour_b "chickpea family labour (USD)"
gen cplabour_Bachewe = cpfamlabour_b+cptotallabourcost
	lab var cplabour_Bachewe "chickpea total labour (USD) Bachewe et al. (2016)"

*Shadow Wages from Saketta and Gerber, 2017
gen wage_s = 7.134 if Year == 2010
replace wage_s = 24.86 if Year == 2014
replace wage_s = 7.134*(CPI2009/100) if Year == 2008
	lab var wage_s "wage from Saketta \& Gerber (2017)"

gen famlabourvalue_s = totallabour_sum*wage_s
	lab var famlabourvalue_s "family labour (USD)"
gen labour_Saketta = famlabourvalue_s+totallabourcost_sum
	lab var labour_Saketta "total labour (USD) 	Saketta \& Gerber (2017)"
gen cpfamlabour_s = cplabour*wage_s
	lab var cpfamlabour_s "chickpea family labour (USD)"
gen cplabour_Saketta = cpfamlabour_s+cptotallabourcost
	lab var cplabour_Saketta "chickpea total labour (USD) Saketta \& Gerber (2017)"

** Generate new dependent variables
gen lnc_b = asinh((totalcost_sum + famlabourvalue_b)/cultarea)
	lab var lnc_b "Ln total cost with Bachewe et al. (2016) wage (USD/ha)"
gen lnc_s = asinh((totalcost_sum + famlabourvalue_s)/cultarea)
	lab var lnc_s "Ln total cost with Saketta \& Gerber (2017) wage (USD/ha)"
gen lnp_b = asinh((salesinc_sum - totalcost_sum - famlabourvalue_b)/cultarea)
	lab var lnp "Ln crop sales profit (USD/ha)"
gen lnp_s = asinh((salesinc_sum - totalcost_sum - famlabourvalue_s)/cultarea)
	lab var lnp "Ln crop sales profit (USD/ha)"
	
** Generate chickpea labor values
  foreach var of varlist cplabour_Bachewe cplabour_Saketta {
	bysort qnno Year: gen lny_`var' = asinh(`var'/cpland)
	}
	lab var lny_cplabour_Bachewe "Ln labour cost per har"
	lab var lny_cplabour_Saketta "Ln labour cost per har"

** Generate farm cost/revenue variables
  foreach var of varlist labour_Bachewe labour_Saketta {
	bysort qnno Year: gen lnc_`var' = asinh(`var'/cultarea)
	}
	lab var lnc_labour_Bachewe "Ln labour cost per har"
	lab var lnc_labour_Saketta "Ln labour cost per har"
	

reshape wide District- lnc_labour_Saketta, i(qnno) j(Year)

save "lab_wide.dta", replace


*** 1 Production ***

***CRC, with Bachewe labour
	local maincovars1 lny_cpseed2008 lny_cpchemfertqt2008 lny_cptotchemcost2008 lny_cpsalescost2008 lny_cplabour_Bachewe2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lny_cpseed2010 lny_cpchemfertqt2010 lny_cptotchemcost2008 lny_cpsalescost2010 lny_cplabour_Bachewe2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lny_cpseed2014 lny_cpchemfertqt2014 lny_cptotchemcost2014 lny_cpsalescost2008 lny_cplabour_Bachewe2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014

randcoef lny2008 lny2010 lny2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') meth(CRC)

***CRC, with Saketta labour
	local maincovars1 lny_cpseed2008 lny_cpchemfertqt2008 lny_cptotchemcost2008 lny_cpsalescost2008 lny_cplabour_Saketta2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lny_cpseed2010 lny_cpchemfertqt2010 lny_cptotchemcost2008 lny_cpsalescost2010 lny_cplabour_Saketta2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lny_cpseed2014 lny_cpchemfertqt2014 lny_cptotchemcost2014 lny_cpsalescost2008 lny_cplabour_Saketta2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014

randcoef lny2008 lny2010 lny2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') meth(CRC)


*** 2 Cost ***

***CRC, with Bachewe labour
	local maincovars1 lnc_seedcost2008 lnc_totfertcost2008 lnc_totchemcost2008 lnc_salescost2008 lnc_labour_Bachewe2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010 lnc_totfertcost2010 lnc_totchemcost2010 lnc_salescost2010 lnc_labour_Bachewe2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014 lnc_totfertcost2014 lnc_totchemcost2014 lnc_salescost2014 lnc_labour_Bachewe2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnc_b2008 lnc_b2010 lnc_b2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRC)

***CRC, with Saketta labour
	local maincovars1 lnc_seedcost2008 lnc_totfertcost2008 lnc_totchemcost2008 lnc_salescost2008 lnc_labour_Saketta2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010 lnc_totfertcost2010 lnc_totchemcost2010 lnc_salescost2010 lnc_labour_Saketta2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014 lnc_totfertcost2014 lnc_totchemcost2014 lnc_salescost2014 lnc_labour_Saketta2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnc_s2008 lnc_s2010 lnc_s2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRC)
	
*** 4 Profit ***

***CRC, with Bachewe labour
	local maincovars1 lnc_seedcost2008 lnc_totfertcost2008 lnc_totchemcost2008 lnc_salescost2008 lnc_labour_Bachewe2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010 lnc_totfertcost2010 lnc_totchemcost2010 lnc_salescost2010 lnc_labour_Bachewe2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014 lnc_totfertcost2014 lnc_totchemcost2014 lnc_salescost2014 lnc_labour_Bachewe2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnp_b2008 lnp_b2010 lnp_b2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRC)

***CRC, with Saketta labour
	local maincovars1 lnc_seedcost2008 lnc_totfertcost2008 lnc_totchemcost2008 lnc_salescost2008 lnc_labour_Saketta2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010 lnc_totfertcost2010 lnc_totchemcost2010 lnc_salescost2010 lnc_labour_Saketta2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010 

	local maincovars3 lnc_seedcost2014 lnc_totfertcost2014 lnc_totchemcost2014 lnc_salescost2014 lnc_labour_Saketta2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnp_s2008 lnp_s2010 lnp_s2014, choice(icp2008 icp2010 icp2014) controls(`maincovars1' `controls1' `maincovars2' `controls2' `maincovars3' `controls3') method(CRC)

	
/*=========================================================================
						APPENDIX D: TWO YEAR CRC
===========================================================================*/

use mm_wide.dta, clear

***2008-10 CRC, with covariates
	local maincovars1 lnc_seedcost2008- lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars2 lnc_seedcost2010- lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010
	
randcoef lnr2008 lnr2010 , choice(icp2008 icp2010 ) controls(`maincovars1' `controls1' `maincovars2' `controls2') meth(CRC) showreg

***2010-14 CRC, with covariates
	local maincovars2 lnc_seedcost2010- lnc_salescost2010
	local controls2 Head_gender2010 dependencyperc2010 offincsource2010 loglandowned2010 logmainrf2010 shock2010
	
	local maincovars3 lnc_seedcost2014- lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnr2010 lnr2014, choice(icp2010 icp2014) controls(`maincovars2' `controls2' `maincovars3' `controls3') meth(CRC)

***2008-14 CRC, with covariates
	local maincovars1 lnc_seedcost2008- lnc_salescost2008
	local controls1 Head_gender2008 dependencyperc2008 offincsource2008 loglandowned2008 logmainrf2008 shock2008

	local maincovars3 lnc_seedcost2014- lnc_salescost2014
	local controls3 Head_gender2014 dependencyperc2014 offincsource2014 loglandowned2014 logmainrf2014 shock2014
	
randcoef lnr2008 lnr2014, choice(icp2008 icp2014) controls(`maincovars1' `controls1' `maincovars3' `controls3') meth(CRC)

/*=========================================================================
			APPENDIX E: REDUCED FORM COEFFICIENTS
===========================================================================*/

*Reduced form coefficients for the table in Appendix E are taken from the regressions for 3 year CRC above.

*END
