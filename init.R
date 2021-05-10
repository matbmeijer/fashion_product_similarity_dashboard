# Knitr parameters

# File path information
library("here", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Web Scraping
library("RSelenium", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library("binman", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library("rvest", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Data wrangling, cleaning, transforming
library("tidyr", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library("stringr", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library("dplyr", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library("glue", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Image weights
library("keras", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Distance Matrix
library("FNN", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Dahboarding
library("DT", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library("rmarkdown", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
library("flexdashboard", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Read yaml
library("yaml", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

# Logging
library("loggit", warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)

scripts <<- yaml::read_yaml(file.path(home_path, "scripts.yaml"))

Sys.setenv(RSTUDIO_PANDOC=scripts$pandoc_location)


if(!file.exists(scripts$folders$raw)){
  dir.create(scripts$folders$raw)
}

if(!file.exists(scripts$folders$images)){
  dir.create(scripts$folders$images)
}

if(!file.exists(scripts$folders$silver)){
  dir.create(scripts$folders$silver)
}

if(!file.exists(scripts$folders$gold)){
  dir.create(scripts$folders$gold)
}

if(!file.exists(scripts$folders$logs)){
  dir.create(scripts$folders$logs)
}

# Load custom & helper functions
lapply(file.path(home_path, scripts$r$step0_utils), source, verbose = TRUE, encoding = "utf-8")
lapply(file.path(home_path, scripts$r$step1_read_inputs), source, verbose = TRUE, encoding = "utf-8")
lapply(file.path(home_path, scripts$r$step2_process_inputs), source, verbose = TRUE, encoding = "utf-8")
lapply(file.path(home_path, scripts$r$step3_plot_dashboard), source, verbose = TRUE, encoding = "utf-8")
