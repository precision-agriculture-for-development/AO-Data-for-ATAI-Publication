//Appendix A15 - Heterogeneity with Respect to Village Size 


clear
clear matrix
clear mata
set maxvar 10000
set matsize 2000
set more off 

# delimit;

cd "~/Desktop/ej_final/replication_package/do/";

use ../dta/bas-mid-end-append_v2.dta;

** merge village info; 

merge m:1 village_no using ../dta/village_census_info, gen(census_merge) keep(1 3) ;

* vars to interact village size with treatment ; 

egen uniq_vil = tag(village_no);

sum pop if uniq_vil == 1, det;
gen pop_abmed = (pop >= `r(p50)'); 


drop prop_cult_abmed;

sum prop_cult if uniq_vil == 1, det;
gen prop_cult_abmed = (prop_cult >= `r(p50)'); 


gen ever_aos_pcult = ever_aos * prop_cult_abmed;
gen ever_aos_pop = ever_aos * pop_abmed; 


gen prop_cult_weight = 1 / prop_cult ;

*generating sumstats;
mat t=J(2000,50,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

** control mean;

	sum `varlist' if post_M == 0 & treatment == 3 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+2,1]=r(N);
	

** treat v control - ancova  ;
	
	reghdfe `varlist' ever_ao  `varlist'_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r);
	mat t[`row',3]=_b[ever_ao];
	mat t[`row'+1,3]=_se[ever_ao];
	mat t[`row'+3,3] =e(N);

	
** treat v control - heterogeneity by proportion of cultivators ;
	
	reghdfe `varlist' ever_ao prop_cult_abmed ever_aos_pcult  `varlist'_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r);
	mat t[`row',5]=_b[ever_ao];
	mat t[`row'+1,5]=_se[ever_ao];
	mat t[`row'+3,5] =e(N);
	
	mat t[`row',7]=_b[ever_aos_pcult];
	mat t[`row'+1,7]=_se[ever_aos_pcult];
	

** treat v control - heterogeneity by village size ;

	
	reghdfe `varlist' ever_ao pop_abmed ever_aos_pop  `varlist'_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r);
	mat t[`row',9]=_b[ever_ao];
	mat t[`row'+1,9]=_se[ever_ao];
	mat t[`row'+3,9] =e(N);
	
	mat t[`row',11]=_b[ever_aos_pop];
	mat t[`row'+1,11]=_se[ever_aos_pop];


** treat v control - proportion of cultivators as weights; 

	reghdfe `varlist' ever_ao  `varlist'_b0 [pweight = prop_cult_weight] if sample == 1 & round > 1, absorb(village_no round) vce(r);
	mat t[`row',13]=_b[ever_ao];
	mat t[`row'+1,13]=_se[ever_ao];
	mat t[`row'+3,13] =e(N);
	

end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 


total_usage 
info_index_a 
cotton_index_bin_a wheat_index_bin_a cumin_index_bin_a
seed_index_bin_a pest_index_bin_a fert_index_bin_a
overall
cotton_yield wheat_yield cumin_yield

totcost_irrig_rs_w1 total_input_cost_w1  profit_w1

 


{;
line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};

lazystar, table(t) columns(1(2)36) coefs(50) rowgap(5) outsheet(../out/a15_ej);




