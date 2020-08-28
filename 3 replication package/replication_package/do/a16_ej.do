//Appendix A16 - Results from WTP Experiments 

clear
clear mata
clear matrix
set maxvar 10000
set matsize 5000
set more off 


# delimit;


cd "~/Desktop/ej_final/replication_package/do/";


** PANEL A; 



use ../dta/wtp_panel_a.dta, clear;

drop if m2=="W2";
replace bdmbidprice=0 if bdmbidprice==.;
la var bdmbidprice "Maximum willingness to pay (rupees)";
** we want to find max wtp for those who participated in bdm;


*generating sumstats;
mat t=J(20,20,.);

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

** Entire Sample;

	sum `varlist';
	mat t[`row',1]=r(mean);
	mat t[`row'+1,1]=r(sum);

	
	mat t[`row'+3,1]=r(N);
	
** Study Sample;
	sum `varlist' if treatment!=.;
	mat t[`row',3]=r(mean);
	mat t[`row'+1,3]=r(sum);

	
	mat t[`row'+3,3]=r(N);
	
** Treatment;
	sum `varlist' if treatment==1|treatment==2;
	mat t[`row',5]=r(mean);
	mat t[`row'+1,5]=r(sum);

	mat t[`row'+3,5]=r(N);
	
		
** Control;
	sum `varlist' if treatment==3;
	mat t[`row',7]=r(mean);
	mat t[`row'+1,7]=r(sum);

	mat t[`row'+3,7]=r(N);
	
** Non-Study;
	sum `varlist' if treatment==.;
	mat t[`row',9]=r(mean);
	mat t[`row'+1,9]=r(sum);

	mat t[`row'+3,9]=r(N);
	
end;

 //varnames & varlabel for sumstats;

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist bdmbidprice bought_ao

  {;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+4;

};

lazystar, table(t) columns(1(2)10) coefs(10) rowgap(4) outsheet(../out/a16_panel_a);




** PANEL B; 

use ../dta/wtp_panel_b.dta, replace;


gen ao_treat = (treatment == 1 | treatment == 2); 

** Constructing matrix;

*generating sumstats;
mat t=J(2000,500,.);


cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];

** offerprice treatment and total_duration;

	reg allbuy price ao_treat total_duration, cluster(uid) robust;
	mat t[1,1]=_b[price];
	mat t[1+1,1]=_se[price];
	mat t[1+2,1] =e(N);
	
	mat t[5,1]=_b[ao_treat];
	mat t[5+1,1]=_se[ao_treat];
	
	mat t[9,1]=_b[total_duration];
	mat t[9+1,1]=_se[total_duration];

** offerprice treatment and total_duration and education;

	reg allbuy price ao_treat total_duration edu_years, cluster(uid) robust;
	mat t[1,3]=_b[price];
	mat t[1+1,3]=_se[price];
	mat t[1+2,3] =e(N);
	
	mat t[5,3]=_b[ao_treat];
	mat t[5+1,3]=_se[ao_treat];
	
	mat t[9,3]=_b[total_duration];
	mat t[9+1,3]=_se[total_duration];
	
	mat t[13,3]=_b[edu_years];
	mat t[13+1,3]=_se[edu_years];
	
* offerprice treatment and total_duration and knowledge;

	reg allbuy price ao_treat total_duration overall, cluster(uid) robust;
	mat t[1,5]=_b[price];
	mat t[1+1,5]=_se[price];
	mat t[1+2,5] =e(N);
	
	mat t[5,5]=_b[ao_treat];
	mat t[5+1,5]=_se[ao_treat];
	
	mat t[9,5]=_b[total_duration];
	mat t[9+1,5]=_se[total_duration];
	
	mat t[17,5]=_b[overall];
	mat t[17+1,5]=_se[overall];
** offerprice treatment and total_duration and acreage;

	reg allbuy price ao_treat total_duration c1_5a, cluster(uid) robust;
	mat t[1,7]=_b[price];
	mat t[1+1,7]=_se[price];
	mat t[1+2,7] =e(N);
	
	mat t[5,7]=_b[ao_treat];
	mat t[5+1,7]=_se[ao_treat];
	
	mat t[9,7]=_b[total_duration];
	mat t[9+1,7]=_se[total_duration];
	
	mat t[21,7]=_b[c1_5a];
	mat t[21+1,7]=_se[c1_5a];
	
** offerprice treatment and total_duration and refs;

	reg allbuy price ao_treat total_duration treated_peer, cluster(uid) robust;
	mat t[1,9]=_b[price];
	mat t[1+1,9]=_se[price];
	mat t[1+2,9] =e(N);
	
	mat t[5,9]=_b[ao_treat];
	mat t[5+1,9]=_se[ao_treat];
	
	mat t[9,9]=_b[total_duration];
	mat t[9+1,9]=_se[total_duration];
	
	mat t[25,9]=_b[treated_peer];
	mat t[25+1,9]=_se[treated_peer];
	
** offerprice treatment and total_duration and skepz;

	reg allbuy price ao_treat total_duration skepz, cluster(uid) robust;
	mat t[1,11]=_b[price];
	mat t[1+1,11]=_se[price];
	mat t[1+2,11] =e(N);
	
	mat t[5,11]=_b[ao_treat];
	mat t[5+1,11]=_se[ao_treat];
	
	mat t[9,11]=_b[total_duration];
	mat t[9+1,11]=_se[total_duration];
	
	mat t[29,11]=_b[skepz];
	mat t[29+1,11]=_se[skepz];
	
** offerprice treatment and total_duration and age;

	reg allbuy price ao_treat total_duration a0_2_age, cluster(uid) robust;
	mat t[1,13]=_b[price];
	mat t[1+1,13]=_se[price];
	mat t[1+2,13] =e(N);
	
	mat t[5,13]=_b[ao_treat];
	mat t[5+1,13]=_se[ao_treat];
	
	mat t[9,13]=_b[total_duration];
	mat t[9+1,13]=_se[total_duration];
	
	mat t[33,13]=_b[a0_2_age];
	mat t[33+1,13]=_se[a0_2_age];
	
** all vars;
	reg allbuy price ao_treat total_duration edu_years overall c1_5a treated_peer skepz a0_2_age, cluster(uid) robust;
	mat t[1,15]=_b[price];
	mat t[1+1,15]=_se[price];
	mat t[1+2,15] =e(N);
	
	mat t[5,15]=_b[ao_treat];
	mat t[5+1,15]=_se[ao_treat];
	
	mat t[9,15]=_b[total_duration];
	mat t[9+1,15]=_se[total_duration];
	
	mat t[13,15]=_b[edu_years];
	mat t[13+1,15]=_se[edu_years];
	
	mat t[17,15]=_b[overall];
	mat t[17+1,15]=_se[overall];
	
	mat t[21,15]=_b[c1_5a];
	mat t[21+1,15]=_se[c1_5a];
	
	mat t[25,15]=_b[treated_peer];
	mat t[25+1,15]=_se[treated_peer];
	
	mat t[29,15]=_b[skepz];
	mat t[29+1,15]=_se[skepz];
	
	mat t[33,15]=_b[a0_2_age];
	mat t[33+1,15]=_se[a0_2_age];

end;

//varnames & varlabel for sumstats;

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist price ao_treat total_duration edu_years overall c1_5a treated_peer skepz a0_2_age
  {;

	line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+4;

};

lazystar, table(t) columns(1(2)100) coefs(500) rowgap(4) outsheet(../out/a16_panel_b);

