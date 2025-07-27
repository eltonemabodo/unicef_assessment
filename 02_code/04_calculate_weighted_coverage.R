### Weighted Indicators


required_indicators <- complete_merged_data %>% 
  group_by(status_u5mr) %>%
  ## Summarise the weighted coverage of indicators, by birth date estimates
  summarise(
    weighted_ANC4 = weighted.mean(`ANC4+`, w = births_thousands, na.rm = TRUE),
    weighted_SBA  = weighted.mean(SBA,  w = births_thousands, na.rm = TRUE),
    n_countries   = n()
  )

###########################################