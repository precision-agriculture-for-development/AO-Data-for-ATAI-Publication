//appendix A7, balance for peer regressions 

clear
set memory 500m
set matsize 11000
set more off 
# delimit;



cd "~/Desktop/ej_final/replication_package/do/";


* 1. first assess balance for study respondent peers; 


use ../dta/bas-mid-end-append_v2.dta;


*generating sumstats;
mat t=J(2000,50,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];



** study resps pp with no treatment refs;

	sum `varlist' if round == 1 & ao == 0 & treatfrac == 0 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+3,1]=r(N);
	

** ALL STUDY RESPS: fraction of treated peers; 
	
	reghdfe `varlist'  treatfrac  if round == 1 , absorb(village_no  peer) ;
	
	mat t[`row',3]=_b[treatfrac];
	mat t[`row'+1,3]=_se[treatfrac];

	mat t[`row'+3,3] =e(N);


end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 

a1_1_age

edu_years

b2_2

c1_3

info_index_a pest_index_bin_a

seed_index_bin_a

fert_index_bin_a


cotton_index_bin_a wheat_index_bin_a cumin_index_bin_a


{;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+4;

};


lazystar, table(t) columns(1(2)50) coefs(500) rowgap(4) outsheet(../out/a7_1_ej);




* 2. assess balance for nonstudy peers; 

use ../dta/peer_survey.dta, clear; 


** restrict to non-study respondents; 

keep if study_respondent == 0  ;


*create info and pest indices;

gen controlz = (t_refs_pct == 0); 


** info sources index; 

egen info_index_bin_a = weightave2(
f1_81_3 p1_9_3 ) , normby(controlz); 



** pest management index; 

* the study resp data uses the following pesticides: 
for chloro, phospha, imida, pride, acephate and dicofol;

* in contrast, the non-study results use the peer survey which only
collected info  on imida, pride and acephate ;


egen cotpest_index_bin_a = weightave2(p1_3_9   p1_5_9 
p1_3_10   p1_5_10 
p1_3_11   p1_5_11  ) , normby(controlz); 




mat t=J(300,50,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

   xtset village_no;
   
    sum `varlist' if t_refs_pct == 0  ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+2,1]=r(N);
    
  	reg `varlist' t_refs_pct dummy_2_refs-dummy_7_refs  , robust; 
    mat t[`row',3]=_b[t_refs_pct];
    mat t[`row'+1,3]=_se[t_refs_pct];
    mat t[`row'+2,3] =e(N);


end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1;

foreach x of varlist v2 v6 w0 c1_1  info_index_bin_a cotpest_index_bin_a
  {;


	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+4;
	
};

lazystar, table(t) columns(1(2)50) coefs(20) rowgap(4) outsheet(../out/a7_2_ej);


