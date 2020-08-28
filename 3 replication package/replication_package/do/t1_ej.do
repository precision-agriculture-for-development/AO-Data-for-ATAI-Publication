//table 1: summary statistics and balance

clear
clear mata
clear matrix
set maxvar 10000
set matsize 5000
set more off 


# delimit;

cd "~/Desktop/ej_final/replication_package/do/";


use ../dta/bas-mid-end-append_v2.dta;


dog
*generating sumstats;
mat t=J(1000,70,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

** control mean;

	sum `varlist' if round == 1 & treatment == 3 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+2,1]=r(N);
	
** combined ao- both rounds;
	
	reghdfe `varlist' ever_aos  if sample == 1 & round == 1, absorb(village_no) vce(r);
	mat t[`row',3]=_b[ever_aos];
	mat t[`row'+1,3]=_se[ever_aos];
	mat t[`row'+3,3] =e(N);
	
** aoe - control;
	
	reghdfe `varlist' ever_aoe  treatfrac if sample == 1 & round  ==  1 & (treatment == 1 | treatment == 3), absorb(village_no) vce(r);
	mat t[`row',5]=_b[ever_aoe];
	mat t[`row'+1,5]=_se[ever_aoe];
	mat t[`row'+3,5] =e(N);
	
		
** ao - control;
	
	reghdfe `varlist' ever_ao  treatfrac if sample == 1 & round  ==  1 & (treatment == 2 | treatment == 3), absorb(village_no  ) vce(r);
	mat t[`row',7]=_b[ever_ao];
	mat t[`row'+1,7]=_se[ever_ao];
	mat t[`row'+3,7] =e(N);


** aoe - ao;
	reghdfe `varlist' ever_aoe  treatfrac if sample == 1 & round  ==  1 & (treatment == 1 | treatment == 2), absorb(village_no round peer) vce(r);
	mat t[`row',9]=_b[ever_aoe];
	mat t[`row'+1,9]=_se[ever_aoe];
	mat t[`row'+3,9] =e(N);


	
end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 
a0_2_age edu_years b2_2 profit_w1 
info_index_a cotton_index_bin_a wheat_index_bin_a cumin_index_bin_a pest_index_bin_a fert_index_bin_a 
c1_3 c1_5a c1_5a_11 c2_3 c2_5a c3_3 c3_5a 

 {;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};

lazystar, table(t) columns(1(2)10) coefs(150) rowgap(5) outsheet(../out/t1_ej);



