"""
Created on Thu Oct  3 15:57:44 2024

@author: turinici
"""


"""
This program uses historical data in the format in :
    https://turinici.com/wp-content/uploads/cours/common/close_cac40_historical.csv

It can also be downloaded form yahoo finance in daily
prices (at least the "close") if possible at lest 5 years

Idea: use yahoo e.g., yfinance package
"pip install yfinance"


Then the code does :

1'/ order by increasing date

2/ plot price histogram and returns  (with "log" and/or "actuarial")

3/ test normality of : prices, log returns, actuarial returns
    for instance can use scipy.stats.normaltest

4/ shows the random versus optimal results

TODO : replace "None" by what is required to implement the task.

"""
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.stats import kstest, normaltest  # type: ignore

#from scipy.special import softmax

# take csv from www course :we suppose it is available locally))
data = pd.read_csv('M2/Risks Management/TP1/close_cac40_historical.csv', sep=';', index_col = 'Date')
data.head()
# order by increasing date, keep variable 'data'
data = data.sort_index(ascending=True)
data.head()
data.tail()

# plot histogram of prices
_ = data.hist(bins=30, figsize = (15,15))

def normality_test(data,kolmogorov_smirnov=False,level=0.01,print_results=True):
    """
    Tests normality of each column of dataframe "data".
    Inputs:
        kolmogorov_smirnov= false: use "normaltest", otherswise use kstest, both from scipy.stats
        level = p-value threshold level for the conclusions

    Outputs:  the number of yes/no in the results
    """

    pvalues = []
    for cols in data.keys():
        pv = kstest(data[cols].dropna(), 'norm', args=(data[cols].mean(), data[cols].std())).pvalue if kolmogorov_smirnov else normaltest(data[cols].dropna()).pvalue
        pvalues.append(pv)
        res = 'normal' if pv >= level else 'not normal'
        print("Test pval=", pv, 'res=', res)
    normalok = sum([1 for pv in pvalues if pv >= level])
    normalnotok = sum([1 for pv in pvalues if pv < level])
    if (print_results):
        print("no. of normal = ", normalok)
        print("no. of not normal = ", normalnotok)
    return normalok, normalnotok

normality_test(data)

# use 'data' to compute returns
# returns = data.pct_change() #actuarial
returns = np.log(data/data.shift(1))

_ = returns.hist(bins = int(np.sqrt(returns.shape[0])), figsize = (15,15)) # type: ignore

normality_test(returns.tail(25*3)) # type: ignore # test last 3 months

###########################################################
print('normality tests for increments, not returns!!')
increments = data - data.shift(1)
_ = increments.hist(bins=int(np.sqrt(increments.shape[0])), figsize = (15,15))

normality_test(increments.tail(25*3))
########################################################################



#%%
nb = 10  #will work with nb stocks
all_returns = returns.copy() #backup
nb_all = all_returns.shape[1]
if (nb > nb_all):
    print("too many number of stocks, revert to max")
    nb = nb_all
#choose the stock names
nb_stocks_names = np.random.choice(all_returns.keys(), nb, replace=False) # type: ignore
returns_small = all_returns.loc[:, nb_stocks_names] # type: ignore

#%%
#compute avg and cov of returns
mean_returns = returns_small.mean()
cov_matrix = returns_small.cov()
rdt_list = []
std_list = []
for _ in range(500):
    #sample at random some "allocation"
    allocation = np.random.random(nb)
    rdt_port = allocation@mean_returns
    std_port = np.sqrt(allocation@cov_matrix@allocation)
    rdt_list.append(rdt_port)
    std_list.append(std_port)


inverse_cov = np.linalg.inv(cov_matrix)
# compute and draw the efficient frontier on the same graph
onesM = np.ones_like(mean_returns)
#compute 'a' and 'b' using formulas from the course
a = onesM.T @ inverse_cov @ onesM
b = onesM.T @ inverse_cov @ mean_returns

# plot the frontier and its symmetric w/r to origin
sigmarange = np.linspace(1. / np.sqrt(a) + 1.e-10, 1.1 * np.max(std_list), 47)
# compute the return of the optimal portfolio for sigma in sigmarange
# will use the "factor" auxiliary variable
factor = np.sqrt(sigmarange**2 - 1. / a)
optimal_return = b / a + np.sqrt(sigmarange**2 - 1. / a) * factor

fig = plt.figure('perf')
plt.scatter(std_list, rdt_list)
plt.plot(sigmarange, optimal_return, 'r-')
plt.xlabel('std')
plt.ylabel('rdt')
#plt.xlim([0,.2])
#plt.ylim([-.05,.05])
plt.show()


# %%
