// this dofile processes the raw data to produce:  bas-mid-end-append_v2.dta


clear
clear mata
clear matrix
set maxvar 20000
set matsize 7000
set more off 

# delimit;



cd "~/Desktop/ej_final/replication_package/do/";



** 1. ADD IN VARIABLES FOR TABLES; 


use ../raw/bas-mid-end-append.dta, clear; 


egen total_input_cost =rowtotal(totcost_seed_rs totcost_fert_rs totcost_pest_rs totcost_irrig_rs totcost_lab);

gen log_totcost_input_rs=log(total_input_cost+1);

gen log_totcost_irrig_rs=log(totcost_irrig_rs+1);

* recalculate profits; 

gen profit = ag_income - total_input_cost; 


winsor ag_income, p(0.01) gen(ag_income_w1); 


gen profit_log= log(profit+1);


winsor profit, p(0.01) gen(profit_w1); 


winsor total_input_cost, p(0.01) gen(total_input_cost_w1); 


drop totcost_irrig_rs_w1;

winsor totcost_irrig_rs, p(0.01) gen(totcost_irrig_rs_w1); 


la var profit_log "Total profit";

winsor cotton_yield, p(0.025) gen(cotton_yield_w2); 
winsor cumin_yield, p(0.025) gen(cumin_yield_w2); 
winsor wheat_yield, p(0.025) gen(wheat_yield_w2); 



* convert to using inverse hyperbolic sine; 

gen irrig_sinh = asinh(totcost_irrig_rs); 
gen inputcost_sinh = asinh(total_input_cost); 
gen profit_sinh = asinh(profit); 
gen ag_income_sinh = asinh(ag_income); 



* compute total usage; 

gen total_usage = push_duration+duration; 



*3. CREATE AGGREGATE INDICES;



* the sample variable here restricts to respondents who are non-missing; 

gen sample = (post_M == 0 | Midline == 1 | Endline == 1); 


gen controlz = (treatment == 3 & post_M == 0); 



*info index; 

egen info_index_a = weightave2(k1_5a_cropdecision_3  k1_5a_soilprep_3 k1_5a_pestid_3 k1_5a_weather_3 f1_source_3
p1_source_3 f2_source_3 f3_source_3 p3_source_3), normby(controlz); 


*cotton practices; 


egen cotton_index_bin_a = weightave2(
s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 s1_seeduse_5 s1_seeduse_6  s1_seeduse_9
p1_7c6 p1_7c6_use p1_8c1 p1_8c1_use p1_71_8 p1_71_8_use p1_71_9 p1_71_9_use     
p1_71_10 p1_71_10_use p1_8c6 p1_10tf f1_8b f1_8b_use f1_8d f1_8d_use     
f1_8e f1_8e_use  f1_12a  f1_12a_use f1_12b  f1_12b_use f1_12d  f1_12d_use 
) if sample == 1, normby(controlz);




* wheat practices; 


egen wheat_index_bin_a = weightave2(
c2_7a s2_seed_1 s2_seeduse_1 s2_seed_5 s2_seeduse_5 s2_10c s2_10b f2_8d f2_8d_use
f2_8e f2_8e_use f2_12a f2_12a_use  f2_12b f2_12b_use )  if sample == 1, normby(controlz);


* cumin practices; 


egen cumin_index_bin_a = weightave2(s3_seed_4 s3_seeduse_4 s3_10a s3_10b
p3_71_6 p3_71_6_use p3_71_8 p3_71_8_use p3_71_9 p3_71_9_use p3_71_16 p3_71_16_use
p3_8c1 p3_8c1_use p3_71_20 p3_71_20_use p3_9tf f3_8b f3_8b_use f3_8d f3_8d_use
f3_8e f3_12a f3_12a_use f3_12b f3_12b_use  f3_12d f3_12d_use )  if sample == 1,  normby(controlz);


* pest management; 

