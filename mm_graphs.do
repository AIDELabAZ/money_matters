* Michler et al., 2018
*	THIS FILE PRODUCES THE GRAPHICS IN THE PAPER AND APPENDICES

use mm.dta, clear


****************************************************
****Figure 1: Adoption Rates************************
****************************************************

sort Year District
by Year: egen avg_adpt = mean( icp)

by Year District: egen avg_adpt_D = mean( icp)

gen yearc  = 1 if Year == 2008
replace yearc = 2 if Year == 2010
replace yearc = 3 if Year == 2014

twoway (line avg_adpt yearc, ytitle("Adoption Rate  (%)") ylabel(, labsize(small)) yscale(r(0 1)) lcolor(maroon) lpattern("_"))  || /// 
(line avg_adpt_D yearc if District==1, lcolor(navy) lpattern("-.")) || (line avg_adpt_D yearc if District==2, lcolor(dkgreen) lpattern("-.")) || ///
(line avg_adpt_D yearc if District==3, lcolor(dkorange) lpattern("-.")) || (scatter avg_adpt yearc, mcolor(maroon)) || ///
(scatter avg_adpt_D yearc if District==1, mcolor(navy)) || (scatter avg_adpt_D yearc if District==2, mcolor(dkgreen)) || ///
(scatter avg_adpt_D yearc if District==3, mcolor(dkorange) xtitle("Year") xscale(r(1 3)) xlabel(1 "2007" 2 "2010" 3 "2014", labsize(small))), ///
legend(on order(1 2 3 4) col(2) lab(1 "Average adoption rate") lab(2 "Gimbichu adoption rate") lab(3 "Lume-Ejere adoption rate") ///
lab(4 "Minjar-Shenkora adoption rate")  pos(6))


****************************************************
****Figure A1: Density of yields*********************
****************************************************

	lab var yield "Chickpea yield (kg/ha)"
	
twoway (kdensity yield if icp==1, bwidth(400) ytitle("Density") lcolor(navy) lpattern(solid) lwidth(medthick) range(0 6000))  || ///
(kdensity yield if icp==0, bwidth(400) xtitle("Yield (kg/ha)") lcolor(maroon) lpattern(longdash_dot) lwidth(medthick)), ///
legend(label(1 "Adopters") label(2 "Non-Adopters") rows(1) pos(6)) title("") 


****************************************************
****Figure A2: Density of costs**********************
****************************************************

	lab var cost "Production costs (USD/ha)"

twoway (kdensity cost if icp==1, bwidth(300) ytitle("Density") lcolor(navy) lpattern(solid) lwidth(medthick) range(0 2000))  || ///
(kdensity cost if icp==0, bwidth(300) xtitle("Production costs (USD/ha)") lcolor(maroon) lpattern(longdash_dot) lwidth(medthick) range(0 2000)), ///
legend(label(1 "Adopters") label(2 "Non-Adopters") rows(1) pos(6)) title("") 


****************************************************
****Figure A3: Density of profit*********************
****************************************************

	lab var profit "On-farm profit (USD/ha)"

twoway (kdensity profit if icp==1, bwidth(200) ytitle("Density") lcolor(navy) lpattern(solid) lwidth(medthick) range(0 4000))  || ///
(kdensity profit if icp==0, bwidth(200) xtitle("On-farm profit (USD/ha)") lcolor(maroon) lpattern(longdash_dot) lwidth(medthick)  range(0 4000)), ///
legend(label(1 "Adopters") label(2 "Non-Adopters") rows(1) pos(6)) title("") 


****************************************************
****Figure 2-4: Estimated returns*******************
****************************************************

*These graphics are produced directly from regression results. See mm_pub_tables.do
