
basic_url <- "https://www.armscontrol.org/factsheets/dprkchron"
html_factsheet <- read_html(basic_url)
date <- html_factsheet %>%
  html_nodes("b") %>%
  html_text()
text_factsheet <- html_factsheet %>%
  html_nodes("p") %>%
  html_text()
View(text_factsheet)

#node-2597 > div > div > div.field.field-name-field-body.field-type-text-long.field-label-hidden > div > div > p:nth-child(17) > b

#node-2597 > div > div > div.field.field-name-field-body.field-type-text-long.field-label-hidden > div > div > p:nth-child(18) > b
  
#node-2597 > div > div > div.field.field-name-field-body.field-type-text-long.field-label-hidden > div > div > p:nth-child(15) > b




#node-2597 > div > div > div.field.field-name-field-body.field-type-text-long.field-label-hidden > div > div > p:nth-child(15) > b


#node-2597 > div > div > div.field.field-name-field-body.field-type-text-long.field-label-hidden > div > div > p:nth-child(17) > b