
# Author: Martin Papenberg
# Year: 2021

#' Compute objective values for a given method and data set
#' 
#' This function works with the files results-K2-solutions.csv / 
#' results-K3-solutions.csv and assumes that the input is a row
#' in one of these files.
#' 
#' A `row` is a character vector.
#' 

compute_objectives <- function(row, K) {
  filename <- paste0("./datasets/", row["file"], ".csv")
  #print(filename)
  #print(row)
  #print(row$file)
  data <- read.csv(filename)
  anticlusters <- anticlusters_from_string(row["result"])
  kvar_obj <- variance_objective(squared_from_mean(data), anticlusters)
  kmeans_obj <- variance_objective(data, anticlusters)
  means_obj <- var_means(anticlusters, data)
  sd_obj <- var_sds(anticlusters, data)
  
  return(c(
    row["ID"],
    row["method"],
    kvar_obj = kvar_obj,
    kmeans_obj = kmeans_obj,
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

# Compute features for k-means-extended criterion
squared_from_mean <- function(data) {
  apply(data, 2, function(x) (x - mean(x))^2)
}
