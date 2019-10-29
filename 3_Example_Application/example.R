

# Author: Martin Papenberg
# Year: 2019

# This script can be used to reproduce the example application 
# reported in the manuscript "Using anticlustering to partition 
# a stimulus pool into equivalent parts" (Papenberg & Klau, 2019)

library(anticlust)

# If you want to exactly reproduce the results reported in Table 4, 
# set the following seed and execute the script from top to bottom
# (if you are using R version >= 3.6, uncomment and execute the 
# following line before setting the seed)
# RNGkind(sample.kind = "Rounding")
set.seed(521)

# Load data
data(schaper2019)

# Look at data:
head(schaper2019)
# For more information on the data set, umcomment and execute the
# following line:
# ?schaper2019

# Select the four features that should be similar across 3 lists:
features <- schaper2019[, 3:6]

# Now: Compare anticluster editing and k-means anticlustering

# 1. Anticluster editing
ac_ace <- anticlustering(
  features, 
  K = 3, 
  categories = schaper2019$room, # balances category across lists
  objective = "distance" # is the default option
)
# Check output
ac_ace

# 2. K-Means Anticlustering
ac_kmeans <- anticlustering(
  features, 
  K = 3, 
  categories = schaper2019$room,
  objective = "variance"
)
# Check output
ac_kmeans

# Compare feature means:
by(features, ac_ace, function(x) round(colMeans(x), 2))
by(features, ac_kmeans, function(x) round(colMeans(x), 2))

# Compare standard deviations:
by(features, ac_ace, function(x) round(apply(x, 2, sd), 2))
by(features, ac_kmeans, function(x) round(apply(x, 2, sd), 2))

# 3. Compare to manual assignment
# Means
by(features, schaper2019$list, function(x) round(colMeans(x), 2))
# Standard deviations
by(features, schaper2019$list, function(x) round(apply(x, 2, sd), 2))

# 4. Compare to random assignment
random <- sample(schaper2019$list)
# Means
by(features, random, function(x) round(colMeans(x), 2))
# Standard deviations
by(features, random, function(x) round(apply(x, 2, sd), 2))
