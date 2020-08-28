//appendix a24 showing spillover effects 
//includes ej edits 


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

** study resps with no treatment refs;

	sum `varlist' if round == 1 & ao == 0 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+3,1]=r(N);
	

** ALL STUDY RESPS: fraction of treated peers; 
	
	reghdfe `varlist' ever_aos treatfrac treat_treatfrac `varlist'_b0 if round > 1 & sample == 1 , absorb(village_no round peer) ;

	mat t[`row',3]=_b[ever_aos];
	mat t[`row'+1,3]=_se[ever_aos];
	
	mat t[`row',5]=_b[treatfrac];
	mat t[`row'+1,5]=_se[treatfrac];

	mat t[`row',7]=_b[treat_treatfrac];
	mat t[`row'+1,7]=_se[treat_treatfrac];

	mat t[`row'+3,7] =e(N);

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

lazystar, table(t) columns(1(2)36) coefs(50) rowgap(5) outsheet(../out/a24_ej);




