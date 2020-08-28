//Appendix A9 - Adjusting P-Values for Family-wise Error Rate				


clear
clear matrix
clear mata
set more off 

# delimit;

cd "~/Desktop/ej_final/replication_package/do/";



use *bin* ever_*  yield_index_a yield_index_a_b0 info_index_a info_index_a_b0 overall overall_b0 overall_index_a
 overall_index_a_b0 sample uid treatfrac peer _vill* ls_* round village_no using ../dta/bas-mid-end-append_v2.dta;



* Panel A; 

* information, input, yield, knowledge, overall;

unab prepped: ls_*;


cap wyoung, cmd(

"cap reghdfe info_index_a ever_aos info_index_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe info_index_a  ever_aos info_index_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso info_index_a  ever_aos ( _vill* `prepped'  info_index_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe input_index_bin_a ever_aos input_index_bin_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe input_index_bin_a  ever_aos input_index_bin_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso input_index_bin_a  ever_aos ( _vill* `prepped'  input_index_bin_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe yield_index_a ever_aos yield_index_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe yield_index_a  ever_aos yield_index_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso yield_index_a  ever_aos ( _vill* `prepped'  yield_index_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe overall ever_aos overall_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe overall  ever_aos overall_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso overall  ever_aos ( _vill* `prepped'  overall_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe overall_index_a ever_aos overall_index_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe overall_index_a  ever_aos overall_index_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso overall_index_a  ever_aos ( _vill* `prepped'  overall_index_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"
) 

familyp(ever_aos) bootstraps(500) seed(2282020) replace; 

outsheet using ../out/a9_panel_A.csv, comma replace;


** Panel B; 

* input indices; 


unab prepped: ls_*;


cap wyoung, cmd(

"cap reghdfe cotton_index_bin_a ever_aos cotton_index_bin_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe cotton_index_bin_a  ever_aos cotton_index_bin_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso cotton_index_bin_a  ever_aos ( _vill* `prepped'  cotton_index_bin_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe cumin_index_bin_a ever_aos cumin_index_bin_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe cumin_index_bin_a ever_aos cumin_index_bin_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso cumin_index_bin_a ever_aos ( _vill* `prepped'  cumin_index_bin_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe wheat_index_bin_a ever_aos wheat_index_bin_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe wheat_index_bin_a ever_aos wheat_index_bin_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso wheat_index_bin_a ever_aos ( _vill* `prepped'  wheat_index_bin_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe seed_index_bin_a ever_aos seed_index_bin_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe seed_index_bin_a ever_aos seed_index_bin_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso seed_index_bin_a ever_aos ( _vill* `prepped'  seed_index_bin_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe pest_index_bin_a ever_aos pest_index_bin_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe pest_index_bin_a ever_aos pest_index_bin_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso pest_index_bin_a ever_aos ( _vill* `prepped'  pest_index_bin_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"

"cap reghdfe fert_index_bin_a ever_aos fert_index_bin_a_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r)"
"cap reghdfe fert_index_bin_a ever_aos fert_index_bin_a_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer) vce(r)"
"cap pdslasso fert_index_bin_a ever_aos ( _vill* `prepped'  fert_index_bin_a_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r"
) 

familyp(ever_aos) bootstraps(500) seed(2282020) replace; 

outsheet using ../out/a9_panel_B.csv, comma replace;

