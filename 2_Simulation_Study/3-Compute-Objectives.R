
# Author: Martin Papenberg
# Year: 2021

# Load required packages
library(anticlust)

source("0-functions-analyze-data.R")

for (K in 2:4) {
  # Read the file that contains the solutions and compute the objectives
  # for each solution.
  data <- read.csv2(paste0("results-K", K, "-solutions.csv"), stringsAsFactors = FALSE)
  # Compute all objectives and structure data in long format
  all_objectives <- t(apply(data, 1, compute_objectives, K = K))
  # make objectives numeric
  all_objectives <- data.frame(all_objectives[, 1:2], apply(all_objectives[, -(1:2)], 2, as.numeric))

  # Merge with initial data frame to have all info available
  results <- merge(data, all_objectives, by = c("ID", "method"))
  results$result <- NULL # remove the solution from this data frame
  
  ## Write the results to file
  results_file <- paste0("results-K", K, "-objectives-raw.csv")
  write.table(results, results_file, row.names = FALSE, sep = ";", 
              append = FALSE, col.names = TRUE)
}
