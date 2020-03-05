
# Author: Martin Papenberg
# Year: 2020

# This script reproduces Application II (Independent samples for cross
# validation) in "Using anticlustering to partition data sets into 
# equivalent parts" (Papenberg & Klau, 2019).

# The code can simply be executed from top to bottom.

## 1. Load - and, if required, install - package `anticlust`

if (!requireNamespace("anticlust")) {
  if (!requireNamespace("remotes")) {
    install.packages("remotes")
  }
  remotes::install_github("m-Py/anticlust")
}

library(anticlust)


## 2. Set random seed for reproducibility

# If you want to exactly reproduce the results reported in the
# manuscript, set the seed as follows (this includes an test whether
# the R version is >= 3.6 because the behaviour of the random seed
# differs between 3.5 and 3.6)
r_minor <- as.numeric(strsplit(R.Version()$minor, "")[[1]][1])
r_major <- as.numeric(R.Version()$major)
if (r_major >= 4 || (r_major == 3 && r_minor >= 6)) {
  RNGkind(sample.kind = "Rounding")
} 
set.seed(1234)


## 3. Load data

# The data (NPI data set) used in this example is retrieved from
# https://openpsychometrics.org/_rawdata/.

# We can directly download the data in R. It is a zip archive and
# needs to be extracted, then the data is read from the zip archive
# (and stored in the variable `npi`). All steps are accomplished with
# the following lines of code:
temp <- tempfile()
download.file("http://openpsychometrics.org/_rawdata/NPI.zip", temp)
npi <- read.csv(unz(temp, "NPI/data.csv")) # reads the data into R
unlink(temp)
rm(temp)


## 4. Clean data (exclude persons having missing responses)

temp <- npi[, paste0("Q", 1:40)]
temp[temp == 0] <- NA # 0 = missing value in this data set
npi <- npi[complete.cases(temp), ]
rm(temp)


## 5. Score the items 
# 1: narcissistic response was selected
# 0: narcissistic response was *not* selected

# The following vector encodes the key (i.e., narcissistic response)
# by item:
keys <- c(1, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 1, 1, 1, 2, 1, 2, 2, 2, 2,
          1, 2, 2, 1, 1, 2, 1, 2, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 2)

# Use for-loop to score all 40 items using the key
for (i in 1:40) {
  colname <- paste0("Q", i)
  npi[[paste0("score_", colname)]] <- ifelse(npi[[colname]] == keys[i], 1, 0)
}


## 6. Anticlustering 

# Select item scores to the 40 items; these are the data input for
# k-means anticlustering
item_responses <- subset(npi, select = score_Q1:score_Q40)

start <- Sys.time()
samples <- fast_anticlustering(
  item_responses, 
  K = 5,
  categories = npi$gender,
  k_neighbours = 5
)
Sys.time() - start

# A random assignment for comparison
rnd_assignment <- sample(samples)

# Append sample assignments to data frame
npi$anticlusters <- samples
npi$rnd_assignment <- rnd_assignment

# - Optionally: write results to file
# write.table(
#   npi[, c("anticlusters", "rnd_assignment")],
#   file = "npi_anticlusters.csv",
#   row.names = FALSE,
#   sep = ",",
#   col.names = TRUE
# )


## 7. Evaluate results

# Check out similarity of item means (rounded on two decimals)
means_by_group <- function(features, anticlusters) {
  data.frame(lapply(by(features, anticlusters, function(x) round(colMeans(x), 2)), c))
}
# 1. For anticlustering
item_means_ac <- means_by_group(item_responses, npi$anticlusters)
# 2. For random assignment
item_means_rnd <- means_by_group(item_responses, npi$rnd_assignment)

# How often did all item means agree across the five groups?
# - for anticlustering
sum(apply(item_means_ac, 1, function(x) all(x == x[1])))
# - for random assignment
sum(apply(item_means_rnd, 1, function(x) all(x == x[1])))

# Check out similarity of groups on average item scores
# - for anticlustering
lapply(by(item_responses, npi$anticlusters, rowSums), function(x) round(mean(x), 2))
# - for random assignment
lapply(by(item_responses, npi$rnd_assignment, rowSums), function(x) round(mean(x), 2))


## 8. Check that gender is balanced
table(npi$anticlusters, npi$gender)
# Compare to random assignment (not balanced)
table(npi$rnd_assignment, npi$gender)
