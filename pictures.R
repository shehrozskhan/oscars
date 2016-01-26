library(rvest)

#Read movie info file
movie_info<-read.csv("movie_names.csv",header=TRUE)
total_movies<-length(movie_info[,1])
full.info<-NULL
for (i in 1:total_movies) {
  print(paste("Film=",i))
  #Name of movie
  name<-as.vector(movie_info[i,2])
  
  #Year of movie
  year<-as.numeric(movie_info[i,1])-1
  
  #Number of nominations
  nominations<-as.vector(movie_info[i,3])
  
  #Read url
  url<-as.vector(movie_info[i,4])
  movie <- read_html(url, encoding = "UTF-8")
  
  #Rating
  website<-html_nodes(movie,"strong span")
  rating<-html_text(website)
  rating<-as.numeric(rating)
  
  #Duration
  website<-html_nodes(movie,"div time")
  duration<-html_text(website)
  duration<-gsub('\n','',duration) #remove \n 
  duration<-as.list(strsplit(duration,"  ")[[1]]) #split string based on space 
  duration<-duration[nchar(duration)>0] #Remove zero length strings
  duration<-gsub(' min','',duration) #Removes 'min'
  duration<-as.numeric(duration)
  
  #Genre
  website<-html_nodes(movie,"a span")
  val<-html_text(website)
  val<-val[nchar(val)>0]#Remove zero length strings
  genre<-cbind(val[1],val[2]) #Top 2 genre
  
  #Release Date
  website<-html_nodes(movie,"span a")
  release<-html_text(website)
  release<-release[4] #Get the release data
  release<-gsub('\n',' ',release) #replace \n with space
  release<-as.list(strsplit(release," ")[[1]]) #split string based on space 
  release<-release[nchar(release)>0] #Remove zero length strings
  release<-release[1:2] #Get date and month
  release<-unlist(release) #Flatten release
  release<-release[2] #Capture month
  
  #MetaCritic Rating
  website<-html_nodes(movie,"div a")
  metacritic<-html_text(website)
  metacritic<-metacritic[grep("/100",metacritic)] #find pattern
  metacritic<-gsub('\\b/100\n\\b','',metacritic)
  metacritic<-as.numeric(metacritic)
  if(length(metacritic)==0)
    metacritic<-""
  
  #Synopsis
  website<-html_nodes(movie,"td p")
  synopsis<-html_text(website)
  synopsis<-synopsis[nchar(synopsis)>0] #Remove zero length strings
  synopsis<-gsub('[\n,\']','',synopsis) #remove \n,'
  #parsed_synopsis<-as.list(strsplit(synopsis," ")[[1]]) #split string based on space 
  #stopWords <- stopwords("en")
  #parsed_synopsis<-unlist(parsed_synopsis)[!(unlist(parsed_synopsis) %in% stopWords)] #remove stopwords
  #parsed_synopsis<-paste(parsed_synopsis, collapse = ' ') #merge diferent substrings
  
  imdb<-cbind(name,year,nominations,rating,duration,genre,release,metacritic,synopsis)
  full.info<-rbind(full.info,imdb)
}
write.csv(full.info,file="pictures.csv",row.names = FALSE)