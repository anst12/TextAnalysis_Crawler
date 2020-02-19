daum_news <- "https://news.v.daum.net/v/20200219173753190"
news_html <- read_html(daum_news)

news_title <- news_html %>%
  html_node("#cSub > div > h3") %>%
  html_text()
news_title
news_body <- news_html %>%
  html_nodes("#harmonyContainer > section > p") %>%
  html_text

# 다음에서 코로나로 검색한 뉴스 결과물을 불러오자
corona_news_search <- "https://search.daum.net/search?w=news&q=%EC%BD%94%EB%A1%9C%EB%82%98&DA=PGD&spacing=0&p="

urls <- c()
news_links <- NULL
for (i in 1:2) {
  urls[i] <- paste0(corona_news_search, i)
  search_html <- read_html(urls[i])
  news_link <- search_html %>%
    html_nodes("div.wrap_tit.mg_tit") %>%
    html_attr("href")
  news_links <- rbind(news_links, news_link)
  rm(news_link)
}
