
# Author: Martin Papenberg
# Year: 2020

# Load required packages
library(dplyr)
library(ggplot2)
library(tidyr)

## Analyze data for K = 2 and K = 3 and write results to file
filename <- paste0("results-K", 2, "-objectives-raw.csv")
ldf2 <- read.csv(filename, sep = ";", stringsAsFactors = FALSE)
ldf2$K <- 2
filename <- paste0("results-K", 3, "-objectives-raw.csv")
ldf3 <- read.csv(filename, sep = ";", stringsAsFactors = FALSE)
ldf3$K <- 3

ldf <- rbind(ldf2, ldf3)

length(unique(ldf$ID))
table(table(ldf$ID))

aggregated <- ldf %>% 
  group_by(method, N, K) %>% 
  summarise(D_Means = mean(means_obj), D_SD = mean(sd_obj)) %>% 
  arrange(N, D_Means) %>%  #make long format
  pivot_longer(
    cols = starts_with("D_"), 
    names_to = "objective"
  )
  

ggplot(aggregated, aes(x = N, y = value, colour = method)) + 
  geom_point(size = 3) + 
  facet_grid(cols = vars(objective), rows = vars(K), scales = "free") + 
  theme_bw(base_size = 22)
  
  