egen pest_index_bin_a = weightave2(p1_7c6 p1_7c6_use p1_8c1  p1_8c1_use p1_71_8  p1_71_8_use
p1_71_9 p1_71_9_use p1_71_10 p1_71_10_use p1_8c6 p1_8c6_use p1_10tf p3_71_6 p3_71_6_use
p3_71_8 p3_71_8_use p3_71_9 p3_71_9_use p3_71_16 p3_71_16_use p3_8c1 p3_8c1_use p3_71_20 p3_71_20_use
p3_9tf
)  if sample == 1,  normby(controlz);



* fertilizers index; 

egen fert_index_bin_a = weightave2(f1_8b f1_8b_use     
f1_8d f1_8d_use  f1_8e f1_8e_use  f1_12a  f1_12a_use  f1_12b  f1_12b_use 
f1_12d  f1_12d_use  f2_8d    f2_8d_use f2_8e   f2_8e_use f2_12a f2_12a_use   
f2_12b f2_12b_use  f3_8b   f3_8b_use f3_8d    f3_8d_use f3_8e f3_8e_use   
f3_12a  f3_12a_use f3_12b  f3_12b_use f3_12d  f3_12d_use)  if sample == 1 , normby(controlz);


* seed index; 

egen seed_index_bin_a = weightave2(
s1_seed_1 s1_seed_2 s1_seed_3 s1_seed_4 s1_seed_5 s1_seed_6 s1_seed_7 s1_seed_9
s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 s1_seeduse_5 s1_seeduse_6 s1_seeduse_9

s2_seed_1 s2_seed_2 s2_seed_3 s2_seed_4 s2_seed_5 
s2_seeduse_1 s2_seeduse_2 s2_seeduse_3 s2_seeduse_4 s2_seeduse_5 

s3_seed_4 s3_seeduse_4   )  if sample == 1 , normby(controlz); 



* all input index; 



egen input_index_bin_a = weightave2(s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 
s1_seeduse_5 s1_seeduse_6  s1_seeduse_9 p1_7c6 p1_7c6_use
p1_8c1 p1_8c1_use p1_71_8 p1_71_8_use p1_71_9 p1_71_9_use p1_71_10 p1_71_10_use
p1_8c6 p1_8c6_use p1_10tf f1_8b f1_8b_use  f1_8d f1_8d_use f1_8e f1_8e_use    
f1_12a  f1_12a_use f1_12b  f1_12b_use f1_12d  f1_12d_use c2_7a s2_seed_1 s2_seeduse_1 
s2_seed_5 s2_seeduse_5 s2_10c s2_10b f2_8d  f2_8d_use f2_8e f2_8e_use f2_12a f2_12a_use  f2_12b f2_12b_use 
s3_seed_4 s3_seeduse_4 s3_10a s3_10b p3_71_6  p3_71_6_use p3_71_8 p3_71_8_use 
p3_71_9  p3_71_9_use p3_71_16  p3_71_16_use p3_8c1  p3_8c1_use p3_71_20   p3_71_20_use
p3_9tf f3_8b f3_8b_use f3_8d f3_8d_use f3_8e f3_8e_use f3_12a f3_12a_use f3_12b f3_12b_use  f3_12d f3_12d_use  
)  if sample == 1, normby(controlz);



*5. CREATE UNWEIGHTED INDICES; 


gen round = 1 if post_M == 0; 
replace round = 2 if post_M == 1; 
replace round = 3 if post_E == 1; 

la var round "survey round, 1 is baseline, 2 is midline, 3 is endline";

*info index; 
foreach x of varlist k1_5a_cropdecision_3  k1_5a_soilprep_3 k1_5a_pestid_3 k1_5a_weather_3 f1_source_3
p1_source_3 f2_source_3 f3_source_3 p3_source_3

