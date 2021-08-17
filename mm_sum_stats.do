* Michler et al., 2018
*	THIS FILE PRODUCES THE SUMMARY TALES IN THE PAPER AND APPENDICES
*	SHOULD ONLY BE RUN AFTER mm_wide.dta HAS BEEN CREATED USING mm_pub_table.do
*	UNLIKE mm_pub_table.do, THIS FILE OUTPUTS SEVERAL .tex TABLES FOR EASIER COMPARISON WITH PAPER

use mm.dta, clear


/*=========================================================================
							PREPPING DATA
===========================================================================*/

*chickpea data
  foreach var of varlist cpseed cpchemfertqt cptotchemcost cplabour cptotallabourcost cpsalescost {
	bysort qnno Year: gen `var'ha = (`var'/cpland)
	}
	lab var cpseedha "\hspace{0.1cm} Chickpea seed (kg/ha)"
	lab var cpsalesprice "\hspace{0.1cm} Chickpea sales price (USD/kg)"
	lab var cpchemfertqtha "\hspace{0.1cm} Fertilizer (kg/ha)"
	lab var cptotchemcostha "\hspace{0.1cm} Chemical cost (USD/ha)"
	lab var cplabourha "\hspace{0.1cm} Family labor (days/ha)"
	lab var cptotallabourcostha "\hspace{0.1cm} Hired labor cost (USD/ha)"
	lab var cpsalescostha "\hspace{0.1cm} Transportation cost (USD/ha)"

save mm_sum.dta, replace

/*=========================================================================
				Table A1: Descriptive stastics by year
===========================================================================*/

*Panel A: chicpea growers
estpost tabstat yield yield, by(Year) ///
	statistics(mean sd) columns(statistics) listwise
		
	esttab . using table1A.tex, replace ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(0)) sd(fmt(0)par)")

estpost tabstat cpland cpland, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1A.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(3)) sd(fmt(3)par)")	
	
estpost tabstat cpseedha cpseedha, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1A.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(1)) sd(fmt(1)par)")		

estpost tabstat cpchemfertqtha cptotchemcostha cplabourha cptotallabourcostha, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1A.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(2)) sd(fmt(2)par)")	
		
estpost tabstat cpsalescostha cpsalescostha, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1A.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(3)) sd(fmt(3)par)")	
	
*Panel B: Whole farm production
estpost tabstat cost cost, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1B.tex, replace ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(1)) sd(fmt(1)par)")

estpost tabstat profit profit, by(Year) ///
	statistics(mean sd) columns(statistics) listwise
		
	esttab . using table1B.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(0)) sd(fmt(0)par)")

estpost tabstat cultarea cultarea, by(Year) ///
	statistics(mean sd) columns(statistics) listwise
		
	esttab . using table1B.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(3)) sd(fmt(3)par)")
	
estpost tabstat seedcostha seedcostha, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1B.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(a)) sd(fmt(a)par)")
	
estpost tabstat totfertcostha totfertcostha, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1B.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(1)) sd(fmt(1)par)")

estpost tabstat totchemcostha-totallabourcost_sumha, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1B.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(2)) sd(fmt(2)par)")

estpost tabstat salescostha salescostha, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1B.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(3)) sd(fmt(3)par)")

*Panel C: Household characteristics
estpost tabstat Head_gender Head_gender, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1C.tex, replace ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(3)) sd(fmt(3)par)")

estpost tabstat dependencyperc dependencyperc, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1C.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(2)) sd(fmt(2)par)")

estpost tabstat offincsource landowned, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1C.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(3)) sd(fmt(3)par)")		

estpost tabstat mainrf mainrf, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1C.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(1)) sd(fmt(1)par)")	

estpost tabstat shock shock, by(Year) ///
	statistics(mean sd) columns(statistics) listwise

	esttab . using table1C.tex, append ///
	main(mean) aux(sd) nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells("mean(fmt(3)) sd(fmt(3)par)")		
	
/*=========================================================================
Table 1: Transitions across local/improved varieties for the sample period
===========================================================================*/
	
use mm_wide.dta, clear

