library(XML)

dest = 'antipodes1'
# get every folder name in dest
mydir <- list.dirs(path = dest, full.names = TRUE)

new_Antipodes <- NULL
new_Antipodes$id <- NULL
new_Antipodes$doi <- NULL
new_Antipodes$title <- NULL
new_Antipodes$author <- NULL
new_Antipodes$journaltitle <- NULL
new_Antipodes$volume <- NULL
new_Antipodes$issue <- NULL
new_Antipodes$pubdate <- NULL
new_Antipodes$pagerange <- NULL
new_Antipodes$publisher <- NULL
new_Antipodes$type <- NULL
new_Antipodes$`reviewed-work` <- NULL
new_Antipodes$abstract <- NULL
i <- 1
require(stringr)
for(folder in mydir) {
  myfiles_txt <- NULL
  myfiles_xml <- NULL
  myfiles_txt <- list.files(path = folder, pattern = "txt",  full.names = TRUE)
  myfiles_xml <- list.files(path = folder, pattern = "xml",  full.names = TRUE)
  
  if(length(myfiles_txt)>0 && length(myfiles_xml)>0) {
    xml_data <- xmlToList(xmlParse(myfiles_xml))
    article_data <- xml_data$front$`article-meta`
    myfiles_txt <- sub('\\.txt$', '', myfiles_txt)
    
    # id
    new_Antipodes$id[i] <- basename(myfiles_txt)
    new_Antipodes$id[i] <- paste("data/Antipodes/", new_Antipodes$id[i], sep = "")
    
    new_Antipodes$doi[i] <- "doi"
    
    # title
    new_Antipodes$title[i] <- unlist(article_data$`title-group`$
                                       `article-title`)
    new_Antipodes$title[i] <- gsub('\\,','_',new_Antipodes$title[i])
    
    # author
    first_name <- article_data$`contrib-group`$contrib$
      `string-name`$`given-names`
    surname <- article_data$`contrib-group`$contrib$
      `string-name`$surname
    if(is.null(first_name) && is.null(surname)) {
      new_Antipodes$author[i] <- ""
    } else new_Antipodes$author[i] <- paste(first_name, surname)
    
    new_Antipodes$journaltitle[i] <- "Antipodes"
    new_Antipodes$volume[i] <- article_data$volume
    new_Antipodes$issue[i] <- article_data$issue
    
    # pubdate
    day <- article_data$`pub-date`$day
    if(str_length(day) == 1) day <- paste("0",day,sep="")
    month <- article_data$`pub-date`$month
    if(str_length(month) == 1) month <- paste("0",month,sep="")
    year <- article_data$`pub-date`$year
    new_Antipodes$pubdate[i] <- paste(year, "-",month,"-",day, sep = "")
    
    # pagerange
    fpage <- article_data$fpage
    lpage <- article_data$lpage
    new_Antipodes$pagerange[i] <- paste("p. ",fpage,"-",lpage,sep = "")
    
    new_Antipodes$publisher[i] <- "publisher"
    new_Antipodes$type[i] <- "type"
    new_Antipodes$`reviewed-work`[i] <- "reviewed-work"
    new_Antipodes$abstract[i] <- article_data$`self-uri`["href"][1]
    
    i <- i + 1
  }
}

dest = 'antipodes2'
# get every folder name in dest

mydir <- list.dirs(path = dest, full.names = TRUE)
for(folder in mydir) {
  myfiles_txt <- NULL
  myfiles_xml <- NULL
  myfiles_txt <- list.files(path = folder, pattern = "txt",  full.names = TRUE)
  myfiles_xml <- list.files(path = folder, pattern = "xml",  full.names = TRUE)
  
  if(length(myfiles_txt)>0 && length(myfiles_xml)>0) {
    xml_data <- xmlToList(xmlParse(myfiles_xml))
    article_data <- xml_data$front$`article-meta`
    myfiles_txt <- sub('\\.txt$', '', myfiles_txt)
    
    # id
    new_Antipodes$id[i] <- basename(myfiles_txt)
    new_Antipodes$id[i] <- paste("data/Antipodes/", new_Antipodes$id[i], sep = "")
    
    new_Antipodes$doi[i] <- "doi"
    
    # title
    new_Antipodes$title[i] <- unlist(article_data$
                                       `title-group`$`article-title`)
    new_Antipodes$title[i] <- gsub('\\,','_',new_Antipodes$title[i])
    
    #author
    if(is.null(article_data$`contrib-group`$contrib$
       `string-name`)) new_Antipodes$author[i] <- ""
    else new_Antipodes$author[i] <- article_data$`contrib-group`$contrib$
      `string-name`
    
    new_Antipodes$journaltitle[i] <- "Antipodes"
    new_Antipodes$volume[i] <- article_data$volume
    new_Antipodes$issue[i] <- article_data$issue
    
    # pubdate
    day <- article_data$`pub-date`$day
    if(str_length(day) == 1) day <- paste("0",day,sep="")
    month <- article_data$`pub-date`$month
    if(str_length(month) == 1) month <- paste("0",month,sep="")
    year <- article_data$`pub-date`$year
    new_Antipodes$pubdate[i] <- paste(year, "-",month,"-",day, sep = "")
    
    # pagerange
    fpage <- article_data$fpage
    lpage <- article_data$lpage
    new_Antipodes$pagerange[i] <- paste("p. ",fpage,"-",lpage,sep = "")
    
    new_Antipodes$publisher[i] <- "publisher"
    new_Antipodes$type[i] <- "type"
    new_Antipodes$`reviewed-work`[i] <- "reviewed-work"
    new_Antipodes$abstract[i] <- xml_data$front$`article-meta`$`self-uri`
    
    i <- i + 1
  }
}

# test
i <- 23
c(new_Antipodes$id[i], new_Antipodes$doi[i], new_Antipodes$title[i], new_Antipodes$author[i],
  new_Antipodes$journaltitle[i], new_Antipodes$volume[i], new_Antipodes$issue[i],
  new_Antipodes$pubdate[i], new_Antipodes$pagerange[i], new_Antipodes$publisher[i], 
  new_Antipodes$type[i], new_Antipodes$`reviewed-work`[i], new_Antipodes$abstract[i])


write.table(new_Antipodes, file='New_Antipodes.tsv', sep='\t', na = "", eol = "\r",
            row.names = FALSE, quote = FALSE)