{;
** create variable that will compute zscore for each component of index; 
gen `x'_zscore = . ;
** compute control mean/sd in pre-period; 
sum `x' if ao == 0 & round == 1; 
** gen new var, that computes zscore for each component of index in pre-period; 
replace `x'_zscore = ((`x'-`r(mean)')/`r(sd)');
};

egen info_index_bin_uw = rowmean(*zscore);
drop *zscore;


*cotton index; 
foreach x of varlist 

s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 s1_seeduse_5 s1_seeduse_6  s1_seeduse_9
p1_7c6 p1_7c6_use p1_8c1 p1_8c1_use p1_71_8 p1_71_8_use p1_71_9        
p1_71_10 p1_8c6 p1_10tf f1_8b f1_8b_use f1_8d f1_8d_use     
f1_8e f1_8e_use  f1_12a  f1_12a_use f1_12b  f1_12b_use f1_12d  f1_12d_use 

{;
** create variable that will compute zscore for each component of index; 
gen `x'_zscore = . ;
** compute control mean/sd in pre-period; 
sum `x' if ao == 0 & round == 1; 
** gen new var, that computes zscore for each component of index in pre-period; 
replace `x'_zscore = ((`x'-`r(mean)')/`r(sd)');
};

egen cotton_index_bin_uw = rowmean(*zscore);
drop *zscore;


*wheat index; 
foreach x of varlist 

c2_7a s2_seed_1 s2_seeduse_1 s2_seed_5 s2_seeduse_5 s2_10c s2_10b f2_8d f2_8d_use
f2_8e f2_8e_use f2_12a f2_12a_use  f2_12b f2_12b_use

{;

** create variable that will compute zscore for each component of index; 
gen `x'_zscore = . ;
** compute control mean/sd in pre-period; 
sum `x' if ao == 0 & round == 1; 
** gen new var, that computes zscore for each component of index in pre-period; 
replace `x'_zscore = ((`x'-`r(mean)')/`r(sd)');
};

egen wheat_index_bin_uw = rowmean(*zscore);
drop *zscore;




*cumin index; 
foreach x of varlist 

s3_seed_4 s3_seeduse_4 s3_10a s3_10b
p3_71_6 p3_71_6_use p3_71_8 p3_71_8_use p3_71_9 p3_71_9_use p3_71_16 p3_71_16_use
p3_8c1 p3_8c1_use p3_71_20 p3_71_20_use p3_9tf f3_8b f3_8b_use f3_8d f3_8d_use
f3_8e f3_12a f3_12a_use f3_12b f3_12b_use  f3_12d f3_12d_use

{;

** create variable that will compute zscore for each component of index; 
gen `x'_zscore = . ;
** compute control mean/sd in pre-period; 
sum `x' if ao == 0 & round == 1; 
** gen new var, that computes zscore for each component of index in pre-period; 
replace `x'_zscore = ((`x'-`r(mean)')/`r(sd)');
};

egen cumin_index_bin_uw = rowmean(*zscore);
drop *zscore;



*seed index; 
foreach x of varlist 


s1_seed_1 s1_seed_2 s1_seed_3 s1_seed_4 s1_seed_5 s1_seed_6 s1_seed_7 s1_seed_9
s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 s1_seeduse_5 s1_seeduse_6 s1_seeduse_9

s2_seed_1 s2_seed_2 s2_seed_3 s2_seed_4 s2_seed_5 
s2_seeduse_1 s2_seeduse_2 s2_seeduse_3 s2_seeduse_4 s2_seeduse_5 

s3_seed_4 s3_seeduse_4 

{;

** create variable that will compute zscore for each component of index; 
gen `x'_zscore = . ;
** compute control mean/sd in pre-period; 
sum `x' if ao == 0 & round == 1; 
** gen new var, that computes zscore for each component of index in pre-period; 
replace `x'_zscore = ((`x'-`r(mean)')/`r(sd)');
};

egen seed_index_bin_uw = rowmean(*zscore);
drop *zscore;



*fert index; 
foreach x of varlist 


f1_8b f1_8b_use     
f1_8d f1_8d_use  f1_8e f1_8e_use  f1_12a  f1_12a_use  f1_12b  f1_12b_use 
f1_12d  f1_12d_use  f2_8d    f2_8d_use f2_8e   f2_8e_use f2_12a f2_12a_use   
f2_12b f2_12b_use  f3_8b   f3_8b_use f3_8d    f3_8d_use f3_8e f3_8e_use   
f3_12a  f3_12a_use f3_12b  f3_12b_use f3_12d  f3_12d_use

{;

** create variable that will compute zscore for each component of index; 
gen `x'_zscore = . ;
** compute control mean/sd in pre-period; 
sum `x' if ao == 0 & round == 1; 
** gen new var, that computes zscore for each component of index in pre-period; 
replace `x'_zscore = ((`x'-`r(mean)')/`r(sd)');
};

