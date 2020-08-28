// appendix a2 - randomization check - endine data 


clear
# delimit;
clear matrix;
clear mata;
set matsize 10000;
set more off;
set maxvar 10000;



cd "~/Desktop/ej_final/replication_package/do/";


use ../dta/bas-mid-end-append_v2.dta;


*generating sumstats;
mat t=J(10000,10,.);

keep if round == 3; 

* drop variables that are not outcomes or transformations of other data; 

drop   village_no _vill* ext_rabi_nov11 ext_rabi_nov11_F1
 
treatment_1 treatment_2  aoe ao_post aoe_post ao_postr
 aoe_postr ao_round_2 ao_round_3 ever_aoe ever_ao ever_aos 
 treat_1_peer treat_2_peer treated_peer treat_treated_peer 
 treat_treatfrac treatment

remindercall peer_reminder general_reminder reminder_call 
peer_reminder_F1 general_reminder_F1 reminder_call_F1 ever_reminder

post_M post_E treatpost_M treatpost_E ao_post aoe_post post_round
 ao_postr aoe_postr bas_cot_post_M bas_cot_post_E
  
  
  sc_study_resps sc_treat_resps listed_peers sc_study_resp sc_treat_resp sc_treat_frac
  
  control_peer study_resp_peer peer non_study treat_frac_peer  bas_cot peerz  
   in_degree treatfrac m_treatfrac has_treated_peer
  
  phonesurvey both round_2 round_3 _round3 _round2 _round1 _m_lasso round controlz sample
  
  ls_*  *_b0 *_win *_w1 *_w2 *_w3 *_sinh
  
  log_inc log_totcost_input_rs log_totcost_irrig_rs profit_log 
  
   *index_*
  
end consent_cat ag_profit1 Endline Treatment Midline
  
 ;
  
  
  
  
set obs 10000;

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];
	

	cap reg `varlist' ao  , robust;
	cap mat t[`row',1]=abs(_b[ao]/_se[ao]);

	
end;


** figure out how many numeric vars and where they are; 

qui ds, has(type numeric);
local count: word count `r(varlist)';
di `count';

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist  `r(varlist)' {;

	cap line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+1;

};

svmat t;
keep varnames varlabs t1;

** now compute number of significant variables; 

foreach i of numlist 1 {; 

gen sig1_`i' = 1 if t`i' > 2.57; 
replace sig1_`i' = 0 if sig1_`i' == . ;
gen sig5_`i' = 1 if t`i' > 1.96; 
replace sig5_`i' = 0 if sig5_`i' == . ;
gen sig10_`i' = 1 if t`i' > 1.646; 
replace sig10_`i' = 0 if sig10_`i' == .;

};

drop if t1 == . ;

outsheet varnames varlabs t* sig* using ../out/a2_1_endline.csv, comma replace; 




use ../dta/bas-mid-end-append_v2.dta, clear; 

estimates clear; 


*generating sumstats;
mat t=J(10000,10,.);

keep if round == 1; 

* drop variables that are not outcomes or transformations of other data; 

drop   village_no _vill* ext_rabi_nov11 ext_rabi_nov11_F1
 
treatment_1 treatment_2  aoe ao_post aoe_post ao_postr
 aoe_postr ao_round_2 ao_round_3 ever_aoe ever_ao ever_aos 
 treat_1_peer treat_2_peer treated_peer treat_treated_peer 
 treat_treatfrac treatment

remindercall peer_reminder general_reminder reminder_call 
peer_reminder_F1 general_reminder_F1 reminder_call_F1 ever_reminder

post_M post_E treatpost_M treatpost_E ao_post aoe_post post_round
 ao_postr aoe_postr bas_cot_post_M bas_cot_post_E
  
  
  sc_study_resps sc_treat_resps listed_peers sc_study_resp sc_treat_resp sc_treat_frac
  
  control_peer study_resp_peer peer non_study treat_frac_peer  bas_cot peerz  
   in_degree treatfrac m_treatfrac has_treated_peer
  
  phonesurvey both round_2 round_3 _round3 _round2 _round1 _m_lasso round controlz sample
  
  ls_*  *_b0 *_win *_w1 *_w2 *_w3 *_sinh
  
  log_inc log_totcost_input_rs log_totcost_irrig_rs profit_log 
  
   *index_*
  
