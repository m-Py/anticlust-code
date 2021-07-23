
# Author: Martin Papenberg
# Year: 2021


#' Apply several anticlustering methods to a data set
#' 
#' @param file The name of the file to be analyzed
#' @param path The path to the file to be analyzed
#' @param K The number of groups to be created
#' 
#' @return A data frame that contains the anticluster assignment per method
#'     Primarily, however, this function is called to write the results to
#'     a file.
#' 

anticluster_data <- function(file, path, K) {
  message("Processing file `", file, "` with K = ", K)
  data <- read.csv(paste0(path, file))
  clusters <- anticluster_data_(data, K)
  # Convert data to data.frame
  clusters <- data.frame(
    method = names(clusters), 
    result = sapply(clusters, toString)
  )
  ## Add information on simulation run
  infos <- info_from_filename(file)
  clusters <- data.frame(infos, clusters)
  rownames(clusters) <- NULL
  
  ## Write the results to file
  results_file <- paste0("results-", paste0("K", K), "-solutions.csv")
  if (file.exists(results_file)) {
    # Ensure that the same data file is not processed again 
    # (should not happen anyway, but be sure of that)
    results <- read.csv2(results_file, stringsAsFactors = FALSE)
    if (any(grepl(clusters$ID[1], results$ID))) {
      message("Warning: file ", clusters$ID[1], " was already processed")
      return(NULL)
    }
    write.table(clusters, results_file, row.names = FALSE, sep = ";", 
                append = TRUE, col.names = FALSE)
  } else {
    write.table(clusters, results_file, row.names = FALSE, sep = ";", 
                append = FALSE, col.names = TRUE)
  }
  clusters
}

# Internal function that actually calls the anticlustering methods
anticluster_data_ <- function(data, K) {
  
  N <- nrow(data)

  ## Generate data matrix for storing the objective values
  methods <- c(
    "ace-exchange",
    "k-means-exchange",
    "kplus",
    "random"
  )
  clusters <- as.list(rep(NA, length(methods)))
  names(clusters) <- methods
  repetitions <- 5
  
  standardize <- TRUE
  
  ## Apply methods
  for (i in methods) {
    if (i == "ace-exchange") {
      clusters[[i]] <- anticlustering(
        data, 
        K = K,
        method = "local-maximum",
        repetitions = repetitions,
        standardize = standardize
      )
    } else if (i == "k-means-exchange") {
      clusters[[i]] <- anticlustering(
        data, 
        K = K,
        objective = "variance",
        method = "local-maximum",
        repetitions = repetitions,
        standardize = standardize
      )
    } else if (i == "kplus") {
      clusters[[i]] <- anticlustering(
        data, 
        K = K,
        objective = "kplus",
        method = "local-maximum",
        repetitions = repetitions,
        standardize = standardize
      )
    } else if (i == "random") {
      clusters[[i]] <- sample(rep_len(1:K, N))
    }
  }
  clusters
}
