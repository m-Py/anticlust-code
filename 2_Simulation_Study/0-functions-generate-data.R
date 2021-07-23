
# Author: Martin Papenberg
# Year: 2021

#' Generate a data set for k-plus anticlustering simulation
#' 
#' @param N the number of elements
#' @param M the number of features
#' @param distribution One of "normal", "normal-wide", "uniform"
#' @param dir The directory where the files are written
#' 
#' @return Nothing. The data set is written to a file using a unique 
#'     ID as file name. The file name also contains information on 
#'     the input parameters that generated the data. 
#'     

generate_data <- function(N, M, distribution, dir = "datasets-K2/") {
  if (distribution == "uniform") {
    FUN <- runif
  } else if (distribution == "normal") {
    FUN <- rnorm
  } else if (distribution == "normal-wide") {
    FUN <- function(x) rnorm(x, 0, sd = 2)
  }
  
  data <- matrix(FUN(N * M), ncol = M)
  file_name <- paste0(
    dir,
    "N", N, "_M", M, "_", distribution, "_", 
    paste0(sample(LETTERS, 4), sample(0:9, 4), collapse = ""),
    ".csv")
  write.table(data, file_name, row.names = FALSE, sep = ",")
  return(invisible(NULL))
}

#' Extract information on simulation run from file name
#' @param file The file name

info_from_filename <- function(file) {
  tests <- list()
  tests$file <- gsub(pattern = ".csv", replacement = "", x = file)
  info <- lapply(
    strsplit(tests$file, "_"), 
    FUN = gsub,
    pattern = "_", 
    replacement = ""
  )
  tests$ID <- sapply(info, function(x) x[4])
  info <- lapply(
    info, 
    FUN = gsub,
    pattern = "N|M", 
    replacement = ""
  )
  tests$N <- sapply(info, function(x) as.numeric(x[1]))
  tests$M <- sapply(info, function(x) as.numeric(x[2]))
  tests$DIST <- sapply(info, function(x) x[3])
  tests
}
