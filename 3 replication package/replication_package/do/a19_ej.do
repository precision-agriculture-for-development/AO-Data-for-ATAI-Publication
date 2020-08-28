//Appendix A19  - Effects on Sowing  by Survey Round 


clear
clear matrix
clear mata
set maxvar 10000
set matsize 2000
set more off 

# delimit;


cd "~/Desktop/ej_final/replication_package/do/";



use ../dta/bas-mid-end-append_v2.dta;


* restrict to only those who were offered bdm or tioli; 

replace bought_ao = . if m2 == ""; 

* but replace purchase decision to 0 if they were not interested in game; 

replace bought_ao = 0 if m2 == ""  & sample == 1; 

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

end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 

c1_3 c2_3 c3_3 




  {;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};


lazystar, table(t) columns(1(2)50) coefs(200) rowgap(5) outsheet(../out/a19_ej);


