
# Author: Martin Papenberg
# Year: 2019

# Load required packages
library(anticlust)

source("0-functions-matching.R")
source("0-functions-anticlustering-methods.R")
source("0-functions-generate-data.R")

# Repeat the simulation for K = 2 and K = 3 
for (K in 2:3) {
  
  # Select all data files
  n_Clusters <- paste0("K", K)
  path <- paste0("./datasets/", n_Clusters, "/")
  files <- paste0(list.files(path = path))
  
  ## Check that no analysis is repeated that has been conducted previously
  results_file <- paste0("results-", n_Clusters, "-solutions.csv")
  if (file.exists(results_file)) {
    previous_tests <- as.character(unique(read.csv(results_file, sep = ";")$file))
    previous_tests <- paste0(previous_tests, ".csv")
    already_done <- files %in% previous_tests
    ## Only select tests that have not been tested before!
    files <- files[!already_done]
  }
  
  # Uncomment the following line and exchange the value of the size 
  # argument if not all 2x 5000 file should be processed at the same time
  # files <- sample(files, size = 300)
  
  ## Apply all methods to the data sets
  message("Starting to work on ", length(files), " data sets")
  start <- Sys.time()
  lapply(files, anticluster_data, path = path, K = K)
  print(Sys.time() - start)
}