egen fert_index_bin_uw = rowmean(*zscore);
drop *zscore;

*pesticide index; 
foreach x of varlist 


p1_7c6 p1_7c6_use p1_8c1  p1_8c1_use p1_71_8  p1_71_8_use
p1_71_9 p1_71_9_use p1_71_10 p1_71_10_use p1_8c6 p1_8c6_use p1_10tf p3_71_6 p3_71_6_use
p3_71_8 p3_71_8_use p3_71_9 p3_71_9_use p3_71_16 p3_71_16_use p3_8c1 p3_8c1_use p3_71_20 p3_71_20_use
p3_9tf

{;

** create variable that will compute zscore for each component of index; 
gen `x'_zscore = . ;
** compute control mean/sd in pre-period; 
sum `x' if ao == 0 & round == 1; 
** gen new var, that computes zscore for each component of index in pre-period; 
replace `x'_zscore = ((`x'-`r(mean)')/`r(sd)');
};

egen pest_index_bin_uw = rowmean(*zscore);
drop *zscore;



*input  index; 
foreach x of varlist 

s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 
s1_seeduse_5 s1_seeduse_6  s1_seeduse_9 p1_7c6 p1_7c6_use
p1_8c1 p1_8c1_use p1_71_8 p1_71_8_use p1_71_9 p1_71_9_use p1_71_10 p1_71_10_use
p1_8c6 p1_8c6_use p1_10tf f1_8b f1_8b_use  f1_8d f1_8d_use f1_8e f1_8e_use    
f1_12a  f1_12a_use f1_12b  f1_12b_use f1_12d  f1_12d_use c2_7a s2_seed_1 s2_seeduse_1 
s2_seed_5 s2_seeduse_5 s2_10c s2_10b f2_8d  f2_8d_use f2_8e f2_8e_use f2_12a f2_12a_use  f2_12b f2_12b_use 
s3_seed_4 s3_seeduse_4 s3_10a s3_10b p3_71_6  p3_71_6_use p3_71_8 p3_71_8_use 
p3_71_9  p3_71_9_use p3_71_16  p3_71_16_use p3_8c1  p3_8c1_use p3_71_20   p3_71_20_use
p3_9tf f3_8b f3_8b_use f3_8d f3_8d_use f3_8e f3_8e_use f3_12a f3_12a_use f3_12b f3_12b_use  f3_12d f3_12d_use

{;

** create variable that will compute zscore for each component of index; 
gen `x'_zscore = . ;
** compute control mean/sd in pre-period; 
sum `x' if ao == 0 & round == 1; 
** gen new var, that computes zscore for each component of index in pre-period; 
replace `x'_zscore = ((`x'-`r(mean)')/`r(sd)');
};

egen input_index_bin_uw = rowmean(*zscore);
drop *zscore;



* label vars; 

la var cotton_index_bin_uw  "Cotton Management - binary -  unweighted";
la var cumin_index_bin_uw "Cumin Management - binary - unweighted";
la var wheat_index_bin_uw "Wheat Management - binary -  unweighted";
la var seed_index_bin_uw "Seed Management - binary -  unweighted";
la var fert_index_bin_uw "Fertilizer Management - binary - unweighted";
la var pest_index_bin_uw "Pesticide Management - binary - unweighted";
la var info_index_bin_uw "Information Sources - binary - unweighted";
la var input_index_bin_uw "All Recommended Inputs - binary - unweighted";


la var cotton_index_bin_a  "Cotton Management - binary -  weighted";
la var cumin_index_bin_a "Cumin Management - binary - weighted";
la var wheat_index_bin_a "Wheat Management - binary -  weighted";
la var seed_index_bin_a "Seed Management - binary -  weighted";
la var fert_index_bin_a "Fertilizer Management - binary - weighted";
la var pest_index_bin_a "Pesticide Management - binary - weighted";
la var info_index_a "Information Sources - binary - weighted";
la var input_index_bin_a "All Recommended Inputs - binary - weighted";


