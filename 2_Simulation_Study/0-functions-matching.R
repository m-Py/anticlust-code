
# Author: Martin Papenberg
# Year: 2019

#' Greedy matching approach for anticlustering
#'
#' @param distances An N x N distance matrix describing dissimilarities
#'     between N elements
#'
#' @return A vector representing the set each item was assigned to
#'
#' @details
#'
#' Extending the procedure proposed by Lahl and Pietrowsky (2006), this
#' function sequentially assigns the two closest neighbours to two
#' different groups. It can be used to create two similar sets.
#'
#' @references
#'
#' Lahl, O., & Pietrowsky, R. (2006). EQUIWORD: A software application
#' for the automatic creation of truly equivalent word lists. Behavior
#' Research Methods, 38, 146–152.
#'
matching_anticlustering <- function(distances) {

  ## Prepare the distance matrix
  distances <- as.matrix(distances)
  diag(distances) <- Inf
  N <- nrow(distances)
  if (N %% 2 != 0) {
    stop("The number of features must fit into two sets")
  }

  ## Repeatedly select the closest items and assign them to
  ## different anticlusters
  anticlusters <- rep(NA, N)
  for (i in 1:(N/2)) {
    ## Select the closest pair (if the smallest distance occurs more
    ## than once, select the first pair)
    pair <- which(distances == min(distances), arr.ind = TRUE)[1, ]
    ## Randomly assign the two stimuli to two different clusters:
    anticlusters[pair] <- sample(2)
    ## Remove used stimuli from the pool
    distances[pair, ] <- Inf
    distances[, pair] <- Inf
  }
  ## Assert that the output has the correct structure:
  if (table(anticlusters)[1] !=  table(anticlusters)[2]) {
    stop("Something went wrong: not the same set sizes")
  }
  if (any(is.na(anticlusters))) {
    stop("Something went wrong: NA in output")
  }
  return(anticlusters)
}
