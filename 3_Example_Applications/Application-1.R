
# Author: Martin Papenberg
# Year: 2019-2020

# This script reproduces Application I (Stimulus assignment) in 
# "Using anticlustering to partition a stimulus pool into equivalent parts"
# (Papenberg & Klau, 2019)

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
set.seed(521)


## 3. Load data (is included in the package)
data(schaper2019)

# Look at data:
head(schaper2019)
# For more information on the data set, umcomment and execute the
# following line:
# ?schaper2019

## 4. Anticlustering

# Select the four features that should be similar across 3 lists:
features <- schaper2019[, 3:6]

# Anticluster editing
ac_ace <- anticlustering(
  features, 
  K = 3, # 3 stimulus sets
  categories = schaper2019$room, # balances category across lists
  objective = "distance" # is the default option
)

# K-Means Anticlustering
ac_kmeans <- anticlustering(
  features, 
  K = 3, 
  categories = schaper2019$room,
  objective = "variance"
)

## 5. Evaluate results

# Compare feature means and standard deviations
# Anticluster editing
mean_sd_tab(features, ac_ace)

# k-means anticlustering
mean_sd_tab(features, ac_kmeans)

# Manual assignment
mean_sd_tab(features, schaper2019$list)

# Random assignment
mean_sd_tab(features, sample(schaper2019$list))
