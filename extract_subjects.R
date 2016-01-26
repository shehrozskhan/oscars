library(rvest)
#Best Actor
#url<-"http://www.filmaffinity.com/en/awards-history.php?award_id=academy_awards&cat_id=best_leading_actor"
#Best Actress
#url<-"http://www.filmaffinity.com/en/awards-history.php?award_id=academy_awards&cat_id=best_leading_actress"
#Best Director
url<-"http://www.filmaffinity.com/en/awards-history.php?award_id=academy_awards&cat_id=best_director"
movie <- read_html(url, encoding = "UTF-8")
website<-html_nodes(movie,"ul li")
info<-html_text(website)
j=1;
header<-matrix(list(), nrow=88, ncol=4)
for (i in 93:180) {
  temp<-gsub('[\n\r]','',info[i]) #remove \n and \r
  temp<-as.list(strsplit(temp,"  ")[[1]]) #split string based on space 
  temp<-temp[nchar(temp)>0] #Remove zero length strings
  header[j,]<-cbind(temp[1],temp[2],temp[3],gsub('nominations','',temp[8]))
  #print(paste(header[j,1]," ",header[j,2]," ",header[j,3]))
  j=j+1
}
print("Done")
#Best Actor
#write.csv(header, file = "actors_names.csv", row.names = FALSE)
#Best Actress
#write.csv(header, file = "actresses_names.csv", row.names = FALSE)
#Best Director
write.csv(header, file = "directors_names.csv", row.names = FALSE)