//Appendix A17 - Yield Results by Survey Round  


clear
clear matrix
clear mata
set maxvar 20000
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
	
** ancova - combined ao- both rounds;
	
	reghdfe `varlist' ever_aos  `varlist'_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r);
	mat t[`row',3]=_b[ever_aos];
	mat t[`row'+1,3]=_se[ever_aos];
	mat t[`row'+3,3] =e(N);
	
** ancova - combined ao- midline ;
	
	reghdfe `varlist' ever_aos  `varlist'_b0 if sample == 1 & round  == 2, absorb(village_no ) vce(r);
	mat t[`row',5]=_b[ever_aos];
	mat t[`row'+1,5]=_se[ever_aos];
	mat t[`row'+3,5] =e(N);
	
** ancova - combined ao-  endline ;
	
	reghdfe `varlist' ever_aos  `varlist'_b0 if sample == 1 & round ==  3, absorb(village_no ) vce(r);
	mat t[`row',7]=_b[ever_aos];
	mat t[`row'+1,7]=_se[ever_aos];
	mat t[`row'+3,7] =e(N);

** dd - combined ao- both rounds ;
	
	reghdfe `varlist' ever_aos  aos_postr  if sample == 1, absorb(village_no round) vce(r);
	mat t[`row',9]=_b[aos_postr];
	mat t[`row'+1,9]=_se[aos_postr];
	mat t[`row'+3,9] =e(N);
	
** dd - combined ao- midline ;
	
	reghdfe `varlist' ever_aos  aos_postr  if sample == 1 & (round == 1 | round == 2), absorb(village_no round) vce(r);
	mat t[`row',11]=_b[aos_postr];
	mat t[`row'+1,11]=_se[aos_postr];
	mat t[`row'+3,11] =e(N);
	
** dd - combined ao- endline ;
	
	reghdfe `varlist' ever_aos  aos_postr  if sample == 1 & (round == 1 | round == 3), absorb(village_no round) vce(r);
	mat t[`row',13]=_b[aos_postr];
	mat t[`row'+1,13]=_se[aos_postr];
	mat t[`row'+3,13] =e(N);
	
	
end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 

cotton_yield cumin_yield wheat_yield



{;
line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};

lazystar, table(t) columns(1(2)38) coefs(50) rowgap(5) outsheet(../out/a17_ej);




