// Labellling:
label variable y "KFC operates a store there?"
label variable x1 "A nearby shopping mall?"
label variable x2 "A Popeyes store nearby?"
label variable x3 "A subway station nearby?"
label variable x4 "Ln_pedestrian flow, 10k per hr"
label variable x5 "Ln_dist to center, in 10km"
label variable x6 "Res density, in 1,000 per block"


//Descriptive Statistics:

summarize y x1 x2 x3
summarize x4 x5 x6

//Histograms -- Figure 1
hist y, name(graph0, replace)
histogram x1, name(graph1, replace)
histogram x2, name(graph2, replace)
histogram x3, name(graph3, replace)
histogram x4, name(graph4, replace)
histogram x5, name(graph5, replace)
histogram x6, name(graph6, replace)

//Given the skewness of x6 distribution, I decide to use the ln of x6 for further analysis
generate lnX6 = ln(x6)
histogram lnX6, name(graph7, replace)

graph combine graph0 graph1 graph2 graph3 graph4 graph5 graph6 graph7



// Primary Model
stepwise, pe(.10): logit y x1 x2 x3 x4 x5 x6
estimates store Logit
estat ic

//Model Selection
stepwise, pe(.10): regress y x1 x2 x3 x4 x5 x6
estimates store OLS
estat ic

stepwise, pe(.10): logit y x1 x2 x3 x4 x5 lnX6
estimates store Logit_lnX6
estat ic

//Prediction: Whether KFC would have a new store or not at Eaton?
margins, at(x1=1  x2=0 x3=1 x4=1.09861 x5=0.4054651 x6=4.5)



//Marginal effects
//APE:
margins, dydx(x1 x2 x3 x4 x5 x6)

//PEA:
margins, dydx(x1 x2 x3 x4 x5 x6) atmeans


//Classification Test:
estat classification


//Endogeneity Test:

generate z =-1.565264+3.415127*x1 - 5.768404*x2+4.609453*x3 + 1.544106*x4 - 4.106603*x5 +0.5345794*x6
generate y_hat = exp(z)/(1+exp(z))
generate u = y - y_hat

correlate x* u, covariance // regressors and the error term hold statiscial independence, QED