gen always_adopt = 1 if icp2008 == 1 & icp2010 == 1 & icp2014 == 1
gen early_adopt = 1 if icp2008 == 0 & icp2010 == 1 & icp2014 == 1
gen late_adopt = 1 if icp2008 == 0 & icp2010 == 0 & icp2014 == 1
gen mixed_adopt = 1 if icp2008 == 1 & icp2010 == 0 & icp2014 == 1
gen mixed_disadopt = 1 if icp2008 == 0 & icp2010 == 1 & icp2014 == 0
gen late_disadopt = 1 if icp2008 == 1 & icp2010 == 1 & icp2014 == 0
gen early_disadopt = 1 if icp2008 == 1 & icp2010 == 0 & icp2014 == 0
gen never_adopt = 1 if icp2008 == 0 & icp2010 == 0 & icp2014 == 0

mvencode always_adopt-never_adopt, mv(0)

sum always_adopt-never_adopt

/*=========================================================================
	Table 2: Production, costs, and returns to improved and local chickpeas
===========================================================================*/

*Panel A: Chickpea production
use mm_sum.dta, clear

estpost su yield yield if Year==2008 & icp==0 
	est store A		

estpost su yield yield if Year==2008 & icp==1 
	est store B
	
estpost su yield yield if Year==2010 & icp==0 
	est store C		

estpost su yield yield if Year==2010 & icp==1 
	est store D

estpost su yield yield if Year==2014 & icp==0 
	est store E		

estpost su yield yield if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2A.tex, replace ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(0)) sd(fmt(0)par))


estpost su cpland cpland if Year==2008 & icp==0 
	est store A		

estpost su cpland cpland if Year==2008 & icp==1 
	est store B
	
estpost su cpland cpland if Year==2010 & icp==0 
	est store C		

estpost su cpland cpland if Year==2010 & icp==1 
	est store D

estpost su cpland cpland if Year==2014 & icp==0 
	est store E		

estpost su cpland cpland if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2A.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs plain ///
	nomtitles cells(mean(fmt(3)) sd(fmt(3)par))

estpost su cpseedha cpseedha if Year==2008 & icp==0 
	est store A		

estpost su cpseedha cpseedha if Year==2008 & icp==1 
	est store B
	
estpost su cpseedha cpseedha if Year==2010 & icp==0 
	est store C		

estpost su cpseedha cpseedha if Year==2010 & icp==1 
	est store D

estpost su cpseedha cpseedha if Year==2014 & icp==0 
	est store E		

estpost su cpseedha cpseedha if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2A.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(1)) sd(fmt(1)par))

estpost su cpchemfertqtha cptotchemcostha cplabourha cptotallabourcostha if Year==2008 & icp==0 
	est store A		

estpost su cpchemfertqtha cptotchemcostha cplabourha cptotallabourcostha if Year==2008 & icp==1 
	est store B
	
estpost su cpchemfertqtha cptotchemcostha cplabourha cptotallabourcostha if Year==2010 & icp==0 
	est store C		

estpost su cpchemfertqtha cptotchemcostha cplabourha cptotallabourcostha if Year==2010 & icp==1 
	est store D

estpost su cpchemfertqtha cptotchemcostha cplabourha cptotallabourcostha if Year==2014 & icp==0 
	est store E		

estpost su cpchemfertqtha cptotchemcostha cplabourha cptotallabourcostha if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2A.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs plain ///
	nomtitles cells(mean(fmt(2)) sd(fmt(2)par))
	
estpost su cpsalescostha cpsalescostha if Year==2008 & icp==0 
	est store A		

estpost su cpsalescostha cpsalescostha if Year==2008 & icp==1 
	est store B
	
estpost su cpsalescostha cpsalescostha if Year==2010 & icp==0 
	est store C		

estpost su cpsalescostha cpsalescostha if Year==2010 & icp==1 
	est store D

estpost su cpsalescostha cpsalescostha if Year==2014 & icp==0 
	est store E		

estpost su cpsalescostha cpsalescostha if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2A.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs plain ///
	nomtitles cells(mean(fmt(3)) sd(fmt(3)par))

	
*Test for normality
levelsof icp, local(levels) 
foreach v of local levels {
	by Year, sort : swilk yield cpland cpseedha cpchemfertqtha cptotchemcostha cplabourha cptotallabourcostha cpsalescostha if icp==`v'
	}
*We can reject the hypothesis that a variable is normally distributed if Prob>z is <0.1

*We reject normality for all but a few cases
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum yield if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cpland if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cpseedha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cpchemfertqtha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cptotchemcostha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cplabourha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cptotallabourcostha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cpsalescostha if Year==`v', by(icp)
	}
	 
*Panel B: Whole farm production	
estpost su cost cost if Year==2008 & icp==0 
	est store A		

estpost su cost cost if Year==2008 & icp==1 
	est store B
	
