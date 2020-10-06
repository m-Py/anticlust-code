
# README

- Author: Martin Papenberg
- Year: 2019-2020

---

This directory contains code and data to reproduce and analyze the simulation 
study reported in: 

Papenberg, M., & Klau, G. W. (2020). Using anticlustering to partition data sets 
into equivalent parts. *Psychological Methods*. Advance Online Publication. 
https://doi.org/10.1037/met0000301

## General information

- The directory ./datasets contains the 10,000 data sets used
    + subdirectory K2: data sets where anticlustering with K = 2 was applied
    + subdirectory K3: data sets where anticlustering with K = 3 was applied
- R scripts that start with "0-functions" are function definitions 
  that are used throughout the simulation. These files are "sourced" 
  from the R-scripts that start with numbers > 1.
- The script "1-Generate-Data.R" should not be called because doing so
  would generate another 10,000 data files, but the data sets already 
  exist. (Therefore, only execute the script if you *really* want more
  data sets.)
- To reproduce the simulation (i.e., applying the anticlustering methods
  on the 10,000 data sets), execute all of the commands in the script 
  "2-Call-Methods.R". This will not reproduce the results exactly
  because most methods rely on random number generation.
- To just reproduce the analysis reported in the paper (and not re-run the 
  simulation), execute all commands in the script "3-Compute-Objectives.R" and 
  "4-Aggregate-Results.R". Doing so will compute the three objectives reported in 
  the manuscript for each simulation run for each method, and then aggregate the 
  results to reproduce the data from Table 2 in the paper (by writing the results 
  to the files "results-K2-aggregated.csv" and  "results-K3-aggregated.csv")
- The file CODEBOOK.md contains information on the variables in the 
  data sets.
- Make sure that the R working directory is set into this directory when
  working with any of the scripts

## Dependencies: 

To reproduce the simulation itself (i.e., applying anticlustering functions to 
the data), the `anticlust` package must be installed (version >= 0.3.0). 
Additionally, to call the exact methods, an integer linear programming solver 
must be installed and callable from `R`. It is probably useful to install one of 
the commercial solvers gurobi or CPLEX because they are much faster than the 
open source GNU linear programming kit (GLPK). Researchers can obtain a free (as 
in free beer) license for the commercial solvers.

Note that to use a commercial integer linear programming solver, the old 
`anticlust` version 0.3.0 **must** be used, which was also used for the 
simulation reported in the paper. To install this version of `anticlust`, use 
the following code:

```
library("remotes") # if not available: install.packages("remotes")
install_github("m-Py/anticlust", ref = "v0.3.0")
```

To run the simulation presented in the paper, CPLEX version 12.8 was used as the 
ILP solver, interfaced from the package `Rcplex`, which has to be installed 
manually in addition to `anticlust`, as it is only an optional dependency and 
not automatically installed when installing `anticlust`:

```
install.packages("Rcplex")
```

Unfortunately, the R package 
[`Rcplex`](https://CRAN.R-project.org/package=Rcplex) seems to be quite dated; 
the last update on CRAN is version 0.3-3 from 2016-06-09 (I last checked on 
2020-10-06). This version of the package `Rcplex` did not find my CPLEX 
installation when I used a newer version of CPLEX (Version 12.10). So, I suppose 
that the old version CPLEX 12.8 has to be used to reproduce the integer linear 
programming anticlustering methods. It is of course also possible to just use 
the free GLPK, but this may be very slow and have difficulties to solve the K = 
3 cases at all. Feel free to contact me with problems.
