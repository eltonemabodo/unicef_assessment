
##################################################
## Data Loading and Cleaning
##################################################

# 01. Loading the ontrack countries data

on_track_countries <- read_xlsx("01_data/raw_data/On-track and off-track countries.xlsx") %>% 
  ## Clean the variable names using `janitor`
  clean_names() %>%
  ## Convert Variables to factors
  mutate(
    iso3code = as_factor(iso3code),
    official_name = as_factor(official_name),
    status_u5mr = case_when(
      status_u5mr == "On track" | status_u5mr == "Achieved"~ "On Track",
      status_u5mr == "Acceleration Needed" ~ "Off Track",
      TRUE ~ status_u5mr
    ),
    status_u5mr = as_factor(status_u5mr)
  ) %>%
  ## Set variable labels using `labelled`
  set_variable_labels(
    iso3code = "Country Code",
    official_name = "Full Official Country Name",
    status_u5mr = "Under Five Mortality Status"
  )

# 02. Loading global data estimates for the two indicators that are to be calculated

indicator_estimates <- read_xlsx("01_data/raw_data/GLOBAL_DATAFLOW_2018-2022.xlsx") %>%
  ## Clean the variable names using `janitor`
  clean_names() %>% 
  ## Rename the geographic_area variable to official_name for merging with other data sets
  rename(
    official_name = geographic_area
  ) %>% 
  ## Convert Variables to factors
  mutate(
    official_name = as_factor(official_name),
    indicator = as_factor(indicator))

## 3. Join the on_track_countries with the indicator estimates
indicators_on_track <- on_track_countries %>% left_join(
  indicator_estimates,
  by = "official_name"
) %>% 
# Seleect only the relevant columns
  select(
    iso3code, official_name, status_u5mr, indicator, obs_value,
   time_period
  ) %>% 
  ## Change the variables to relevant types
  mutate(
    obs_value = as.numeric(obs_value),
    time_period = as.integer(time_period)
  )%>% 
  ## Pivoting wider so that we will be able to collect the latest value across the years
  pivot_wider(
    names_from = time_period,
    values_from = obs_value
  ) %>% 
  # Getting the latest value across the years _the values used to calculate each indicator
  mutate(
    latest_value = coalesce(`2022`, `2021`, `2020`, `2019`, `2018`)
  ) %>% 
  ## Select only the relevant columns
  select(iso3code, official_name, status_u5mr, indicator, latest_value
  ) %>% 
  ## Filter out the rows with NA values in the indicator column
  filter(
    !is.na(indicator)
  ) %>%
  ## Shortening the indicator names for easier readability
  mutate(
    indicator = if_else(
      indicator == "Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider",
      "ANC4+", "SBA")
  ) %>% 
  ## Pivoting wider to have the indicators in individual columns
  pivot_wider(
    names_from = indicator,
    values_from = latest_value
  )

#### 4. Import the weights data _ projected births for 2020

weights_data <- read_xlsx("01_data/raw_data/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx",
                          sheet = "Projections") %>%
  ## Clean the variable names using `janitor`
  clean_names() %>% 
  # Select only the relevant columns
  select(
    region_subregion_country_or_area,
    births_thousands,
    year
  ) %>%
  ## Rename the region_subregion_country_or_area variable to official_name for merging with other data sets
  rename(
    official_name = region_subregion_country_or_area
  ) %>%
  ## Convert the weight variable to numeric
  mutate(
    births_thousands = as.numeric(births_thousands)
  ) %>%
  ## Filter for only 2022 2022 projections
  filter(year == 2022) %>% 
  ## Select only the relevant columns
  select(-year)


## 5. Join the weights data with the indicators_on_track data

complete_merged_data <- indicators_on_track %>% 
  left_join(
    weights_data,
    by = c("official_name")
  ) %>% 
  filter(
    !is.na(births_thousands) # This is to avoid NAs in the weights data
  ) %>% 
  # Set variable labels
  set_variable_labels(
    iso3code = "Country Code",
    official_name = "Full Official Country Name",
    status_u5mr = "Under Five Mortality Status",
    `ANC4+` = "Antenatal Care 4+ Visits",
    SBA = "Skilled Birth Attendance",
    births_thousands = "2022 Projected Births (Thousands)"
  )


## 6. Save the cleaned data to processed_data directory

write_xlsx(complete_merged_data, "01_data/processed_data/complete_merged_data.xlsx")




