//appendix a11 - Heterogenous Effects 



clear
clear matrix
clear mata
set maxvar 10000
set matsize 2000
set more off 


# delimit;



cd "~/Desktop/ej_final/replication_package/do/";


use ../dta/bas-mid-end-append_v2.dta;



** for education;

sum edu_years if round == 1 ,det; 

gen educ = (edu_years >= `r(p50)' & round == 1);

bysort uid: replace educ = educ[1];

gen ao_educ = educ*ao;


gen ever_aos_educ = ever_aos*educ; 


gen post_E_educ = educ*post_E if post_E!=. ; 
gen treatpost_E_educ = treatpost_E*educ if post_E!=. ; 

gen post_M_educ = educ*post_M if post_M!=. ; 
gen treatpost_M_educ = treatpost_M*educ if post_M!=. ; 




** income;
sum ag_income, det; 

gen incz = (ag_income >= `r(p50)' & round == 1 );

bysort uid: egen inc = max(incz) if round !=.;
drop incz; 

bysort uid: replace inc = inc[1];


gen ever_aos_inc = ever_aos*inc; 



*generating sumstats;
mat t=J(2000,50,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

** control mean;

	sum `varlist' if treatment == 3 & round == 1 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+2,1]=r(N);
    
    

** treat v control - educ ;
	
	reghdfe `varlist' ever_aos educ ever_aos_educ `varlist'_b0  if sample == 1 & round > 1, vce(r) absorb(village_no round);
	
	mat t[`row',3]=_b[ever_aos];
	mat t[`row'+1,3]=_se[ever_aos];
	
	mat t[`row',5]=_b[ever_aos_educ];
	mat t[`row'+1,5]=_se[ever_aos_educ];
	
	mat t[`row'+3,5]=e(N);
	


** treat v control - inc ;
	
	reghdfe `varlist' ever_aos inc ever_aos_inc   `varlist'_b0 if sample == 1 & round > 1, vce(r) absorb(village_no round);
	
	mat t[`row',7]=_b[ever_aos];
	mat t[`row'+1,7]=_se[ever_aos];
	
	mat t[`row',9]=_b[ever_aos_inc];
	mat t[`row'+1,9]=_se[ever_aos_inc];
	
	mat t[`row'+3,9]=e(N);


	
end;

 //varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist used_ao duration cotton_index_bin_a wheat_index_bin_a cumin_index_bin_a overall profit_w1

 cotton_yield wheat_yield cumin_yield   {;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};


lazystar, table(t) columns(1(2)50) coefs(500) rowgap(5) outsheet(../out/a11_ej);

