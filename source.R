library(tidyverse)
library(readxl)
library(stringr)
library(sets)
library(dplyr)

# a問題
semester_df1 <- read.csv(
    "raw_data/semester_dummy/semester_data_1.csv",
    fileEncoding = "UTF-8",
    stringsAsFactors=FALSE,
    skip = 1
  ) |>
  mutate(
    unitid=as.numeric(unitid),
    semester=as.numeric(semester),
    quarter=as.numeric(quarter),
    year=as.numeric(year)
  )

semester_df2 <- read.csv(
    "raw_data/semester_dummy/semester_data_2.csv",
    fileEncoding = "UTF-8",
    stringsAsFactors=FALSE,
    col.names = c("unitid","instnm","semester","quarter","year","Y")
  )

semester_dummy_tidy <-  bind_rows(
    semester_df1, semester_df2
  ) |>
  select(-"Y")

# b問題
gradrate_tidy <- NULL

file_name_list <-
  list.files(path = "raw_data/outcome" ,
             pattern = "\\.xlsx$",
             full.names = TRUE)

for (file_name in file_name_list) {
  gradrate_tidy <- readxl::read_excel(
    file_name
    ) |>
    mutate(
      women_gradrate_4yr = 0.01 * women_gradrate_4yr
    ) |>
    bind_rows(gradrate_tidy)
}

# c問題
covariates_tidy <- readxl::read_excel(
  "raw_data/covariates/covariates.xlsx"
) |>
  rename(
    unitid = university_id
  ) |>
  mutate(
    unitid = str_replace(unitid,
                         pattern="aaaa",
                         replacement=""
                         )
    ) |>
  pivot_wider(names_from = "category",
              values_from = "value"
              )

# d問題
gradrate_ready <- mutate(
    gradrate_tidy,
    men_gradrate_4yr = as.numeric(m_4yrgrads) / m_cohortsize,
    tot_gradrate_4yr = tot4yrgrads / as.numeric(totcohortsize)
  ) |>
  mutate(
    gradrate_tidy,
    men_gradrate_4yr = round(men_gradrate_4yr, 4),
    tot_gradrate_4yr = round(tot_gradrate_4yr, 4)
  ) |>
  drop_na(tot_gradrate_4yr)
  
# e問題
years_set <- unique(
  unique(semester_dummy_tidy$year),
  unique(gradrate_ready$year)
)

unitid_set <- unique(semester_dummy_tidy$unitid)

covariates_ready <- mutate(
    covariates_tidy,
    year = as.numeric(year)
  ) |>
  dplyr::filter(
    year %in% years_set
  ) |>
  mutate(
    unitid = as.numeric(unitid)
  ) |>
  dplyr::filter(
      unitid %in% unitid_set
  )

# f問題
master <- left_join(
    semester_dummy_tidy,
    covariates_ready,
    by = c("year"="year", "unitid" = "unitid")
  ) |>
  left_join(
    gradrate_ready,
    by = c("year"="year", "unitid" = "unitid")
  ) |>
  mutate(
    white_rate = round(as.numeric(white_cohortsize) / as.numeric(totcohortsize), 4)
  )



       
