
# README

Author: Martin Papenberg
Year: 2019

---

This directory contains simulation code and data accompanying the
manuscript "Using anticlustering to partition data sets into equivalent 
parts" (Papenberg & Klau, 2019).

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
- To just reproduce the analysis reported in the paper, execute all 
  commands in the script "3-Compute-Objectives.R" and "4-Aggregate-Results.R". 
  Doing so will compute the three objectives reported in the manuscript
  for each simulation run for each method, and the aggregate the results
  to reproduce Table 2 from the paper (by writing the results to 
  the files "results-K2-aggregated.csv" and  "results-K3-aggregated.csv")
- The file CODEBOOK.md contains information on the variables in the 
  data sets.
- Make sure that the R working directory is set into this directory when
  working with any of the scripts

## Dependencies: 

To reproduce the simulation itself (i.e., applying anticlustering 
functions to the data), the `anticlust` package must be installed
(version >= 0.3.0). Additionally, to call the exact methods, an
integer linear programming solver must be installed and callable
from `R`. See `?anticlust` for more information. It is beneficial to 
install one of the commercial solvers gurobi or CPLEX because they 
are much faster than the open source GNU linear programming kit.
Researchers can obtain a free (as in free beer) license for the 
commercial solvers.

Note that to use a commercial integer linear programming solver,
(old) `anticlust` version 0.3.0 **must** be used, which was also 
used for the simulation reported in the paper. To install this 
version of `anticlust`, use the following code:

```
library("remotes") # if not available: install.packages("remotes")

install_github("m-Py/anticlust", ref = "v0.3.0")
```
