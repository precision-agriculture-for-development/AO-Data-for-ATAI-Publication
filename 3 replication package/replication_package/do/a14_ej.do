//Appendix A14 - Effects on Components of Cotton Index  


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

s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 s1_seeduse_5 s1_seeduse_6 s1_seeduse_9
p1_7c6 p1_7c6_use p1_8c1 p1_8c1_use p1_71_8 p1_71_8_use p1_71_9 p1_71_9_use   
p1_71_10 p1_71_10_use p1_8c6 p1_10tf f1_8b f1_8b_use f1_8d f1_8d_use     
f1_8e f1_8e_use  f1_12a  f1_12a_use f1_12b  f1_12b_use f1_12d  f1_12d_use 

{;
line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};

lazystar, table(t) columns(1(2)36) coefs(50) rowgap(5) outsheet(../out/a14_ej);




