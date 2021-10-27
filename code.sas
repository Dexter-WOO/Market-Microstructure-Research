libname project2 "C:\Users\1155149528\Desktop";
proc import file = "C:\Users\1155149528\Desktop\retail_frac.csv"
	out = project2.retail_frac
	dbms = csv;
run;
proc import file="C:\Users\1155149528\Desktop\svi_data.csv"
	out = project2.svi_data
	dbms = csv;
run;
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
data merged3; set work.merged2;
logMC = LOG(prc*shrout);
high_low = askhi - bidlo;
close_reciprocal = 1/prc;
run; 
proc reg data = merged3;
model retail_frac = svi;
ods output parameterstimates = model1;
run; 
proc sort data = merged3 (where = (ticker ne '')); by ticker date; run; 
proc expand data = merged3 out = merged4 method = none; 
by ticker; 
convert svi = lag_svi / transformout = (lag 1); 
run; 