* other indices needed for multiple hypothesis table; 


egen yield_index_a = weightave2(cotton_yield wheat_yield cumin_yield
)  if sample == 1, normby(controlz);


egen overall_index_a = weightave2(cotton_yield wheat_yield cumin_yield

s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 
s1_seeduse_5 s1_seeduse_6  s1_seeduse_9 p1_7c6 p1_7c6_use
p1_8c1 p1_8c1_use p1_71_8 p1_71_8_use p1_71_9 p1_71_9_use p1_71_10 p1_71_10_use
p1_8c6 p1_8c6_use p1_10tf f1_8b f1_8b_use  f1_8d f1_8d_use f1_8e f1_8e_use    
f1_12a  f1_12a_use f1_12b  f1_12b_use f1_12d  f1_12d_use c2_7a s2_seed_1 s2_seeduse_1 
s2_seed_5 s2_seeduse_5 s2_10c s2_10b f2_8d  f2_8d_use f2_8e f2_8e_use f2_12a f2_12a_use  f2_12b f2_12b_use 
s3_seed_4 s3_seeduse_4 s3_10a s3_10b p3_71_6  p3_71_6_use p3_71_8 p3_71_8_use 
p3_71_9  p3_71_9_use p3_71_16  p3_71_16_use p3_8c1  p3_8c1_use p3_71_20   p3_71_20_use
p3_9tf f3_8b f3_8b_use f3_8d f3_8d_use f3_8e f3_8e_use f3_12a f3_12a_use f3_12b f3_12b_use  f3_12d f3_12d_use

k1_5a_cropdecision_3  k1_5a_soilprep_3 k1_5a_pestid_3 k1_5a_weather_3 f1_source_3
p1_source_3 f2_source_3 f3_source_3 p3_source_3

overall

 total_usage used_ao n_call duration    asked_q   pct_listened   
 
 totcost_irrig_rs_w1
)  if sample == 1, normby(controlz);


la var yield_index_a "Yield index"; 

la var overall_index_a "Overall program effect index"; 



*5. CREATE BASELINE VAR FOR ANCOVA CONTROL; 

foreach x of varlist  
total_usage used_ao n_call duration avg_call zero_access called_ao total_duration 

 avg_listen_time record asked_q question res_q res_a shared_exp pct_listened pct_10 pct_50
 
  k1_3_3 k1_3_3_trust k1_5a_cropdecision_3 k1_5a_pestid_3 k1_5a_fert_3 
 
 k1_5a_weather_3 k1_5a_soilprep_3 k1_5a_prices_3 log_totcost_input_rs log_totcost_irrig_rs 
 

 c1_3 c2_3 c3_3 cotton_yield wheat_yield cumin_yield scotton_w1 swheat_w1 scumin_w1 
cotton_yield_w2 wheat_yield_w2 cumin_yield_w2  
 totcost_input_rs overall C_correct W_correct J_correct pest fert
 

 cotton_index_bin_a wheat_index_bin_a cumin_index_bin_a input_index_bin_a
seed_index_bin_a   pest_index_bin_a  fert_index_bin_a 


irrig_sinh inputcost_sinh profit_sinh info_index_a bdmbidprice bought_ao

input_index_bin_uw cotton_index_bin_uw cumin_index_bin_uw wheat_index_bin_uw seed_index_bin_uw fert_index_bin_uw
pest_index_bin_uw info_index_bin_uw

 
totcost_irrig_rs totcost_irrig_rs_w1 totcost_input_rs_w1   profit_log


profit profit_w1 total_input_cost total_input_cost_w1 rcotton_w1 rwheat_w1 rcumin_w1


