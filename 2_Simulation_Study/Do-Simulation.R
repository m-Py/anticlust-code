

# For the existing data, call method, compute objectives, and aggregate results
source("2-Call-Methods.R")
start <- Sys.time()
source("3-Compute-Objectives.R")
source("4-Aggregate-Results.R")
print(Sys.time() - start)
