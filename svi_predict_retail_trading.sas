/*Step 1*/
libname project2 "C:\Users\1155149528\Desktop";
proc import file = "C:\Users\1155149528\Desktop\retail_frac.csv"
	out = project2.retail_frac
	dbms = csv;
run;
proc import file="C:\Users\1155149528\Desktop\svi_data.csv"
	out = project2.svi_data
	dbms = csv;
run;
/*------------------------------------------*/
/*Step 2*/
data retail_frac; set project2.retail_frac;
format date date9.;
run;
data svi_data; set project2.svi_data;
format date date9.;
run;
proc sql; create table merged
as select a.*, b.retail_vlm, b.retail_frac
from svi_data as a, retail_frac as b
where a.ticker = b.ticker and a.date = b.date
order by ticker, date; 
quit; 
proc sql; create table merged2
as select a.*, b.prc, b.askhi, b.bidlo, b.ret, b.shrout
from merged as a, project2.daily_return as b
where a.ticker = b.ticker and a.date = b.date
order by ticker, date; 
quit; 
/*------------------------------------------*/
/*Step 3*/
data merged3; set work.merged2;
logMC = LOG(prc*shrout);
high_low = askhi - bidlo;
close_reciprocal = 1/prc;
run; 
/*------------------------------------------*/
/*Step 4*/
/*Model 1*/
/* proc reg data = merged3 plots(maxpoints = none); */
/* model retail_frac = svi; */
/* ods output parameterestimates = model1; */
/* run;  */
/* quit; */
proc surveyreg data = merged3;
	cluster ticker;
	model retail_frac = svi;
run;
/*------------------------------------------*/
/*Model 2*/
/* proc reg data = merged3 plots(maxpoints = none); */
/* model retail_vlm = svi; */
/* ods output parameterestimates = model2; */
/* run;  */
/* quit; */
proc surveyreg data = merged3;
	cluster ticker;
	model retail_vlm = svi;
run;
/*------------------------------------------*/
/*Model 3*/
/* proc reg data = merged3 plots(maxpoints = none); */
/* model ret = svi; */
/* ods output parameterestimates = model3; */
/* run;  */
/* quit; */
proc surveyreg data = merged3;
	cluster ticker;
	model ret = svi;
run;
/*------------------------------------------*/
/*Step 5*/
/*Model 4*/
/* proc reg data = merged3 plots(maxpoints = none); */
/* model retail_frac = svi logMC high_low close_reciprocal; */
/* ods output parameterestimates = model4; */
/* run;  */
/* quit; */
proc surveyreg data = merged3;
	cluster ticker;
	model retail_frac = svi logMC high_low close_reciprocal;
run;
/*------------------------------------------*/
/*Model 5*/
/* proc reg data = merged3 plots(maxpoints = none); */
/* model retail_vlm = svi logMC high_low close_reciprocal; */
/* ods output parameterestimates = model5; */
/* run;  */
/* quit; */
proc surveyreg data = merged3;
	cluster ticker;
	model retail_vlm = svi logMC high_low close_reciprocal;
run;
/*------------------------------------------*/
/*Model 6*/
/* proc reg data = merged3 plots(maxpoints = none); */
/* model ret = svi logMC high_low close_reciprocal; */
/* ods output parameterestimates = model6; */
/* run;  */
/* quit; */
proc surveyreg data = merged3;
	cluster ticker;
	model ret = svi logMC high_low close_reciprocal;
run;
/*------------------------------------------*/
/*Step 6*/
proc sort data = merged3 (where = (ticker ne '')); by ticker date; run; 
proc expand data = merged3 out = merged4 method = none; 
by ticker; 
convert svi = lag_svi / transformout = (lag 1); 
convert logMC = lag_logMC / transformout = (lag 1);
convert high_low = lag_high_low / transformout = (lag 1);
convert close_reciprocal = lag_close_reciprocal / transformout = (lag 1);
run; 
/*------------------------------------------*/
/*Model 7*/
/* proc reg data = merged4 plots(maxpoints = none); */
/* model retail_frac = lag_svi logMC high_low close_reciprocal; */
/* ods output parameterestimates = model7; */
/* run;  */
/* quit; */
proc surveyreg data = merged4;
	cluster ticker;
	model retail_frac = lag_svi lag_logMC lag_high_low lag_close_reciprocal;
run;
/*------------------------------------------*/
/*Model 8*/
/* proc reg data = merged4 plots(maxpoints = none); */
/* model retail_vlm = lag_svi logMC high_low close_reciprocal; */
/* ods output parameterestimates = model8; */
/* run;  */
/* quit; */
proc surveyreg data = merged4;
	cluster ticker;
	model retail_vlm = lag_svi lag_logMC lag_high_low lag_close_reciprocal;
run;
/*------------------------------------------*/
/*Model 9*/
/* proc reg data = merged4 plots(maxpoints = none); */
/* model ret = lag_svi logMC high_low close_reciprocal; */
/* ods output parameterestimates = model9; */
/* run;  */
/* quit; */
proc surveyreg data = merged4;
	cluster ticker;
	model ret = lag_svi lag_logMC lag_high_low lag_close_reciprocal;
run;
/*------------------------------------------*/
/*Step 7*/
data merged5; set work.merged4;
logSVI_1 = LOG(lag_svi + 1); 
run; 
/*------------------------------------------*/
/*Model 10*/
/* proc reg data = merged5 plots(maxpoints = none); */
/* model retail_frac = logSVI_1 logMC high_low close_reciprocal; */
/* ods output parameterestimates = model9; */
/* run;  */
/* quit; */
/*proc surveyreg data = merged5;*/
/*	cluster ticker;*/
/*	model retail_frac = logSVI_1 lag_logMC lag_high_low lag_close_reciprocal;*/
/*run;*/
/* proc reg data = merged5 plots(maxpoints = none); */
/* model retail_vlm = logSVI_1 logMC high_low close_reciprocal; */
/* ods output parameterestimates = model9; */
/* run;  */
/* quit; */
proc surveyreg data = merged5;
	cluster ticker;
	model retail_vlm = logSVI_1 lag_logMC lag_high_low lag_close_reciprocal;
run;
/* proc reg data = merged5 plots(maxpoints = none); */
/* model ret = logSVI_1 logMC high_low close_reciprocal; */
/* ods output parameterestimates = model9; */
/* run;  */
/* quit; */
/*proc surveyreg data = merged5;*/
/*	cluster ticker;*/
/*	model ret = logSVI_1 lag_logMC lag_high_low lag_close_reciprocal;*/
/*run;*/
