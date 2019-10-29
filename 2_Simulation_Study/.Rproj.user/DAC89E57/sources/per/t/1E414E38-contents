
# Author: Martin Papenberg
# Year: 2019

# Load required packages
library(anticlust)
library(dplyr)

## Analyze data for K = 2 and K = 3 and write results to file
for (K in 2:3) {
  results_file <- paste0("results-K", K, "-objectives-raw.csv")
  
  ## Read test results
  ldf <- read.csv(results_file, sep = ";", stringsAsFactors = FALSE)
  message("Number of simulation runs for K = ", K , ": ", length(unique(ldf$ID)), "\n")
  # Ensure that each data set was processed only once
  stopifnot(all(table(ldf$ID) %in% c(3, 4, 5, 6)))

  ## Get optimum per simulation run for the Anticluster Editing objective
  maxima <- ldf %>% 
    group_by(ID) %>% 
    summarise(maximum = max(dist_obj))

  ## Compute relative objective
  merged <- ldf %>% 
    inner_join(maxima) %>% 
    mutate(rel_value = dist_obj / maximum) %>% 
    as_tibble()
  
  # Average performance per simulation run across the different sample
  # categories
  aggregated_objectives <- merged %>% 
    mutate(N_category = factor(
      case_when(N <= 20 ~ 1, 
                N > 20 & N <= 40 ~ 2,
                TRUE  ~ 3),
      levels = 1:3, labels = c("N <= 20", "20 < N <= 40", "N > 40"))
    ) %>% 
    group_by(method, N_category) %>% 
    summarise(Objective = mean(rel_value), D_Means = mean(means_obj), D_SD = mean(sd_obj)) %>% 
    arrange(N_category, -Objective) %>% 
    na.omit() %>%  
    rename(N = N_category)
 
  # rename methods
  aggregated_objectives <- aggregated_objectives %>% 
    ungroup %>%
    mutate(
      method = case_when(
        method == "ilp-exact" ~ "ACE-ILP",
        method == "ilp-preclustered" ~ "ACE-ILP/Preclustering",
        method == "ace-exchange" ~ "ACE-Exchange",
        method == "matching" ~ "Matching",
        method == "k-means-exchange" ~ "K-Means-Anticlustering",
        method == "random" ~ "Random assignment",
        TRUE ~ "should not happen"
      )
    )
  
  ## Write results table
  write.table(aggregated_objectives, paste0("results-K", K, "-aggregated.csv"), 
              quote = TRUE, row.names = FALSE, sep = ";")
}
