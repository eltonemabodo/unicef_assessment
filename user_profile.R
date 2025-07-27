###############################################
# UNICEF Education Assessment – User Profile
# Script 01: Environment Setup & Global Options
###############################################

# Load required packages
required_packages <- c(
  "tidyverse", "readxl", "janitor", "lubridate",
  "here", "rmarkdown", "gt", "glue", "haven",
  "writexl", "scales", "survey", "srvyr", "labelled",
  "showtext", "sysfonts", "showtext", "webshot2"
)

# Install any missing packages
installed <- installed.packages()[, "Package"]
for (pkg in required_packages) {
  if (!(pkg %in% installed)) install.packages(pkg)
}
# Load all
lapply(required_packages, library, character.only = TRUE)

# Set global options
options(scipen = 999)  # Avoid scientific notation
options(dplyr.summarise.inform = FALSE)  # Clean summarise output
showtext_auto() # Automatically use showtext for text rendering

# Set relative paths using `here`
raw_data_dir      <- here::here("01_data/raw_data")
processed_data_dir    <- here::here("01_data/processed_data")
code_dir       <- here::here("02_code")
figures_dir        <- here::here("03_figures")
report_dir         <- here::here("04_report")

# Add multiple font weights from Google Fonts
font_add_google("Open Sans", "opensans_regular", regular.wt = 400)   # Normal
font_add_google("Open Sans", "opensans_light", regular.wt = 300)     # Light
font_add_google("Open Sans", "opensans_semibold", regular.wt = 600)  # Semi-Bold
font_add_google("Open Sans", "opensans_bold", regular.wt = 700)      # Bold
font_add_google("Open Sans", "opensans_extrabold", regular.wt = 800) # Extra-Bold
showtext_opts(dpi = 300)

# Timestamp for logging
run_time <- Sys.time()
message("Environment setup complete: ", run_time)
