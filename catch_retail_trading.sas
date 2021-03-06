libname Project1 'C:\Users\1155149528\Desktop'; 
/*Add share code and the price of last month to the TAQ data*/
proc sql; create table taq1
as select a.*, b.shrcd, b.prc as prc_last_month
from project1.taq as a, project1.crspm (where = (shrcd in (10, 11) and prc >= 1)) as b
where a.sym_root = b.ticker; 
quit; 
/*Classify records to "retail sell" and "retail buy" among all transactions occurs off exchange. */
proc sql; create table retail
as select *
from taq1
/*retail sell: price*100-round(price*100,1)>0  and price*100-round(price*100,1)<0.4*/
/*retail buy: price*100-round(price*100,1)>0.6 and price*100-round(price*100,1)<1*/
where  ((price*100-round(price*100,1)>0  and price*100-round(price*100,1)<0.4) or (price*100-round(price*100,1)>0.6 and price*100-round(price*100,1)<1)) and ex='D';
quit;
/*On each day, aggregate the volume from retail investors.*/
proc sql; create table daily_retail
as select distinct sym_root, date, sum(size) as retail_volume
from retail
group by sym_root, date
order by sym_root, date; 
quit; 
/*On each day, aggregate volume from all investors.*/
proc sql; create table daily_total
as select distinct sym_root, date, sum(size) as total_volume
from taq1
group by sym_root, date
order by sym_root, date; 
quit; 
/*Merge the retail volume table and total volume table.*/
proc sql; create table retail_total
as select a.*, b.retail_volume
from daily_total as a left join daily_retail as b
on a.sym_root = b.sym_root and a.date = b.date
order by sym_root, date; 
quit; 
/*Replace missing retail trading volume by 0 and calculate the retail trading activity on each day.*/
data retail_total1; set retail_total; 
if retail_volume = . then retail_volume = 0; 
retail_ratio = retail_volume/total_volume; 
run; 
/*Calculate the average retail trading activity for each stock.*/
proc sql; create table average_ratio
as select distinct sym_root, mean(retail_ratio) as average_ratio
from retail_total1
group by sym_root
order by sym_root; 
quit; 
