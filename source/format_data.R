library(tidyverse)

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

semester_df1

read.csv(
  "raw_data/semester_dummy/semester_data_2.csv",
  fileEncoding = "UTF-8",
  stringsAsFactors=FALSE,
  col.names = c("unitid","instnm","semester","quarter","year","Y")
) -> semester_df2

bind_rows(semester_df1, semester_df2) %>%
  select(-"Y") -> semester_df
semester_df
