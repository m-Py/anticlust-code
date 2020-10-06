
# Author: Martin Papenberg
# Year: 2019-2020

#' Compute objective values for a given method and data set
#' 
#' This function works with the files results-K2-solutions.csv / 
#' results-K3-solutions.csv and assumes that the input is a row
#' in one of these files.

compute_objectives <- function(row, K) {
  data <- read.csv(paste0("datasets/K", K, "/", row["file"], ".csv"))
  anticlusters <- anticlusters_from_string(row["result"])
  dist_obj <- diversity(data, clusters = anticlusters)
  means_obj <- var_means(anticlusters, data)
  sd_obj <- var_sds(anticlusters, data)
  ## hier mit der Datei arbeiten, die die Lösungen enthält
  return(c(
    row["ID"],
    row["method"],
    dist_obj = dist_obj,
    means_obj = means_obj,
    sd_obj = sd_obj
  ))
}

# Get anticlusters from data file string
anticlusters_from_string <- function(string) {
  c(sapply(strsplit(as.character(string), ","), as.numeric))
}

#' Quantify set similarity by discrepancy in feature means 
#' @param clusters A vector of cluster assignments
#' @param data A N x M table of item features
#' 
#' @return The objective. Lower values are better

var_means <- function(clusters, data) {
  featurewise_diff(by(data, clusters, colMeans), K)
}

#' Quantify set similarity by discrepancy in feature standard deviations 
#' @param clusters A vector of cluster assignments
#' @param data A N x M table of item features
#' 
#' @return The objective. Lower values are better
var_sds <- function(clusters, data) {
  featurewise_diff(by(data, clusters, function(x) apply(x, 2, sd)), K)
}

# Determine the range in means and standard deviations per feature
featurewise_diff <- function(x, K) {
  mat <- matrix(unlist(x), ncol = K)
  mat <- apply(mat, 1, range_diff)
  mean(mat)
}

# Determine the maximum range in a vector
range_diff <- function(x) {
  diff(range(x))
}

# Compute diversity (distance objective)
diversity <- function(clusters, x) {
  x <- as.matrix(x)
  sum(diversity_objective_by_group(clusters, x))
}

# Compute distance objective by cluster
# param data: distance matrix or feature matrix
# param cl: cluster assignment
diversity_objective_by_group <- function(cl, data) {
  sapply(
    sort(unique(cl)), 
    function(x) sum(dist(data[cl == x, ]))
  )
}
