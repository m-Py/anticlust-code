
# Author: Martin Papenberg
# Year: 2021

# First step in the simulation: Generate data
source("0-functions-generate-data.R")

sample_sizes <- 12 * 2:25 # 24 - 300
nsets <- 10000

## Generate some data with random input for K = 2

N <- sample(sample_sizes, replace = TRUE, size = nsets)
M <- sample(1:10, replace = TRUE, size = nsets)
dists <- sample(c("normal", "uniform", "normal-wide"), replace = TRUE, size = nsets)

# Store data sets as files
for (i in 1:nsets) {
  generate_data(N[i], M[i], dists[i], dir = "./datasets/")
}
