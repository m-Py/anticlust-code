
# Codebook

Author: Martin Papenberg
Year: 2019

---

This file is the codebook for the data sets 

- results-K2-solutions.csv
- results-K3-solutions.csv
- results-K2-objectives-raw.csv
- results-K4-objectives-raw.csv

These files contain the simulation data reported in the manuscript 
"Using anticlustering to partition a stimulus pool into
equivalent parts" (Papenberg & Klau, 2019). 

--- 

## General information

The data sets are given in a format where each row is uniquely 
represented by a combination of (a) anticlustering method 
and (b) an ID that uniquely identifies each simulation run.

In each run, three objectives were computed for a maximum of six methods. 
In particular:

- K = 2: 
    + For N <= 20, six methods were applied
    + for 20 < N <= 40, five methods were applied
    + For N > 40, four methods were applied
- K = 3: 
    + For N <= 20, five methods were applied
    + for 20 < N <= 40, four methods were applied
    + For N > 40, three methods were applied

## Columns

The data sets store the following variables:

- file: the file name of the simulation data set that was processed
- ID: A randomly generated ID that uniquely identifies each simulation run
- N: The sample size associated with a simulation data set
- M: The number of features associated with a simulation data set
- DIST: The distribution that generated the simulation data set
- method: The method that was applied
    + "ilp.exact" - optimal integer linear programming.
    + "ilp.preclustered" - integer linear programming with preclustering restrictions
    + "ace.exchange" - exchange method optimizing the anticluster editing objective
    + "k.means.exchange" - exchange method optimizing the k-means anticlustering objective
    + "matching" - A greedy matching algorithm, see file "0-functions-matching.R" for the implementation
    + "random" - A random allocation of items to anticlusters
- result: A string representing the solution that a method returned (how to assign the elements to sets)
- dist_obj: The anticluster editing objective, referred to D_within in the paper (higher = better)
- means_obj: A measure of the discrepancy in the feature means (lower = better)
- sd_obj: A measure of the discrepancy in the feature standard deviations (lower = better)
