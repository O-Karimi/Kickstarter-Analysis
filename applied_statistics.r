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

initial_cleanup <- initial_cleanup %>%
  select(-usd_pledged)

dim(initial_cleanup)

## Let's check jsons

install.packages("jsonlite")
library("jsonlite")

category_example <- initial_cleanup$category[1]

cat(category_example)

parsed_category <- fromJSON(category_example)

str(parsed_category)

expanded_cleanup <- initial_cleanup

install.packages("purrr")
library("purrr")

########category

parsed_category_col <- expanded_cleanup$category %>%
  map(~ fromJSON(.x)) %>%
  bind_rows()

parsed_category_col <- parsed_category_col %>%
  rename_with(~ paste0("category_", .x))
unique(parsed_category_col$category_id)
length(unique(parsed_category_col$category_id))
#table(parsed_category_col$category_id)

unique(parsed_category_col$category_analytics_name)
length(unique(parsed_category_col$category_analytics_name))

unique(parsed_category_col$category_name)
length(unique(parsed_category_col$category_name))

parsed_category_col %>% filter(category_name != category_analytics_name)

parsed_category_col <- parsed_category_col %>%
  select(-category_analytics_name)

parsed_category_col <- parsed_category_col %>%
  select(-category_slug)

parsed_category_col <- parsed_category_col %>%
  select(-category_position)

parsed_category_col <- parsed_category_col %>%
  select(-category_color)

parsed_category_col <- parsed_category_col %>%
  select(-category_urls)

length(unique(parsed_category_col$category_name))
length(unique(parsed_category_col$category_id))

length(unique(parsed_category_col$category_parent_name))
length(unique(parsed_category_col$category_parent_id))

#unique(parsed_category_col$category_id + parsed_category_col$category_name)

id_vs_name <- parsed_category_col %>%
  distinct(category_id, category_name)

print(id_vs_name)

expanded_cleanup <- expanded_cleanup %>%
  bind_cols(parsed_category_col)
  

expanded_cleanup <-expanded_cleanup %>%
  select(-category)

####### Creator

creator_example <- expanded_cleanup$creator[1]

cat(creator_example)

parsed_creator <- fromJSON(creator_example)

str(parsed_creator)

safe_fromJSON <- possibly(fromJSON, otherwise = NULL)

#parsed_creator_col <- expanded_cleanup$creator %>%
#  map(~ safe_fromJSON(.x)) %>%
#  bind_rows()

parse_and_clean <- function(x) {
  parsed <- fromJSON(x, simplifyVector = FALSE)
  simple_only <- keep(parsed, ~ is.atomic(.x) && length(.x) == 1)
  return(as.data.frame(simple_only))
}

safe_fromJSON <- possibly(parse_and_clean, otherwise = data.frame(failed_json = TRUE))

parsed_creator_col <- expanded_cleanup$creator %>%
  map(~ safe_fromJSON(.x)) %>%
  bind_rows() %>%
  select(-any_of("failed_json"))

parsed_creator_col <- parsed_creator_col %>%
  rename_with(~ paste0("creator_", .x))

unique(parsed_creator_col$creator_is_ksr_admin)

parsed_creator_col <- parsed_creator_col %>%
  select(-creator_is_ksr_admin)

unique(parsed_creator_col$creator_partner_badge)
table(parsed_creator_col$creator_partner_badge) # Outcome was only 42 so there is no point in keeping it

parsed_creator_col <- parsed_creator_col %>%
  select(-creator_partner_badge)

unique(parsed_creator_col$creator_has_admin_message_badge)

parsed_creator_col <- parsed_creator_col %>%
  select(-creator_has_admin_message_badge)

unique(parsed_creator_col$creator_backing_action_count)
table(parsed_creator_col$creator_backing_action_count) # Under 1500 row which is less than 1 percent

parsed_creator_col <- parsed_creator_col %>%
  select(-creator_backing_action_count)

unique(parsed_creator_col$creator_ppo_has_action)
table(parsed_creator_col$creator_ppo_has_action)

table(expanded_cleanup$state)
parsed_creator_col <- parsed_creator_col %>%
  select(-creator_ppo_has_action)

parsed_creator_col <- parsed_creator_col %>%
  select(-creator_slug)


expanded_cleanup <- expanded_cleanup %>%
  bind_cols(parsed_creator_col)
  

expanded_cleanup <-expanded_cleanup %>%
  select(-creator)

expanded_cleanup <-expanded_cleanup %>%
  select(-is_liked)

expanded_cleanup <-expanded_cleanup %>%
  select(-is_disliked)

expanded_cleanup <-expanded_cleanup %>%
  select(-urls)

###### location

location_example <- expanded_cleanup$location[1]

cat(location_example)

parsed_location <- fromJSON(location_example)

str(parsed_location)

expanded_cleanup <-expanded_cleanup %>%
  select(-location)
####### photo

photo_example <- expanded_cleanup$photo[1]

cat(photo_example)

parsed_photo <- fromJSON(photo_example)

str(parsed_photo)

parsed_photo_col <- expanded_cleanup$photo %>%
  map(~ fromJSON(.x)) %>%
  bind_rows()

expanded_cleanup <-expanded_cleanup %>%
  select(-photo)

###### profile

profile_example <- expanded_cleanup$profile[1]

cat(profile_example)

parsed_profile <- fromJSON(profile_example)

str(parsed_profile)

parsed_profile_col <- expanded_cleanup$profile %>%
  map(~ safe_fromJSON(.x)) %>%
  bind_rows() %>%
  select(-any_of("failed_json")) # Drop the empty placeholder column

parsed_profile_col <- parsed_profile_col %>%
  rename_with(~ paste0("profile_", .x))

expanded_cleanup <-expanded_cleanup %>%
  select(-profile)

###### video

expanded_cleanup <- expanded_cleanup %>%
  mutate(
    has_video = if_else(video == "null" | is.na(video), "No", "Yes"),
    
    has_video = as.factor(has_video)
  ) %>%
  select(-video)

table(expanded_cleanup$has_video)


#--------------- Some visualizations

#---------------- Some dependency checks and hypothesis checks

#------------------ Calculating impacts on success of a kickstarter
