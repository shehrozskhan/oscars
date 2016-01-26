library(rvest)
url<-"http://www.filmaffinity.com/en/awards-history.php?award_id=academy_awards&cat_id=best_picture"
#url<-"http://www.boxofficemojo.com/movies/?id=ateam.htm"
movie <- read_html(url, encoding = "UTF-8")
website<-html_nodes(movie,"ul li")
info<-html_text(website)
j=1;
header<-matrix(list(), nrow=88, ncol=3)
for (i in 93:180) {
  temp<-gsub('[\n\r]','',info[i]) #remove \n and \r
  temp<-as.list(strsplit(temp,"  ")[[1]]) #split string based on space 
  temp<-temp[nchar(temp)>0] #Remove zero length strings
  header[j,]<-cbind(temp[1],temp[2],gsub('nominations','',temp[7]))
  #print(paste(header[j,1]," ",header[j,2]," ",header[j,3]))
  j=j+1
}
print("Done")
write.csv(header, file = "picture_names.csv", row.names = FALSE)