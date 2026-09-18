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

install.packages("dplyr")
library("dplyr")

glimpse(all_data)

##looking around for missing values
summary(all_data)

sum(is.na(all_data))

colSums(is.na(all_data))

table(all_data$country)

table(all_data$state)

#### As I checked manually there are lots of 0 and nulls but in the forms which are not recognizeable to is.na function by default

initial_cleanup <- all_data

glimpse(initial_cleanup)

install.packages("tidyselect")
library("tidyselect")

initial_cleanup <- initial_cleanup %>%
  select(-blurb)

dim(initial_cleanup)

unique(initial_cleanup$country)
unique(initial_cleanup$country_displayable_name)

initial_cleanup <- initial_cleanup %>%
  select(-country)

initial_cleanup <- initial_cleanup %>%
  select(-currency_symbol)

initial_cleanup <- initial_cleanup %>%
  select(-currency_trailing_code)

unique(initial_cleanup$current_currency)

initial_cleanup <- initial_cleanup %>%
  select(-current_currency)

initial_cleanup <- initial_cleanup %>%
  select(-name)

initial_cleanup <- initial_cleanup %>%
  select(-slug)

initial_cleanup <- initial_cleanup %>%
  select(-source_url)

initial_cleanup <- initial_cleanup %>%
  select(-static_usd_rate)

initial_cleanup <- initial_cleanup %>%
  select(-usd_exchange_rate)

unique(initial_cleanup$usd_type)

initial_cleanup <- initial_cleanup %>%
  select(-usd_type)

initial_cleanup <- initial_cleanup %>%
  select(-usd_type)

dim(initial_cleanup)

#--------------- Some visualizations

#---------------- Some dependency checks and hypothesis checks

#------------------ Calculating impacts on success of a kickstarter
