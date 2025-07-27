###############################################
# UNICEF Education Assessment – Report Visualizations
# Script 05: Visualizations
###############################################

## Lets plot the indicator coverage by U5MR status

indicators_graph <- required_indicators %>%
  pivot_longer(
    cols = c(weighted_ANC4, weighted_SBA),
    names_to = "indicator",
    values_to = "coverage"
  ) %>%
  mutate(
    indicator = recode(
      indicator,
      weighted_ANC4 = "ANC4+",
      weighted_SBA = "SBA"
    )
  ) %>%
  ggplot(aes(x = indicator, y = coverage, fill = indicator)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = paste0(round(coverage, 1), "%")), 
            position = position_stack(vjust = 0.5), 
            family = "opensans_extrabold", 
            size = 4.5, colour = "white") +
  geom_vline(xintercept = 2.7, linetype = "dashed", color = "black", size = 1) +
  facet_wrap(~status_u5mr) +
  labs(
    title = "Weighted Coverage of Maternal Health Indicators.",
    subtitle = "Population-weighted coverage estimates of Antenatal Care Visits (ANC4+) and Skilled Birth Attendance (SBA), disaggregated \nby Under-Five Mortality Rate Status",
    x = "Maternal Health Indicator",
    y = "", 
    caption = "Note: Coverage estimates are weighted by projected births in 2022\nData Source: UNICEF Global Data Repository, UN World Population Prospects 2022"
  ) +
  theme_minimal() +
  scale_fill_manual(values = c("ANC4+" = "#4CAF50", "SBA" = "#F44336")) +
  scale_y_continuous(labels = scales::percent_format(scale = 1),
                     limits = c(0,100)) +
  theme(legend.position = "none",
        text = element_text(family = "opensans_extrabold"),
        plot.title = element_text(size = 16),
        plot.subtitle = element_text(size = 12, face = "italic", family = "opensans_semibold"),
        plot.caption = element_text(size = 10, hjust = 0, lineheight = 1.15, 
                                    family = "opensans_light", margin = margin(t = 10, b = 5)),
        plot.caption.position = "plot",
        axis.text.y = element_blank(),
        axis.line.x = element_line(color = "black", size = 0.5),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey", linetype = 3, size = 0.5),
        strip.text = element_text(size = 12),
        strip.background = element_rect(fill = "lightgrey", color = NA))

# Save the plot
ggsave(
  filename = here::here("03_figures", "indicators_coverage_by_u5mr_status.png"),
  plot = indicators_graph,
  width = 10, height = 6, dpi = 300, bg = "white"
)

## Table of Weighted Coverage
required_indicators_table <- required_indicators %>%
  gt() %>%
  tab_header(
    title = md("**Population-Weighted Coverage of Maternal Health Indicators by U5MR Status**"),
    subtitle = md("*ANC4+ and SBA coverage estimates weighted by projected births in 2022*")
  ) %>%
  cols_label(
    status_u5mr = html("Under-Five<br>Mortality Status"),
    weighted_ANC4 = html("ANC4+<br>Coverage (%)"),
    weighted_SBA = html("SBA<br>Coverage (%)"),
    n_countries = html("Number of<br>Countries")
  ) %>%
  fmt_percent(
    columns = c(weighted_ANC4, weighted_SBA),
    scale_values = FALSE
  ) %>%
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  tab_source_note(
    source_note = "Data Source: UNICEF Global Data Repository, UN World Population Prospects 2022"
  ) %>%
  opt_table_font(
    font = list(
      google_font(name = "Open Sans"),
      default_fonts()
    )
  )


# Save the table as an image
gtsave(
  required_indicators_table,
  filename = here::here("03_figures", "indicators_coverage_by_u5mr_status_table.png")
)
1

