// figure 3  - ao usage by month 
 
clear
clear mata
clear matrix
set maxvar 10000
set matsize 5000
set more off 
# delimit;


cd "~/Desktop/ej_final/replication_package/do/";


** Panel A; 


use ../dta/incoming_monthly_data.dta, clear; 



graph twoway (line avg_dur month, lcolor(black) lpattern(dot) lwidth(0.3)) (line avg_dur_aoe month, lcolor(black) lpattern(dash) lwidth(0.3)) (line avg_dur_ao month, lcolor(black) lpattern(dash_dot) lwidth(0.3)) (line avg_dur_rem month, lcolor(black) lwidth(0.3)), ysize(9) xsize(11) ///
title("Average AO Usage By Month", size(medsmall)) ///
	legend(label(1 "AO+AOE") label(2 "AOE") label(3 "AO") label(4 "Reminder") rows(1) size(small) margin(zero)) ///
	ylabel(0 10 20 30 40, labsize(vsmall)) ///
	ytitle("Average Monthly Usage (Minutes)", size(vsmall) margin(small)) ///
	xline(9, lwidth(0.3) lcolor(ltblue)) xline(10, lwidth(0.3) lcolor(ltblue)) xline(11, lwidth(0.3) lcolor(ltblue))  
    xline(18, lwidth(0.3) lcolor(ltblue)) xline(19, lwidth(0.3) lcolor(ltblue))
	xline(22, lwidth(0.3) lcolor(ltblue)) xline(23, lwidth(0.3) lcolor(ltblue)) xline(30, lwidth(0.3) lcolor(ltblue)) xline(31, lwidth(0.3) lcolor(ltblue)) xline(32, lwidth(0.3) lcolor(ltblue)) ///
	xscale(range(9 31)) ///
	xlabel( 9  10  11 18 19  22  23   
	30  31 32 , labsize(vsmall) angle(45)) ///
	xtitle("Month", size(vsmall) margin(small));
	graph save ../out/f3_panel_a.gph, replace;
	graph export ../out/f3_panel_a.pdf, replace;
	


** Panel B; 


use ../dta/push_call_monthly_data.dta, clear; 



graph twoway (line avg_duration_month month,  lcolor(black) lpattern(dot) lwidth(0.3)) (line avg_duration_month_aoe month, lcolor(black) lpattern(dash) lwidth(0.3)) (line avg_duration_month_ao month, lcolor(black) lpattern(dash_dot) lwidth(0.3)) (line avg_duration_month_rem month, lcolor(black) lwidth(0.3)), ysize(9) xsize(11) ///
title("Average Percentage of Push Call Listened to by Month", size(medsmall)) ///
	legend(label(1 "AO+AOE") label(2 "AOE") label(3 "AO") label(4 "Reminder") rows(1) size(small) margin(zero)) ///
	ylabel(0 0.2 0.4 0.6 0.8 1, labsize(vsmall)) ///
	ytitle("Percentage of Total Push Call Listened", size(vsmall) margin(small)) ///
	xline(9, lwidth(0.3) lcolor(ltblue)) xline(10, lwidth(0.3) lcolor(ltblue)) xline(11, lwidth(0.3) lcolor(ltblue))  
    xline(18, lwidth(0.3) lcolor(ltblue)) xline(19, lwidth(0.3) lcolor(ltblue))
	xline(22, lwidth(0.3) lcolor(ltblue)) xline(23, lwidth(0.3) lcolor(ltblue)) xline(30, lwidth(0.3) lcolor(ltblue)) xline(31, lwidth(0.3) lcolor(ltblue)) xline(32, lwidth(0.3) lcolor(ltblue)) ///
	xscale(range(9 32)) ///
	xlabel( 9  10  11 18 19  22  23   
	30  31 32 , labsize(vsmall) angle(45)) ///
	xtitle("Month", size(vsmall) margin(small));
	graph save ../out/f3_panel_b.gph, replace;
	graph export ../out/f3_panel_b.pdf, replace;
	