estpost su cost cost if Year==2010 & icp==0 
	est store C		

estpost su cost cost if Year==2010 & icp==1 
	est store D

estpost su cost cost if Year==2014 & icp==0 
	est store E		

estpost su cost cost if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2B.tex, replace ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(1)) sd(fmt(1)par))

estpost su profit profit if Year==2008 & icp==0 
	est store A		

estpost su profit profit if Year==2008 & icp==1 
	est store B
	
estpost su profit profit if Year==2010 & icp==0 
	est store C		

estpost su profit profit if Year==2010 & icp==1 
	est store D

estpost su profit profit if Year==2014 & icp==0 
	est store E		

estpost su profit profit if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2B.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs plain ///
	nomtitles cells(mean(fmt(1)) sd(fmt(1)par))

estpost su cultarea cultarea if Year==2008 & icp==0 
	est store A		

estpost su cultarea cultarea if Year==2008 & icp==1 
	est store B
	
estpost su cultarea cultarea if Year==2010 & icp==0 
	est store C		

estpost su cultarea cultarea if Year==2010 & icp==1 
	est store D

estpost su cultarea cultarea if Year==2014 & icp==0 
	est store E		

estpost su cultarea cultarea if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2B.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(3)) sd(fmt(3)par))
	
estpost su seedcostha seedcostha if Year==2008 & icp==0 
	est store A		

estpost su seedcostha seedcostha if Year==2008 & icp==1 
	est store B
	
estpost su seedcostha seedcostha if Year==2010 & icp==0 
	est store C		

estpost su seedcostha seedcostha if Year==2010 & icp==1 
	est store D

estpost su seedcostha seedcostha if Year==2014 & icp==0 
	est store E		

estpost su seedcostha seedcostha if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2B.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs plain ///
	nomtitles cells(mean(fmt(2)) sd(fmt(2)par))
	
estpost su totfertcostha totfertcostha if Year==2008 & icp==0 
	est store A		

estpost su totfertcostha totfertcostha if Year==2008 & icp==1 
	est store B
	
estpost su totfertcostha totfertcostha if Year==2010 & icp==0 
	est store C		

estpost su totfertcostha totfertcostha if Year==2010 & icp==1 
	est store D

estpost su totfertcostha totfertcostha if Year==2014 & icp==0 
	est store E		

estpost su totfertcostha totfertcostha if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2B.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs plain ///
	nomtitles cells(mean(fmt(1)) sd(fmt(1)par))
	
estpost su totchemcostha-totallabourcost_sumha if Year==2008 & icp==0 
	est store A		

estpost su totchemcostha-totallabourcost_sumha if Year==2008 & icp==1 
	est store B
	
estpost su totchemcostha-totallabourcost_sumha if Year==2010 & icp==0 
	est store C		

estpost su totchemcostha-totallabourcost_sumha if Year==2010 & icp==1 
	est store D

estpost su totchemcostha-totallabourcost_sumha if Year==2014 & icp==0 
	est store E		

estpost su totchemcostha-totallabourcost_sumha if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2B.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs plain ///
	nomtitles cells(mean(fmt(2)) sd(fmt(2)par))

estpost su salescostha salescostha if Year==2008 & icp==0 
	est store A		

estpost su salescostha salescostha if Year==2008 & icp==1 
	est store B
	
estpost su salescostha salescostha if Year==2010 & icp==0 
	est store C		

estpost su salescostha salescostha if Year==2010 & icp==1 
	est store D

estpost su salescostha salescostha if Year==2014 & icp==0 
	est store E		

estpost su salescostha salescostha if Year==2014 & icp==1 
	est store F
	
	esttab A B C D E F using table2B.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs plain ///
	nomtitles cells(mean(fmt(3)) sd(fmt(3)par))
	
*Test for normality
levelsof icp, local(levels) 
foreach v of local levels {
	by Year, sort : swilk cost profit cultarea seedcostha totfertcostha totchemcostha-totallabourcost_sumha salescostha if icp==`v'
	}
*We can reject the hypothesis that a variable is normally distributed if Prob>z is <0.1

*We reject normality for all but a few cases
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cost if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum profit if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum cultarea if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum seedcostha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum totfertcostha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum totchemcostha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum totallabour_sumha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum totallabourcost_sumha if Year==`v', by(icp)
	}
