
# Author: Martin Papenberg
# Year: 2019

# This script can be used to reproduce the run time computation
# reported in the manuscript "Using anticlustering to partition 
# data sets into equivalent parts" (Papenberg & Klau, 2019)


# Compute run time for the anticlustering methods by N

library(anticlust)

K <- 2
N <- c(seq(10, 30, 2), 4:10 * 10)
M <- 2

runtimes <- matrix(ncol = 3, nrow = length(N))
runtimes <- cbind(N, runtimes)
colnames(runtimes) <- c("N", "Exact ILP", "ILP/Preclustering", "Exchange method")

for (i in seq_along(N)) {
  # Generate random data
  features <- matrix(rnorm(N[i] * M), ncol = M)
  if (N[i] < 40) {
    start <- Sys.time()
    anticlustering(features, K = K, method = "ilp") 
    runtimes[i, "Exact ILP"] <- difftime(Sys.time(), start, units = "s")
  }
  if (N[i] < 80) {
    start <- Sys.time()
    anticlustering(features, K = K, method = "ilp", preclustering = TRUE) 
    runtimes[i, "ILP/Preclustering"] <- difftime(Sys.time(), start, units = "s")
  }
  start <- Sys.time()
  anticlustering(features, K = K)
  runtimes[i, "Exchange method"] <- difftime(Sys.time(), start, units = "s")
}

round(runtimes, 2)

# Write table to file
write.table(runtimes, "runtimes.csv", quote = FALSE, row.names = FALSE)
