
# Author: Martin Papenberg
# Year: 2019, 2020

## Solve the Divide and Select problem using the `anticlust` package

# Update 2019-11-25:
# With the most recent development version, there is functionality 
# available that facilitates solving the Divide and Select problem
# using the `anticlust` package. See the vignette under 
# https://m-py.github.io/anticlust/stimulus-selection.html 

#### ------------------ 

# Update 2020-01-28:
# With the new version 0.4.0, the below method of solving Divide & Select 
# is deprecated, use https://m-py.github.io/anticlust/stimulus-selection.html 
# instead. To nevertheless reproduce it, install the package version 0.3.0
# as follows: 
# remotes::install_github("m-Py/anticlust", ref = "v0.3.0")

#### ------------------ 

library(anticlust)

# Use the schaper2019 data set as an example

data("schaper2019")
head(schaper2019)
# Append numeric ID variable to data frame (needed for visualization later)
schaper2019$id <- 1:nrow(schaper2019)

# Create two sample of N = 12 that differ strongly on frequency but
# are similar on the other variables

##################
# 1. Divide step #
##################

# Divide by Frequency - here, I select elements from the lowest and 
# highest quantile on frequency
thresholds <- quantile(schaper2019$frequency)[c(2, 4)]

low <- schaper2019[schaper2019$frequency <= thresholds[1], ]
low$category <- 1
high <- schaper2019[schaper2019$frequency >= thresholds[2], ]
high$category <- 2

# Bind the preselected items (high and low on frequency) into a single data frame
highlow <- rbind(low, high)

# Visualize preselected items
colors <- ifelse(schaper2019$id %in% low$id, "red", "grey")
colors <- ifelse(schaper2019$id %in% high$id, "green", colors)
plot(schaper2019[, 3:6], col = colors, pch = c(4, 19)[as.numeric(schaper2019$id %in% highlow$id) + 1])

# The preselection can be done differently; the user has to decide.
# Change the selection of high and low frequency words and check the 
# visualization for a good preselection

##################
# 2. Select step #
##################

# Choose 12 items in such a way that they are as similar as possible
# on the three other variables

# Use the anticlustering function. Makes use of the categories argument
# and the possibility to pass a custom K argument that describes the inital
# assignment. In combination, these arguments ensure that high and low
# frequency words remain in different sets while the similarity with
# regard to the other variables is optimized.
initial_sets <- initialize_K(groups = highlow$category, n = c(12, 12))
# check out
initial_sets # NA means that an element is currently not part of a set; 
# this may change throughout the exchange algorithm
highlow$ac <- anticlustering(
  highlow[, 3:5],
  K = initial_sets,
  categories = highlow$category,
  objective = mean_sd_obj
)
# We use the mean_sd_obj() objective function to make sets similar
# with regard to mean, median and standard deviation. Note that this
# is not an anticlustering application and the objectives "distance"
# and "variance" may not work as desired. Anticlustering assumes that
# all items from a pool are assigned to a set, which is different
# from the Divide and Select problem.

## Check out output
highlow$ac # NA means an element was not selected

# Exclude not selected elements
selected <- na.omit(highlow)


#####################
# Check out results #
#####################

## Check means
by(
  selected[, 3:6], 
  selected$category, 
  function(x) round(colMeans(x), 2)
)

## Check SDs
by(
  selected[, 3:6], 
  selected$category, 
  function(x) round(apply(x, 2, sd), 2)
)
# (SD in frequency depends on preselection)

# Visualize final item selection - compare to initial selection
colors <- ifelse(schaper2019$id %in% selected$id[selected$category == 1], "red", "grey")
colors <- ifelse(schaper2019$id %in% selected$id[selected$category == 2], "green", colors)
plot(schaper2019[, 3:6], col = colors, pch = c(4, 19)[as.numeric(schaper2019$id %in% selected$id) + 1])


# Try out the code above several times to see how the solutions vary
# (the initial state of the exchange algorithm will vary; test out
# calling the `initialize_K()` function above several times)
