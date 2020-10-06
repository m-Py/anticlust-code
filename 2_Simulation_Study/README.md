
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
the data in the script "2-Call-Methods.R"), the `anticlust` package must be 
installed (version >= 0.3.0). Additionally, to call the exact methods, an 
integer linear programming solver must be installed and callable from `R`. It is 
probably useful to install one of the commercial solvers gurobi or CPLEX because 
they are much faster than the open source GNU linear programming kit (GLPK). 
Researchers can obtain a free (as in free beer) license for the commercial 
solvers.

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

The aggregation of the raw simulation data into descriptive statistics (i.e., 
calling the script "4-Aggregate-Results.R") requires that the R package `dplyr` 
(Version >= 0.8.3) is installed: 

```
install.packages("dplyr")
```

## Tipps

### Run the simulation without commercial ILP solver

If you do not get a commercial ILP solver running but want to try out the 
simulation (i.e., execute the script "2-Call-Methods.R"), change the following 
two lines in the script "0-functions-anticlustering-methods.R":

- line 75: `if (i == "ilp-exact" && N <= 20) {`
- change into: `if (i == "ilp-exact" && N <= 14) {`

- line 81: `} else if (i == "ilp-preclustered" && N <= 40) {`
- change into: `} else if (i == "ilp-preclustered" && N <= 18) {`

This way, the ILP methods are only attempted for small data sets (N <= 14 for 
the exact approach; N <= 18 for the approach that includes preclustering 
restrictions). Then the simulation is rather fast when only using the free GLPK 
solver, so you can check easily out how it works. (It then also works for recent 
`anticlust` versions and not only for version 0.3.0.) Note that the results will 
probably differ slightly from the results reported in the manuscript because the 
ILP approach is then only used for smaller data sets. 

### Run the simulation piece by piece

To not run the entire simulation on all 10,000 data sets, I recommend to 
uncomment line 32 in the file "2-Call-Methods.R":

- `# files <- sample(files, size = 300)`

Adjust the value given to `size` as needed; it determines the number of data 
sets that are processed using the different anticlustering techniques (here: 
300). The logic of the script ensures that no data set is processed more than 
once, so feel free to adjust the number of data sets and repeat the simulation 
as often as needed. (The results will be appended to the files 
"results-K2-objectives-raw.csv" and "results-K3-objectives-raw.csv" whenever you 
call "2-Call-Methods.R"). So if you call the script repeatedly, the results 
files will grow. 
