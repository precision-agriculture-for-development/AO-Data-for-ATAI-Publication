// appendix a3 - Effects on Sources of Information by Source and Decision Type 

clear
clear matrix
clear mata
set maxvar 10000
set matsize 2000
set more off 
# delimit;


cd "~/Desktop/ej_final/replication_package/do/";


use ../dta/bas-mid-end-append_v2.dta;


gen cot_post_M = c1_5a_b0*post_M;
gen cot_post_E = c1_5a_b0*post_E;


 *generating sumstats;
mat t=J(2000,50,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

** control mean;

	sum `varlist' if ao==0 & post_E == 0 ;
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sd);
	*mat t[`row'+2,1]=r(N);
	
** aoe + ao v control ;

	reg `varlist' ao post_M treatpost_M cot_post_M  c1_5a_b0 i.village_no , robust;
	
	mat t[`row',3]=_b[treatpost_M];
	mat t[`row'+1,3]=_se[treatpost_M];
	*mat t[`row'+2,3] =e(N);

** aoe + ao v control ;
	
	reg `varlist' ao post_E treatpost_E  cot_post_E c1_5a_b0 i.village_no , robust;
	
	mat t[`row',5]=_b[treatpost_E];
	mat t[`row'+1,5]=_se[treatpost_E];
	*mat t[`row'+2,5] =e(N);
		
	
end;

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist 

c1_source_1
f1_source_1
p1_source_1
c2_source_1
f2_source_1
p2_source_1
c3_source_1
f3_source_1
p3_source_1

c1_source_3
f1_source_3
p1_source_3
c2_source_3
f2_source_3
p2_source_3
c3_source_3
f3_source_3
p3_source_3

c1_source_5
f1_source_5
p1_source_5
c2_source_5
f2_source_5
p2_source_5
c3_source_5
f3_source_5
p3_source_5

c1_source_7
f1_source_7
p1_source_7
c2_source_7
f2_source_7
p2_source_7
c3_source_7
f3_source_7
p3_source_7

c1_source_8
f1_source_8
p1_source_8
c2_source_8
f2_source_8
p2_source_8
c3_source_8
f3_source_8
p3_source_8

 {;

line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+4;

};


lazystar, table(t) columns(1(2)36) coefs(500) rowgap(4) outsheet(../out/a3_ej);

	

