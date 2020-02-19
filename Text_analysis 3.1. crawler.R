#####
# 3강 크롤러 작성 예제 (1)
# 2020. 2. 19.
# 안성태
#####

# 필요한 패키지들을 부착
library('stringr')  # 문자열 처리를 위한 패키지
library('dplyr')    # 파이프 %>% 사용
library('urltools') # URLs, HTTP 도구
library('rvest')    #

url_basic <- 'https://history.state.gov/departmenthistory/visits/'
us_visit <- NULL
for (i in 1990:2016) {
  page <- paste0(url_basic, i)
  url <- read_html(page, encoding = "UTF-8")
  tbl <- url %>% html_table(header = TRUE, dec = ",", trim = TRUE) %>% as.data.frame()
  us_visit <- rbind(us_visit, tbl)
  rm(tbl)
}


# Description 정리
us_visit$Description <- us_visit$Description %>%
  str_remove_all("\t\n") %>% 
  str_replace_all("[[:space:]]{2,}", " ") %>% 
  str_trim()

# 날짜 정리
library(lubridate)
# 방문 첫째날(연/월/일)과 방문 마지막날(연/월/일)을 구분해서 방문 기간을 구해야 함.
# 방문 연도
us_visit$year <- us_visit$Date %>%
  str_extract_all("[:digit:]{3,4}") %>% as.numeric()

# 월
us_visit$first_month <- us_visit$Date %>% 
  str_extract("[:upper:][:alpha:]+") %>% as.character()

us_visit$last_month <- us_visit$Date %>%
  str_extract("[:punct:][:upper:][:alpha:]+") %>% str_remove("[:punct:]") %>% as.character()

us_visit$last_month <- ifelse(is.na(us_visit$last_month), us_visit$first_month, us_visit$last_month)

# 일
us_visit$first_date <- us_visit$Date %>%
  str_extract("[:alnum:]{1,2}[:punct:]") %>% str_remove("[:punct:]") %>% as.numeric()
us_visit$last_date <- us_visit$Date %>%
  str_extract("[:alnum:]{1,2},") %>% str_remove("[:punct:]") %>% as.numeric()

# first and last day %yyyy%mm%dd format
us_visit$first_day <- paste(us_visit$year, us_visit$first_month, us_visit$first_date, sep = "-") 
us_visit$first_day <- strptime(us_visit$first_day, format = "%Y-%b-%d")
us_visit$first_day <- as.Date(us_visit$first_day)
us_visit$last_day <- paste(us_visit$year, us_visit$last_month, us_visit$last_date, sep = "-")
us_visit$last_day <- strptime(us_visit$last_day, format = "%Y-%b-%d")
us_visit$last_day <- as.Date(us_visit$last_day)

# 월(numeric)
us_visit$month <- month(us_visit$first_day)

# duration
us_visit$duration <- us_visit$last_day - us_visit$first_day
us_visit$duration <- us_visit$duration + 1 %>% as.numeric()
summary(us_visit$duration)
# duration 이 negative 인 경우?
dplyr::filter(us_visit, duration < 0)
#1027행 

# back up data set
us_visit_level1 <- us_visit
write.csv(us_visit_level1, "us_visit_level1.csv", row.names = T, fileEncoding = "UTF-8")