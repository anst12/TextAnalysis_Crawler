#bill-summary > div.generated-html-container

bill_sample_url <- "https://www.congress.gov/bill/116th-congress/house-bill/1642/text?format=txt&q=%7B%22search%22%3A%5B%22trade%22%5D%7D&r=2&s=7"

bill_html <- read_html(bill_sample_url)
bill_title <- bill_html %>%
  html_node("#billTextContainer") %>%
  html_text()
bill_title
bill_date <- bill_html %>%
  html_node("#bill-summary > h3 > span") %>%
  html_text()
bill_date



bill_df <- data.frame(bill_date, bill_title)

View(bill_title)

#billTextContainer > mark:nth-child(1)
#billTextContainer > mark:nth-child(2)