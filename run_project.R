###############################################
# UNICEF Education Assessment – Execution Script
# Script 07: Execution Script
###############################################
# ----------------------------
# This script runs the entire UNICEF technical assessment pipeline end-to-end

# Step 1: Data Cleaning and Merging
source(file.path(code_dir, "02_data_loading_and_cleaning.R"))

# Step 2: Calculate Weighted Coverage
source(file.path(code_dir, "04_calculate_weighted_coverage.R"))

# Step 3: Generate Outputs (tables/plots)
source(file.path(code_dir, "05_visualisations.R"))

# Step 4: Export Report
rmarkdown::render(
  input = file.path(code_dir, "06_export_report.Rmd"),
  output_format = "word_document",
  output_file = "unicef_assessment_report.docx",
  output_dir = report_dir,
  clean = TRUE
)

cat("Workflow completed. Report saved to:", file.path(report_dir, "unicef_assessment_report.docx"), "\n")
