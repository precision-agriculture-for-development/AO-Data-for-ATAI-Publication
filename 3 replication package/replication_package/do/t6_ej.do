//table 6 : spillover and peer effects


clear
clear matrix
clear mata
set maxvar 10000
set matsize 2000
set more off 

# delimit;


cd "~/Desktop/ej_final/replication_package/do/";


use ../dta/bas-mid-end-append_v2.dta, clear;


*** first compute effects for study respondents (columns 1-4); 


*generating sumstats;
mat t=J(2000,50,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

** study resps pp with no treatment refs;

	sum `varlist' if round == 1 & treatment == 3;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	mat t[`row'+3,1]=r(N);
	

** ALL STUDY RESPS: fraction of treated peers; 
	
	reghdfe `varlist' ever_aos treatfrac treat_treatfrac `varlist'_b0 if round > 1 & sample == 1 , absorb(village_no round peer) ;

	mat t[`row',3]=_b[ever_aos];
	mat t[`row'+1,3]=_se[ever_aos];
	
	mat t[`row',5]=_b[treatfrac];
	mat t[`row'+1,5]=_se[treatfrac];

	mat t[`row',7]=_b[treat_treatfrac];
	mat t[`row'+1,7]=_se[treat_treatfrac];

	mat t[`row'+3,7] =e(N);

end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 

called_ao

total_duration

info_index_a
pest_index_bin_a




{;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+5;

};


lazystar, table(t) columns(1(2)50) coefs(500) rowgap(5) outsheet(../out/t6_1_ej);




** 2. Calculate peer effects for non-study peers (columns 5 and 6) ;

use ../dta/peer_survey.dta, clear; 


* restrict to non-study respondents; 

keep if study_respondent == 0;



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

   
   qui sum `varlist' if t_refs_pct == 0; 
   mat t[`row',1] = r(mean); 
   mat t[`row'+1,1] = r(sd); 
   mat t[`row'+2,1] = r(N); 
   
   qui reg `varlist' t_refs_pct dummy_2_refs-dummy_7_refs  part1 i.village_no , robust ;
   mat t[`row',3]=_b[t_refs_pct];
   mat t[`row'+1,3]=_se[t_refs_pct];
   mat t[`row'+2,3] =e(N);
 


end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist  info_index_bin_a c1_21_per cotpest_index_bin_a 
{; 

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+4;
	
};

lazystar, table(t) columns(1(2)31) coefs(54) rowgap(4) outsheet(../out/t6_2_ej);