end consent_cat ag_profit1 Endline Treatment Midline
  
 ;
  
  

set obs 10000;

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];
	

	cap reg `varlist' ao  , robust;
	cap mat t[`row',1]=abs(_b[ao]/_se[ao]);

	
end;


** figure out how many numeric vars and where they are; 

qui ds, has(type numeric);
local count: word count `r(varlist)';
di `count';

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist  `r(varlist)' {;

	cap line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+1;

};

svmat t;
keep varnames varlabs t1;

** now compute number of significant variables; 

foreach i of numlist 1 {; 

gen sig1_`i' = 1 if t`i' > 2.57; 
replace sig1_`i' = 0 if sig1_`i' == . ;
gen sig5_`i' = 1 if t`i' > 1.96; 
replace sig5_`i' = 0 if sig5_`i' == . ;
gen sig10_`i' = 1 if t`i' > 1.646; 
replace sig10_`i' = 0 if sig10_`i' == .;

};

drop if t1 == . ;


outsheet varnames varlabs t* sig* using ../out/a2_2_baseline.csv, comma replace; 




use ../dta/bas-mid-end-append_v2.dta, clear; 


estimates clear; 


*generating sumstats;
mat t=J(10000,10,.);

keep if round == 2; 

* drop variables that are not outcomes or transformations of other data; 

drop   village_no _vill* ext_rabi_nov11 ext_rabi_nov11_F1
 
treatment_1 treatment_2  aoe ao_post aoe_post ao_postr
 aoe_postr ao_round_2 ao_round_3 ever_aoe ever_ao ever_aos 
 treat_1_peer treat_2_peer treated_peer treat_treated_peer 
 treat_treatfrac treatment

remindercall peer_reminder general_reminder reminder_call 
peer_reminder_F1 general_reminder_F1 reminder_call_F1 ever_reminder

post_M post_E treatpost_M treatpost_E ao_post aoe_post post_round
 ao_postr aoe_postr bas_cot_post_M bas_cot_post_E
  
  
  sc_study_resps sc_treat_resps listed_peers sc_study_resp sc_treat_resp sc_treat_frac
  
  control_peer study_resp_peer peer non_study treat_frac_peer  bas_cot peerz  
   in_degree treatfrac m_treatfrac has_treated_peer
  
  phonesurvey both round_2 round_3 _round3 _round2 _round1 _m_lasso round controlz sample
  
  ls_*  *_b0 *_win *_w1 *_w2 *_w3 *_sinh
  
  log_inc log_totcost_input_rs log_totcost_irrig_rs profit_log 
  
   *index_*
  
end consent_cat ag_profit1 Endline Treatment Midline
  
 ;
  

set obs 10000;

cap program drop line;
program define line;
syntax varlist, row(string) [absorb(passthru)];
	

	cap reg `varlist' ao  , robust;
	cap mat t[`row',1]=abs(_b[ao]/_se[ao]);

	
end;


** figure out how many numeric vars and where they are; 

qui ds, has(type numeric);
local count: word count `r(varlist)';
di `count';

//varnames & varlabel for sumstats

gen varnames="";
gen varlabs="";

local j=1; 

foreach x of varlist  `r(varlist)' {;

	cap line `x', row(`j');
	replace varnames = "`x'" in `j';
	local varlab: variable label `x';
	replace varlabs = "`varlab'" in `j';  
	local j = `j'+1;

};

svmat t;
keep varnames varlabs t1;

** now compute number of significant variables; 

foreach i of numlist 1 {; 

gen sig1_`i' = 1 if t`i' > 2.57; 
replace sig1_`i' = 0 if sig1_`i' == . ;
gen sig5_`i' = 1 if t`i' > 1.96; 
replace sig5_`i' = 0 if sig5_`i' == . ;
gen sig10_`i' = 1 if t`i' > 1.646; 
replace sig10_`i' = 0 if sig10_`i' == .;

};

drop if t1 == . ;

outsheet varnames varlabs t* sig* using ../out/a2_3_midline.csv, comma replace; 







