
# Author: Martin Papenberg
# Year: 2019

# First step in the simulation: Generate data
source("0-functions-generate-data.R")

## Generate some data with random input for K = 2
nsets <- 5000
N <- sample(seq(10, 100, by = 2), replace = TRUE, size = nsets)
M <- sample(1:4, replace = TRUE, size = nsets)
dists <- sample(c("normal", "uniform", "normal-wide"), replace = TRUE, size = nsets)

# Store data sets as files
for (i in 1:nsets) {
  generate_data(N[i], M[i], dists[i], dir = "datasets/K2/")
}

## Generate some data with random input for K = 3
nsets <- 5000
N <- sample(seq(12, 99, by = 3), replace = TRUE, size = nsets)
M <- sample(1:4, replace = TRUE, size = nsets)
dists <- sample(c("normal", "uniform", "normal-wide"), replace = TRUE, size = nsets)
for (i in 1:nsets) {
  generate_data(N[i], M[i], dists[i], dir = "datasets/K3/")
}
