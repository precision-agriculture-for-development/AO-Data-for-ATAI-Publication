//table 5: effects on yield, demand, and profit 

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



*** FIRST GENERATE PANEL A AND B; 
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


** NEXT PANEL C, BECAUSE BDM data only exists at endline); 


* BOUGHT AO; 

** control mean;

	sum bought_ao if round == 3 & treatment == 3 ;
	mat t[26,1]=r(mean);
	mat t[27,1]=r(sd);
	mat t[28,1]=r(N);
	
** ancova - combined ao- both rounds;
	
	reghdfe bought_ao ever_aos if sample == 1 & round == 3 , absorb(village_no ) vce(r);
	mat t[26,3]=_b[ever_aos];
	mat t[27,3]=_se[ever_aos];
	mat t[29,3] =e(N);
	
** ancova - combined ao - both rounds, spillover controls;
	
	reghdfe bought_ao ever_aos  treatfrac if sample == 1 & round ==  3, absorb(village_no  peer ) vce(r);
	mat t[26,5]=_b[ever_aos];
	mat t[27,5]=_se[ever_aos];
	mat t[29,5] =e(N);
	
** ML/ancova - combined ao - both rounds, ML;

unab prepped: ls_*;

	pdslasso bought_ao ever_aos   ( _vill* `prepped'  treatfrac ) if sample == 1 & round == 3 , partial(  _vill*) r;
	mat t[26,7]=_b[ever_aos];
	mat t[27,7]=_se[ever_aos];
	mat t[29,7] =e(N);
	

* BDM bid; 

** control mean;

	sum bdmbidprice if round == 3 & treatment == 3 ;
	mat t[31,1]=r(mean);
	mat t[32,1]=r(sd);
	mat t[33,1]=r(N);
	
** ancova - combined ao- both rounds;
	
	reghdfe bdmbidprice ever_aos if sample == 1 & round == 3 , absorb(village_no ) vce(r);
	mat t[31,3]=_b[ever_aos];
	mat t[32,3]=_se[ever_aos];
	mat t[34,3] =e(N);
	
** ancova - combined ao - both rounds, spillover controls;
	
	reghdfe bdmbidprice ever_aos  treatfrac if sample == 1 & round ==  3 , absorb(village_no  peer ) vce(r);
	mat t[31,5]=_b[ever_aos];
	mat t[32,5]=_se[ever_aos];
	mat t[34,5] =e(N);
	
** ML/ancova - combined ao - both rounds, ML;

unab prepped: ls_*;

	pdslasso bdmbidprice ever_aos   ( _vill* `prepped'  treatfrac ) if sample == 1 & round == 3 , partial(  _vill*) r;
	mat t[31,7]=_b[ever_aos];
	mat t[32,7]=_se[ever_aos];
	mat t[34,7] =e(N);


end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 

cotton_yield wheat_yield cumin_yield
total_input_cost_w1  
profit_w1




  {;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};

replace varnames = "bought_ao" in 26; 
replace varnames = "bdmbidprice" in 31;


lazystar, table(t) columns(1(2)50) coefs(200) rowgap(5) outsheet(../out/t5_ej);


