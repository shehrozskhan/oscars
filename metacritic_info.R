library(rvest)
url<-"http://www.rottentomatoes.com/m/birdman_2014"
movie <- read_html(url)
guess_encoding(movie)
repair_encoding(movie)
#Rating
website<-html_nodes(movie,"tr td")
rating<-html_text(website)
rating<-as.numeric(rating)
