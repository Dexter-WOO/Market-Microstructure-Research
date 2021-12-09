libname FINA4030 "C:\Users\1155149528\Desktop";
/*1. AMZN*/
data lob_amzn; set fina4030.lob_amzn_123119;
odd_lot_spread = OBOP - OBBP;
round_lot_spread = RBOP - RBBP;
odd_lot_spread_better = odd_lot_spread < round_lot_spread;
time2 = lag(time_m);
odd_lot_spread_better2 = lag(odd_lot_spread_better);
if ((odd_lot_spread_better = 1 and odd_lot_spread_better2 = 1) or (odd_lot_spread_better = 0 and odd_lot_spread_better2 = 1)) then duration = time_m - time2;
else duration = 0;
run;
proc means data = lob_amzn mean std;
var odd_lot_spread round_lot_spread;
run;
proc means data = lob_amzn sum;
var duration;
run;
/*2. MSFT*/
data lob_msft; set fina4030.lob_msft_123119;
odd_lot_spread = OBOP - OBBP;
round_lot_spread = RBOP - RBBP;
odd_lot_spread_better = odd_lot_spread < round_lot_spread;
time2 = lag(time_m);
odd_lot_spread_better2 = lag(odd_lot_spread_better);
if ((odd_lot_spread_better = 1 and odd_lot_spread_better2 = 1) or (odd_lot_spread_better = 0 and odd_lot_spread_better2 = 1)) then duration = time_m - time2;
else duration = 0;
run;
proc means data = lob_msft mean std;
var odd_lot_spread round_lot_spread;
run;
proc means data = lob_msft sum;
var duration;
run;
/*4. AMZN*/
data amzn_nbbo; set fina4030.amzn_nbbo;
nbbo_spread = best_ask - best_bid;
run;
proc means data = amzn_nbbo mean std;
var nbbo_spread;
run;
proc sql; create table amzn_merged
as select a.time_m, a.nbbo_spread, b.time_m, b.odd_lot_spread
from amzn_nbbo as a full outer join lob_amzn as b
on a.time_m = b.time_m;
quit;
data amzn_merged2; set work.amzn_merged;
retain _odd_lot_spread;
if not missing(odd_lot_spread) then _odd_lot_spread = odd_lot_spread;
else odd_lot_spread = _odd_lot_spread;
drop _odd_lot_spread;
if time_m = . then delete;
odd_lot_spread_better = odd_lot_spread < nbbo_spread;
time2 = lag(time_m);
odd_lot_spread_better2 = lag(odd_lot_spread_better);
if ((odd_lot_spread_better = 1 and odd_lot_spread_better2 = 1) or (odd_lot_spread_better = 0 and odd_lot_spread_better2 = 1)) then duration = time_m - time2;
else duration = 0;
run;
proc means data = amzn_merged2 sum;
var duration;
run;
/*4. MSFT*/
data msft_nbbo; set fina4030.msft_nbbo;
nbbo_spread = best_ask - best_bid;
run;
proc means data = msft_nbbo mean std;
var nbbo_spread;
run;
proc sql; create table msft_merged
as select a.time_m, a.nbbo_spread, b.time_m, b.odd_lot_spread
from msft_nbbo as a full outer join lob_msft as b
on a.time_m = b.time_m;
quit;
data msft_merged2; set work.msft_merged;
retain _odd_lot_spread;
if not missing(odd_lot_spread) then _odd_lot_spread = odd_lot_spread;
else odd_lot_spread = _odd_lot_spread;
drop _odd_lot_spread;
if time_m = . then delete;
odd_lot_spread_better = odd_lot_spread < nbbo_spread;
time2 = lag(time_m);
odd_lot_spread_better2 = lag(odd_lot_spread_better);
if ((odd_lot_spread_better = 1 and odd_lot_spread_better2 = 1) or (odd_lot_spread_better = 0 and odd_lot_spread_better2 = 1)) then duration = time_m - time2;
else duration = 0;
run;
proc means data = msft_merged2 sum;
var duration;
run;
/*5. AMZN*/
proc sql; create table amzn_all_merged
as select a.time_m, a.size, b.time_m, b.nbbo_spread, b.odd_lot_spread
from fina4030.amzn_trade as a full outer join amzn_merged2 as b
on a.time_m = b.time_m;
quit;
data amzn_all_merged2; set work.amzn_all_merged;
retain _odd_lot_spread;
if not missing(odd_lot_spread) then _odd_lot_spread = odd_lot_spread;
else odd_lot_spread = _odd_lot_spread;
drop _odd_lot_spread;
retain _nbbo_spread;
if not missing(nbbo_spread) then _nbbo_spread = nbbo_spread;
else nbbo_spread = _nbbo_spread;
drop _nbbo_spread;
if size = . then delete;
if nbbo_spread < odd_lot_spread then delete;
trade_loss = (nbbo_spread-odd_lot_spread)*size;
run;
proc means data = amzn_all_merged2 sum;
var trade_loss;
run;