levelsof Year, local(levels) 
foreach v of local levels {
	ranksum salescostha if Year==`v', by(icp)
	}

/*=========================================================================
				Table 6: Crop mix over time
===========================================================================*/

use mm_wide.dta, clear

gen always_adopt = 1 if icp2008 == 1 & icp2010 == 1 & icp2014 == 1
gen early_adopt = 1 if icp2008 == 0 & icp2010 == 1 & icp2014 == 1
gen late_adopt = 1 if icp2008 == 0 & icp2010 == 0 & icp2014 == 1
gen mixed_adopt = 1 if icp2008 == 1 & icp2010 == 0 & icp2014 == 1
gen mixed_disadopt = 1 if icp2008 == 0 & icp2010 == 1 & icp2014 == 0
gen late_disadopt = 1 if icp2008 == 1 & icp2010 == 1 & icp2014 == 0
gen early_disadopt = 1 if icp2008 == 1 & icp2010 == 0 & icp2014 == 0
gen never_adopt = 1 if icp2008 == 0 & icp2010 == 0 & icp2014 == 0

mvencode always_adopt-never_adopt, mv(0)
			
*Always adopt versus early/late dis-adopters
gen always_el = 1 if always_adopt == 1
replace always_el = 0 if late_disadopt == 1 | early_disadopt == 1

gen never_el = 1 if never_adopt == 1
replace never_el = 0 if late_adopt == 1 | early_adopt == 1


*2008
gen HH08 = 	percicpland2008^2+ perclcpland2008^2+ percteffland2008^2+ percwheatland2008^2+ ///
			percfabaland2008^2+ perclentilland2008^2+ percgrasspealand2008^2+ ///
			percbarleyland2008^2+ percmaizeland2008^2+ percsorghumland2008^2+ percfieldpealand2008^2
gen SW08 = -(percicpland2008*asinh(percicpland2008)+ perclcpland2008*asinh(perclcpland2008) + percteffland2008*asinh(percteffland2008)+ percwheatland2008*asinh(percwheatland2008)+ ///
			percfabaland2008*asinh(percfabaland2008)+ perclentilland2008*asinh(perclentilland2008)+ percgrasspealand2008*asinh(percgrasspealand2008)+ ///
			percbarleyland2008*asinh(percbarleyland2008)+ percmaizeland2008*asinh(percmaizeland2008)+ percsorghumland2008*asinh(percsorghumland2008)+ percfieldpealand2008*asinh(percfieldpealand2008))

by always_el, sort: sum HH08 SW08 salesinc_sum2008 noncpsalesinc2008 cppercland2008 cppercsold2008 cpsalesincperc2008
ranksum HH08, by(always_el)
ranksum SW08, by(always_el)
ranksum salesinc_sum2008, by(always_el)
ranksum noncpsalesinc2008, by(always_el)
ranksum cppercland2008, by(always_el)
ranksum cppercsold2008, by(always_el)
ranksum cpsalesincperc2008, by(always_el)

by never_el, sort: sum HH08 SW08 salesinc_sum2008 noncpsalesinc2008 cppercland2008 cppercsold2008 cpsalesincperc2008
ranksum HH08, by(never_el)
ranksum SW08, by(never_el)
ranksum salesinc_sum2008, by(never_el)
ranksum noncpsalesinc2008, by(never_el)
ranksum cppercland2008, by(never_el)
ranksum cppercsold2008, by(never_el)
ranksum cpsalesincperc2008, by(never_el)


*2014
gen HH14 = 	percicpland2014^2+ perclcpland2014^2+ percteffland2014^2+ percwheatland2014^2+ ///
			percfabaland2014^2+ perclentilland2014^2+ percgrasspealand2014^2+ ///
			percbarleyland2014^2+ percmaizeland2014^2+ percsorghumland2014^2+ percfieldpealand2014^2
gen SW14 = -(percicpland2014*asinh(percicpland2014)+ perclcpland2014*asinh(perclcpland2014) + percteffland2014*asinh(percteffland2014)+ percwheatland2014*asinh(percwheatland2014)+ ///
			percfabaland2014*asinh(percfabaland2014)+ perclentilland2014*asinh(perclentilland2014)+ percgrasspealand2014*asinh(percgrasspealand2014)+ ///
			percbarleyland2014*asinh(percbarleyland2014)+ percmaizeland2014*asinh(percmaizeland2014)+ percsorghumland2014*asinh(percsorghumland2014)+ percfieldpealand2014*asinh(percfieldpealand2014))

by always_el, sort: sum HH14 SW14 salesinc_sum2014 noncpsalesinc2014 cppercsold2014 cpsalesincperc2014 cppercland2014
ranksum HH14, by(always_el)
ranksum SW14, by(always_el)
ranksum salesinc_sum2014, by(always_el)
ranksum noncpsalesinc2014, by(always_el)
ranksum cppercland2014, by(always_el)
ranksum cppercsold2014, by(always_el)
ranksum cpsalesincperc2014, by(always_el)


by never_el, sort: sum HH14 SW14 salesinc_sum2014 noncpsalesinc2014 cppercsold2014 cpsalesincperc2014 cppercland2014
ranksum HH14, by(never_el)
ranksum SW14, by(never_el)
ranksum salesinc_sum2014, by(never_el)
ranksum noncpsalesinc2014, by(never_el)
ranksum cppercland2014, by(never_el)
ranksum cppercsold2014, by(never_el)
ranksum cpsalesincperc2014, by(never_el)


	lab var HH08 "Herfindahl Index"
	lab var SW08 "Shannon Index"
	lab var salesinc_sum2008 "Agricultural sales income (USD)"
	lab var cppercsold2008 "Share of chickpea production sold (\%)"
	lab var cpsalesincperc2008 "Chickpea share of sales income (\%)"
	lab var cppercland2008 "Cultivated area allocated to chickpea (\%)"
	lab var HH14 "Herfindahl Index"
	lab var SW14 "Shannon Index"
	lab var salesinc_sum2014 "Agricultural sales income (USD)"
	lab var cppercsold2014 "Share of chickpea production sold (\%)"
	lab var cpsalesincperc2014 "Chickpea share of sales income (\%)"
	lab var cppercland2014 "Cultivated area allocated to chickpea (\%)"
	
*Table 6
estpost su HH08 SW08 if always_el==1 
	est store A		

estpost su HH08 SW08 if always_el==0
	est store B

estpost su HH14 SW14 if always_el==1 
	est store C		

estpost su HH14 SW14 if always_el==0
	est store D
	
	esttab A B C D using table6.tex, replace ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(3)) sd(fmt(3)par))

estpost su salesinc_sum2008 salesinc_sum2008 if always_el==1 
	est store A		

estpost su salesinc_sum2008 salesinc_sum2008 if always_el==0
	est store B

estpost su salesinc_sum2014 salesinc_sum2014 if always_el==1 
	est store C		

estpost su salesinc_sum2014 salesinc_sum2014 if always_el==0
	est store D
	
	esttab A B C D using table6.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(0)) sd(fmt(0)par))

estpost su cppercsold2008 cpsalesincperc2008 cppercland2008 if always_el==1 
	est store A		

estpost su cppercsold2008 cpsalesincperc2008 cppercland2008 if always_el==0
	est store B

estpost su cppercsold2014 cpsalesincperc2014 cppercland2014 if always_el==1 
	est store C		

estpost su cppercsold2014 cpsalesincperc2014 cppercland2014 if always_el==0
	est store D
	
	esttab A B C D using table6.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(2)) sd(fmt(2)par))
	
estpost su HH08 SW08 if never_el==1 
	est store A		

estpost su HH08 SW08 if never_el==0
	est store B

estpost su HH14 SW14 if never_el==1 
	est store C		

estpost su HH14 SW14 if never_el==0
	est store D
	
	esttab A B C D using table6.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(3)) sd(fmt(3)par))

estpost su salesinc_sum2008 salesinc_sum2008 if never_el==1 
	est store A		

estpost su salesinc_sum2008 salesinc_sum2008 if never_el==0
	est store B

estpost su salesinc_sum2014 salesinc_sum2014 if never_el==1 
	est store C		

estpost su salesinc_sum2014 salesinc_sum2014 if never_el==0
	est store D
	
	esttab A B C D using table6.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(0)) sd(fmt(0)par))

estpost su cppercsold2008 cpsalesincperc2008 cppercland2008 if never_el==1 
	est store A		

estpost su cppercsold2008 cpsalesincperc2008 cppercland2008 if never_el==0
	est store B

estpost su cppercsold2014 cpsalesincperc2014 cppercland2014 if never_el==1 
	est store C		

estpost su cppercsold2014 cpsalesincperc2014 cppercland2014 if never_el==0
	est store D
	
	esttab A B C D using table6.tex, append ///
	nostar unstack label booktabs nonum collabels(none) f noobs ///
	cells(mean(fmt(2)) sd(fmt(2)par))
