library(plyr)
library(tm)
library(NLP)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(qdapDictionaries)
library(qdapRegex)
library(qdapTools)
library(qdap)
library(stringr)

stats<-{}

#Read actor/actress/director csv file

#Best Picture
#movie.info<-read.csv("pictures.csv",header=TRUE)
#png<-"pictures.png"
#outfile<-"pictures_stats.csv"

#Best Actor
#movie.info<-read.csv("actors.csv",header=TRUE)
#png<-"actors.png"
#outfile<-"actors_stats.csv"

#Best Actress
#movie.info<-read.csv("actresses.csv",header=TRUE)
#png<-"actresses.png"
#outfile<-"actresses_stats.csv"

#Best Director
movie.info<-read.csv("directors.csv",header=TRUE)
png<-"directors.png"
outfile<-"directors_stats.csv"

#nominations
mean_nomination<-mean(as.numeric(as.character(na.omit(movie.info$nominations))), na.rm=TRUE) 
std_nomination<-sd(as.numeric(as.character(na.omit(movie.info$nominations))), na.rm=TRUE) 
max_nomination<-max(as.numeric(as.character(na.omit(movie.info$nominations))), na.rm=TRUE)
min_nomination<-min(as.numeric(as.character(na.omit(movie.info$nominations))), na.rm=TRUE)
stats<-rbind(stats,rbind(mean_nomination,std_nomination,max_nomination,min_nomination))

#rating
mean_rating<-mean(as.numeric(as.character(na.omit(movie.info$rating))), na.rm=TRUE) 
std_rating<-sd(as.numeric(as.character(na.omit(movie.info$rating))), na.rm=TRUE) 
max_rating<-max(as.numeric(as.character(na.omit(movie.info$rating))), na.rm=TRUE)
min_rating<-min(as.numeric(as.character(na.omit(movie.info$rating))), na.rm=TRUE)
stats<-rbind(stats,rbind(mean_rating,std_rating,max_rating,min_rating))

#duration
mean_duration<-mean(as.numeric(as.character(na.omit(movie.info$duration))), na.rm=TRUE) 
std_duration<-sd(as.numeric(as.character(na.omit(movie.info$duration))), na.rm=TRUE) 
max_duration<-max(as.numeric(as.character(na.omit(movie.info$duration))), na.rm=TRUE)
min_duration<-min(as.numeric(as.character(na.omit(movie.info$duration))), na.rm=TRUE)
stats<-rbind(stats,rbind(mean_duration,std_duration,max_duration,min_duration))

#metacritic
mean_metacritic<-mean(as.numeric(as.character(na.omit(movie.info$metacritic))), na.rm=TRUE) 
std_metacritic<-sd(as.numeric(as.character(na.omit(movie.info$metacritic))), na.rm=TRUE) 
max_metacritic<-max(as.numeric(as.character(na.omit(movie.info$metacritic))), na.rm=TRUE)
min_metacritic<-min(as.numeric(as.character(na.omit(movie.info$metacritic))), na.rm=TRUE)
stats<-rbind(stats,rbind(mean_metacritic,std_metacritic,max_metacritic,min_metacritic))

#release
rel<-count(movie.info$release)
frequency<-max(rel$freq)
row<-which(rel$freq==max(rel$freq))
month<-as.character(rel$x[as.integer(rel$x)[row]])
stats<-rbind(stats,rbind(month,frequency))

#combine genre1 and genre2, find the max occuring genre
g1<-movie.info$genre1
g2<-movie.info$genre2
g<-factor(c(as.character(g1),as.character(g2)))
g<-g[nchar(as.character(g))>0] #remove zero length strings
#WordCloud
corpus<- Corpus(VectorSource(g))
corpus <- tm_map(corpus, PlainTextDocument)
# save the image in png format
png(png, width=12, height=8, units="in", res=300)
wordcloud(corpus, max.words = length(levels(g)), random.order = FALSE,colors=brewer.pal(8, "Dark2"))
dev.off()

rel<-count(g)
frequency<-max(rel$freq)
row<-which(rel$freq==max(rel$freq))
genre1<-as.character(rel$x[row])
stats<-rbind(stats,rbind(genre1,frequency))
#find next genre, replace max by a negative number
rel$freq[row]= -999
frequency<-max(rel$freq)
row<-which(rel$freq==max(rel$freq))
genre2<-as.character(rel$x[row])
stats<-rbind(stats,rbind(genre2,frequency))

#Sentiment Analysis 
# http://andybromberg.com/sentiment-analysis/
#http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010
stopWords <- stopwords("en")
afinn_list <- read.delim(file='AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE)
names(afinn_list) <- c('word', 'score')
total_record<-length(movie.info[,1])
full.score<-NULL
for (i in 1:total_record) {
  #Read synopsis
  parsed_synopsis<-as.list(strsplit(as.character(movie.info$synopsis[i])," ")[[1]]) #split string based on space 
  parsed_synopsis<-tolower(parsed_synopsis) #convert to lowercase
  parsed_synopsis<-unlist(parsed_synopsis)[!(unlist(parsed_synopsis) %in% stopWords)] #remove stopwords
  parsed_synopsis<- removePunctuation(parsed_synopsis) #remove punctuation
  #load up word polarity list and format it
  score<-match(parsed_synopsis,afinn_list$word)
  score<-afinn_list[score,2]
  full.score<-rbind(full.score,sum(score, NA, na.rm = TRUE))
}
mean_sentiment<- mean(full.score)
std_sentiment<- sd(full.score)
max_sentiment<- max(full.score)
min_sentiment<-min(full.score)
stats<-rbind(stats,mean_sentiment,std_sentiment,max_sentiment,min_sentiment)

#Write output
write.csv(stats, file = outfile, row.names = TRUE)
print(paste("output written to",outfile))
print(paste("word cloud stored in",png))
