install.packages("here")
library("here")
here()

# Getting the data and merging them

sample_data <- read.csv(here("Kickstarter_2026-09-10T03_20_48_478Z", "Kickstarter000.csv"))
setwd(here("Kickstarter_2026-09-10T03_20_48_478Z"))

file_list <- list.files(pattern = "^Kickstarter.*\\.csv$", full.names = TRUE)

data_list <-lapply(file_list, read.csv)

all_data <- do.call(rbind, data_list)

# Some Initial checks on data and maybe cleaning

# Some visualizations

# Some dependency checks

# Calculating impacts on success of a kickstarter
