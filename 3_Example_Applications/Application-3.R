
# Author: Martin Papenberg
# Year: 2020

# This script reproduces Application III (Parallel test splits) in
# "Using anticlustering to partition data sets into equivalent parts" 
# (Papenberg & Klau, 2019).

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
set.seed(123)


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


## 5. Compute item difficulty and item discrimination

# Define a function that computes part-whole corrected item discrimination
# param `items` is a N x M matrix, rows = persons, columns = items
part_whole_discrimination <- function(items) {
  discriminations <- rep(NA, ncol(items))
  for (i in 1:ncol(items)) {
    score <- rowSums(items[, -i])
    discriminations[i] <- cor(items[[i]], score)
  }
  discriminations
}

# Select the columns containing the item scores 
item_responses <- subset(npi, select = score_Q1:score_Q40)
difficulty <- colMeans(item_responses)
discrimination <- part_whole_discrimination(item_responses)
item_indices <- cbind(difficulty, discrimination)


## 6. Anticlustering

item_sets <- anticlustering(
  item_indices,
  K = 4
)

## 7. Evaluate results

# Anticlustering
mean_sd_tab(item_indices, item_sets)

# Random assignment
mean_sd_tab(item_indices, sample(item_sets))

# Similarity in inter item correlations
avg_item_correlation_by_set <- function(item_sets, items) {
  indices <- sort(unique(item_sets))
  sapply(indices, function(i) mean(as.dist(cor(items[, item_sets == i]))))
}
avg_item_correlation_by_set(item_sets, item_responses) |> round(2)
