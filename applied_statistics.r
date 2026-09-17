install.packages("here")
library("here")
here()

# Getting the data and merging them

sample_data <- read.csv(here("Kickstarter_2026-09-10T03_20_48_478Z", "Kickstarter000.csv"))
setwd(here("Kickstarter_2026-09-10T03_20_48_478Z"))

file_list <- list.files(pattern = "^Kickstarter.*\\.csv$", full.names = TRUE)

data_list <-lapply(file_list, read.csv)

all_data <- do.call(rbind, data_list)

#------------ Some Initial checks on data and maybe cleaning

## First we should see our data and how it looks like

#head(all_data)
dim(all_data)
colnames(all_data)

#str(all_data)

glimpse(all_data)

# Some visualizations

# Some dependency checks and hypothesis checks

# Calculating impacts on success of a kickstarter
