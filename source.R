library(tidyverse, readxl)

# a問題
read.csv(
  "raw_data/semester_dummy/semester_data_1.csv",
  fileEncoding = "UTF-8",
  stringsAsFactors=FALSE,
  skip = 1
) %>%
  mutate(
    unitid=as.integer(unitid),
    semester=as.integer(semester),
    quarter=as.integer(quarter),
    year=as.integer(year),
  ) -> semester_df1

read.csv(
  "raw_data/semester_dummy/semester_data_2.csv",
  fileEncoding = "UTF-8",
  stringsAsFactors=FALSE,
  col.names = c("unitid","instnm","semester","quarter","year","Y")
) -> semester_df2

bind_rows(semester_df1, semester_df2) %>%
  select(-"Y") -> semester_df

# b問題
gradrate_df <- NULL

file_name_list <-
  list.files(path = "raw_data/outcome" ,
             pattern = "\\.xlsx$",
             full.names = TRUE)

for (file_name in file_name_list) {
  readxl::read_excel(
    file_name
  ) %>%
    mutate(
      women_gradrate_4yr = 0.01 * women_gradrate_4yr
    ) %>%
    bind_rows(gradrate_df) -> gradrate_df
}

# c問題
gradrate_df <- NULL

file_name_list <-
  list.files(path = "raw_data/outcome" ,
             pattern = "\\.xlsx$",
             full.names = TRUE)

for (file_name in file_name_list) {
  readxl::read_excel(
    file_name
  ) %>%
    mutate(
      women_gradrate_4yr = 0.01 * women_gradrate_4yr
    ) %>%
    bind_rows(gradrate_df) -> gradrate_df
}