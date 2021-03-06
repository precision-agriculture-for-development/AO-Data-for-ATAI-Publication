//table a10: Effects on Agricultural Knowledge


clear
clear mata
clear matrix
set maxvar 9000
set matsize 7000
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

	sum `varlist' if round == 1 & treatment == 3 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+2,1]=r(N);
	
** ancova - combined ao- both rounds;
	
	reghdfe `varlist' ever_aos `varlist'_b0 if sample == 1 & round > 1, absorb(village_no round) vce(r);
	mat t[`row',3]=_b[ever_aos];
	mat t[`row'+1,3]=_se[ever_aos];
	mat t[`row'+3,3] =e(N);
	
** ancova - combined ao - both rounds, spillover controls;
	
	reghdfe `varlist' ever_aos `varlist'_b0  treatfrac if sample == 1 & round  >  1, absorb(village_no round peer ) vce(r);
	mat t[`row',5]=_b[ever_aos];
	mat t[`row'+1,5]=_se[ever_aos];
	mat t[`row'+3,5] =e(N);
	
** ML/ancova - combined ao - both rounds, ML;

unab prepped: ls_*;

	pdslasso `varlist' ever_aos   ( _vill* `prepped'  `varlist'_b0 treatfrac round) if sample == 1 & round > 1 , partial( round _vill*) r;
	mat t[`row',7]=_b[ever_aos];
	mat t[`row'+1,7]=_se[ever_aos];
	mat t[`row'+3,7] =e(N);
	
end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 

overall C_correct W_correct J_correct pest fert
 {;
line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+4;

};

lazystar, table(t) columns(1(2)36) coefs(50) rowgap(4) outsheet(../out/a10_ej);




