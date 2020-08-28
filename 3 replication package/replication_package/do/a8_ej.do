// appendix A8 - characteristics of attritors

clear
set memory 500m
set matsize 100
set more off 
# delimit;


cd "~/Desktop/ej_final/replication_package/do/";


use ../dta/bas-mid-end-append_v2.dta;



*generating sumstats;
mat t=J(100,40,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

	sum `varlist'_b0 if sample == 0 & treatment == 3 & round == 2;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+2,1]=r(N);
	

	reg `varlist'_b0 ao  i.village_no if sample == 0 & round == 2, robust;
	mat t[`row',3]=_b[ao];
    mat t[`row'+1,3]=_se[ao];
  	mat t[`row'+2,3] =e(N);
	
	sum `varlist'_b0 if sample == 0 & treatment == 3 & round == 3;
	mat t[`row',5]=r(mean);
	mat t[`row'+1,5]=r(sd);
	mat t[`row'+2,5]=r(N);
	
    
    reg `varlist'_b0 ao  i.village_no if sample == 0 & round == 3 , robust;
	mat t[`row',7]=_b[ao];
    mat t[`row'+1,7]=_se[ao];
    mat t[`row'+2,7] =e(N);
    
  
	
end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist a0_2_age edu_years profit_w1 c1_3 c1_5a c2_3 c2_5a c3_3 c3_5a {;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+4;

};

lazystar, table(t) columns(1(2)20) coefs(20) rowgap(4) outsheet(../out/a8_ej);


