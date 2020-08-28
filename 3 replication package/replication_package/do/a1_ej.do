//appendix a1 - topics of questions asked and push calls  

	
clear 
clear matrix
set more off
set matsize 11000
# delimit;




cd "~/Desktop/ej_final/replication_package/do/";


use ../dta/ao_content_data.dta, clear; 


set obs 100;

*generating sumstats;
mat zzz=J(100,10,.);

local q = 1; 

foreach x of varlist  _all { ; 

local varlab: var label `x'; 

replace varlabels = "`varlab'" in `q';
replace varnames = "`x'" in `q';

sum `x';
mat zzz[`q',1]=r(mean);


local q = `q' + 1; 

};

svmat zzz;

outsheet varnames varlabels zzz*  using ../out/a1_ej.csv, comma replace;