s1_seeduse_1 s1_seeduse_2 s1_seeduse_3 s1_seeduse_4 s1_seeduse_5 s1_seeduse_6  s1_seeduse_9
p1_7c6 p1_7c6_use p1_8c1 p1_8c1_use p1_71_8 p1_71_8_use p1_71_9  p1_71_9_use    
p1_71_10 p1_71_10_use p1_8c6 p1_10tf f1_8b f1_8b_use f1_8d f1_8d_use     
f1_8e f1_8e_use  f1_12a  f1_12a_use f1_12b  f1_12b_use f1_12d  f1_12d_use 


ag_income
ag_income_w1
ag_income_sinh 

totcost_seed_rs totcost_fert_rs totcost_pest_rs  totcost_lab

ycotton_w1 ycumin_w1 ywheat_w1

c2_5a c3_5a c1_5a

yield_index_a overall_index_a

a0_2_age edu_years 



 
  { ; 
 
sort uid post_M; 
 
bysort uid: gen `x'_b0 = `x'[1];

};




** 6. MERGE IN LASSO DATA; 


merge  m:1 uid using ../dta/baseline_lassocleaned.dta, gen(_m_lasso); 



qui tab village_no, gen(_vill);



qui tab round, gen(_round);

gen end = (round == 3); 

drop ao; 


* misc; 


gen ever_aoe = (treatment == 1); 
gen ever_ao = (treatment == 2 ); 


gen round_2 = (round == 2); 
gen round_3 = (round == 3); 

gen post_round = (round  == 2 | round == 3); 

gen ao_postr = ever_ao*post_round; 
gen aoe_postr = ever_aoe*post_round; 

gen ao_round_2 = ever_ao*round_2; 
gen ao_round_3 = ever_ao*round_3;

gen ever_aos = (treatment == 2  | treatment == 1); 

gen aos_postr = ever_aos*post_round; 


gen ao = ever_aos; 

gen ever_reminder = (reminder_call == 1); 


* rename vars that should not be dropped; 

rename post_M post_Mz; 
rename post_E post_Ez; 
rename treatpost_M treatpost_Mz;
rename treatpost_E treatpost_Ez;



* drop redundant variables; 

drop *_B *_E *_M *_other *_name *_comments *_unit *_name1 *_name2 *_unitprice *merge ; 


rename post_Mz post_M; 
rename post_Ez post_E;
rename treatpost_Mz treatpost_M;
rename treatpost_Ez treatpost_E;




** create baseline cotton control ; 

gen bascot = c1_5a; 
replace bascot = . if post_M == 1|post_E==1; 

bysort uid : egen bas_cot = max(bascot); 
drop bascot;

gen bas_cot_post_M = bas_cot*post_M;

gen bas_cot_post_E = bas_cot*post_E;


* spillover controls; 

gen treat_treated_peer = has_treated_peer*ever_aos; 

gen treat_treatfrac = ever_aos*treatfrac; 


* variable labels; 


la var treat_treated_peer "any ao treatment interacted with any peer treated"; 
la var treat_treatfrac "any ao treatment interacted with fraction of pees treated"; 

la var round_2 "midline round"; 
la var round_3 "endline round";

la var post_round "midline or endline"; 

la var  ao_postr "ao group interacted with post"; 
la var  aoe_postr "aoe group interacted with post"; 
la var  aos_postr "treat interacted with post"; 


la var ao_round_2 "ao interacted with midline"; 
la var ao_round_3 "ao interacted with endline"; 

la var ever_aoe "assigned to aoe group"; 
la var ever_ao "assigned to ao group"; 

la var ever_aos "assigned to a treatment group (either ao or aoe)"; 

la var ao  "assigned to a treatment group (either ao or aoe)"; 
la var ever_reminder "assigned to the reminder group"; 



* correction for bdm data --  only endline; 

replace bdmbidprice = .  if round != 3; 

* correction, missing values for info sources; 


foreach x of varlist  k1_5a_cropdecision_3 k1_5a_pestid_3 k1_5a_fert_3 k1_5a_weather_3 k1_5a_soilprep_3 k1_5a_prices_3
overall C_correct {; 

replace `x' = 0 if `x' == . & sample == 1; 
replace `x'_b0 = 0 if `x'_b0 == . & sample == 1;

};


save ../dta/bas-mid-end-append_v2.dta, replace; 










