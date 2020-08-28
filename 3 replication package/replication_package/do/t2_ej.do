//table 2: usage of ao info service


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

** control mean at midline;

	sum `varlist' if round == 2 & treatment == 3 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+2,1]=r(N);
	
** ancova - combined ao- midline;
	
	reghdfe `varlist' ever_aos `varlist'_b0 if sample == 1 & round == 2, absorb(village_no round) vce(r);
	mat t[`row',3]=_b[ever_aos];
	mat t[`row'+1,3]=_se[ever_aos];
	mat t[`row'+3,3] =e(N);


** control mean at endline;

	sum `varlist' if round == 3 & treatment == 3 & sample == 1 ;
	mat t[`row',5]=r(mean);
	mat t[`row'+1,5]=r(sd);
	mat t[`row'+2,5]=r(N);
	
** ancova - combined ao- endline;

	reghdfe `varlist' ever_aos `varlist'_b0 if sample == 1 & round == 3 , absorb(village_no round) vce(r);
	mat t[`row',7]=_b[ever_aos];
	mat t[`row'+1,7]=_se[ever_aos];
	mat t[`row'+3,7] =e(N);
	
end;

//varnames & varlabel for sumstats;
gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist total_usage used_ao n_call duration    asked_q   pct_listened   
 {;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};

lazystar, table(t) columns(1(2)36) coefs(50) rowgap(5) outsheet(../out/t2_ej);


