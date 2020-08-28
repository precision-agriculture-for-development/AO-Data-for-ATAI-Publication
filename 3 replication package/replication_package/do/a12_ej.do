//Appendix A12 - Main Outcomes by Sub-Treatment Arms 



clear
clear matrix
clear mata
set maxvar 10000
set matsize 2000
set more off 

# delimit;


cd "~/Desktop/ej_final/replication_package/do/";



use ../dta/bas-mid-end-append_v2.dta;



 *generating sumstats;
mat t=J(2000,50,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

** control mean;

	sum `varlist'_b0 if round == 1 & treatment == 3 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+2,1]=r(N);
	
** aoe v control ;
	
	reghdfe `varlist' ever_aoe  `varlist'_b0 if sample == 1 & (treatment == 1 | treatment == 3) & round > 1, absorb(village_no round) vce(r);
	mat t[`row',3]=_b[ever_aoe];
	mat t[`row'+1,3]=_se[ever_aoe];
	mat t[`row'+3,3] =e(N);
	
** ao v control ;
	
	reghdfe `varlist' ever_ao  `varlist'_b0 if sample == 1 & (treatment == 2 | treatment == 3) & round > 1, absorb(village_no round) vce(r);
	mat t[`row',5]=_b[ever_ao];
	mat t[`row'+1,5]=_se[ever_ao];
	mat t[`row'+3,5] =e(N);
	
** aoe v ao ;
	
	reghdfe `varlist' ever_aoe  `varlist'_b0 if sample == 1 & (treatment == 1 | treatment == 2) & round > 1, absorb(village_no round) vce(r);
	mat t[`row',7]=_b[ever_aoe];
	mat t[`row'+1,7]=_se[ever_aoe];
	mat t[`row'+3,7] =e(N);
	
* reminder v control ;
	
	reghdfe `varlist' ever_reminder  `varlist'_b0 if sample == 1 & (ever_reminder == 1 | treatment == 3) & round > 1, absorb(village_no round) vce(r);
	mat t[`row',9]=_b[ever_reminder];
	mat t[`row'+1,9]=_se[ever_reminder];
	mat t[`row'+3,9] =e(N);

* reminder v combined treat ; 

	reghdfe `varlist' ever_reminder  `varlist'_b0 if sample == 1 & (treatment != 3) & round > 1, absorb(village_no round) vce(r);
	mat t[`row',11]=_b[ever_reminder];
	mat t[`row'+1,11]=_se[ever_reminder];
	mat t[`row'+3,11] =e(N);


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

total_input_cost_w1 totcost_irrig_rs_w1 

profit_w1

{;
line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};

lazystar, table(t) columns(1(2)36) coefs(50) rowgap(5) outsheet(../out/a12_ej);




