# Market Microstructure Research

-	[[1st Project](https://github.com/Dexter-WOO/Market-Microstructure-Research/blob/main/catch_retail_trading.sas)] Identified retail trades by finding trades that occur off-exchange and with fractional pennies 
-	[[2nd Project](https://github.com/Dexter-WOO/Market-Microstructure-Research/blob/main/svi_predict_retail_trading.sas)] Built regression models to predict retail trading activities with Google Search Volume Index (SVI)
-	[[3rd Project](https://github.com/Dexter-WOO/Market-Microstructure-Research/blob/main/the_lost_liquidity.sas)] Researched how retail traders lose information due to the lack of odd-lot trades information in Trade and Quote (TAQ) data compared to proprietary data


## Predict Retail Trading Activities with Google Search Volume Index (SVI)
We contrust some regression model to predict retail trading activities with Google Search Volume Index (SVI). The naive regression model will be
<p align="center">
<img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+Y_%7Bi%2Ct%7D%3D%5Cbeta+_%7B0%7D%2B%5Cbeta+_%7B1%7DX_%7B0%2Ci%2Ct-1%7D%2B%5Csum_%7Bk%3D1%7D%5E%7BK%7D%5Clambda+_%7Bk%7DX_%7Bk%2Ci%2Ct-1%7D%2B%5Cvarepsilon+_%7Bi%2Ct%7D" 
alt="Y_{i,t}=\beta _{0}+\beta _{1}X_{0,i,t-1}+\sum_{k=1}^{K}\lambda _{k}X_{k,i,t-1}+\varepsilon _{i,t}">
</p>


where <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+Y_%7Bi%2Ct%7D" 
alt="Y_{i,t}"> is the dependent variable for stock <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+i" 
alt="i"> on day <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+t" 
alt="t">, <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+X_%7B0%2Ci%2Ct%7D" 
alt="X_{0,i,t}"> is the independent variable for stock <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+i" 
alt="i"> on day <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+t-1" 
alt="t-1">, <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+X_%7Bk%2Ci%2Ct-1%7D" 
alt="X_{k,i,t-1}"> is the <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+k%5E%7Bth%7D" 
alt="k^{th}"> control variable for stock <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+i" 
alt="i"> on day <img src=
"https://render.githubusercontent.com/render/math?math=%5Clarge+%5Cdisplaystyle+t-1" 
alt="t-1">.

We use SVI as our independent variable and dependent variable includes: retail to total trading volume ratio, retail trading volume, and stock return.

### Data Collection
The trading data can be retrieved from CRSP, [WRDS](https://wrds-www.wharton.upenn.edu/). Then, we use the idea of Boehmer et al. (2021) to identify retail trades [here](https://github.com/Dexter-WOO/Retail-Trading-and-Google-Trends/blob/main/catch_retail_trading.sas). The data output will be used for computing all the dependent variables for the regression model. Based on the idea of Da, Engelberg, and Gao (2011), we want to use SVI to predict the retail trading activities. SVI can be downloaded from [Google Trends](https://trends.google.com/trends/?geo=US). Lastly, we use all these data to build the regression model [here](https://github.com/Dexter-WOO/Retail-Trading-and-Google-Trends/blob/main/svi_predict_retail_trading.sas).

### Data Cleansing
Some tickers with a generic meaning usually have an abnormally high SVI, such as "BB", "BABY", etc., so we have to remove these noisy tickers in our dataset. Besides, we want to include only small stocks because those are the stocks that are normally traded by retail investors, also having a decent SVI. 

### References
1. BOEHMER, E., JONES, C.M., ZHANG, X. and ZHANG, X. (2021), Tracking Retail Investor Activity. The Journal of Finance, 76: 2249-2305. https://doi.org/10.1111/jofi.13033
2. DA, Z., ENGELBERG, J. and GAO, P. (2011), In Search of Attention. The Journal of Finance, 66: 1461-1499. https://doi.org/10.1111/j.1540-6261.2011.01679.x
