library(readxl)
library(zoo)

###################################
### Australian Literary Studies (ALS)
###################################
### still need to work:
### page range need extract from pdf files
###################################
library(readxl)
library(zoo)
metadata_file_ALS <- file.path("ALS.csv")

dat1_ALS <- readLines(metadata_file_ALS)
Sys.setlocale('LC_ALL','C')
dat2_ALS <- grep("Node Name,RTC_date", dat1_ALS, invert=TRUE, value=TRUE)
dat3_ALS <- read.csv(textConnection(paste0(dat2_ALS, collapse="\n")),
                  header=FALSE, stringsAsFactors=FALSE)
# str(dat3_ALS)
headers <- strsplit(dat1_ALS[1], ",")[[1]]
# length(headers)
dat4_ALS <- dat3_ALS[,1:length(headers)]
colnames(dat4_ALS) <- headers
# str(dat4_ALS)

raw_ALS <- dat4_ALS
ALS_length = length(raw_ALS$id) - 1

new_ALS <- NULL

# id
new_ALS$id <- raw_ALS$pdf_filename[2:length(raw_ALS$pdf_filename)]

new_ALS$doi <- c(rep("doi",ALS_length))
new_ALS$title <- raw_ALS$title[2:length(raw_ALS$title)]
new_ALS$author <- raw_ALS$authors[2:length(raw_ALS$authors)]
new_ALS$journaltitle <- c(rep("Australian Literary Studies",ALS_length))

# volume and issue
i <- 1
new_ALS$volume <- NULL
new_ALS$issue <- NULL
for(each in raw_ALS$citation_issue[2:length(raw_ALS$citation_issue)]) {
  new_ALS$volume[i] <- unlist(strsplit(each, "[.]"))[1]
  new_ALS$issue[i] <- unlist(strsplit(each, "[.]"))[2]
  i <- i + 1;
}

new_ALS$pubdate <- raw_ALS$published_at[2:length(raw_ALS$published_at)]
new_ALS$pubdate <- gsub("/","-",new_ALS$pubdate)

new_ALS$pagerange <- c(rep("pagerange",ALS_length))
new_ALS$publisher <- c(rep("publisher",ALS_length))
new_ALS$type <- raw_ALS$type[2:length(raw_ALS$type)]
new_ALS$`reviewed-work` <- c(rep("reviewed-work",ALS_length))

new_ALS$abstract <- raw_ALS$url[2:length(raw_ALS$url)]

# test
i <- 129
c(new_ALS$doi[i],new_ALS$title[i],new_ALS$author[i],
  new_ALS$journaltitle[i],new_ALS$volume[i],
  new_ALS$issue[i], new_ALS$pubdate[i], new_ALS$abstract[i])

# edit ids
for(i in 1:length(new_ALS$id)) {
  if(new_ALS$id[i] == "") new_ALS$id[i] = "zzz"
  new_ALS$id[i] <- unlist(strsplit(new_ALS$id[i],".pdf"))[1]
  new_ALS$id[i] <- paste("data/ALS/",new_ALS$id[i], sep="")
}

new_ALS <- data.frame(id=new_ALS$id, doi=new_ALS$doi, title=new_ALS$title, 
                      author=new_ALS$author, journaltitle=new_ALS$journaltitle, 
                      volume=new_ALS$volume, issue=new_ALS$issue, pubdate=new_ALS$pubdate, 
                      pagerange=new_ALS$pagerange, publisher=new_ALS$publisher, 
                      type=new_ALS$type, `reviewed-work`=new_ALS$`reviewed-work`, 
                      abstract=new_ALS$abstract)
new_ALS <- new_ALS[order(new_ALS[, 'id']), ]

# output
write.table(new_ALS, file='New_ALS.tsv', sep='\t', na = "", eol = "\r",
            row.names = FALSE, quote = FALSE)



###################################
### JASAL
###################################
### still need to work:
### id
### title
### author
### journal title
### pagerange
###################################
library(readxl)
library(zoo)
metadata_file_JASAL <- file.path("JASAL_DATA.xlsx")
raw_JASAL <- read_excel(metadata_file_JASAL)
JASAL_length <- length(raw_JASAL$id)

new_JASAL <- NULL
new_JASAL$id <- NULL
new_JASAL$doi <- NULL
new_JASAL$title <- NULL
new_JASAL$author <- NULL
new_JASAL$journaltitle <- NULL
new_JASAL$volume <- NULL
new_JASAL$issue <- NULL
new_JASAL$pubdate <- NULL
new_JASAL$pagerange <- NULL
new_JASAL$publisher <- NULL
new_JASAL$type <- NULL
new_JASAL$`reviewed-work` <- NULL
new_JASAL$abstract <- NULL

# id
for(i in 1:JASAL_length) {
  new_JASAL$id[i] <- paste(raw_JASAL$id[i],"_",raw_JASAL$Column1[i],sep="")
}

new_JASAL$doi <- c(rep("doi",JASAL_length))
new_JASAL$title <- raw_JASAL$Title
new_JASAL$author <- raw_JASAL$`Author/s`
new_JASAL$journaltitle <- c(rep("JASAL",JASAL_length))
new_JASAL$volume <- raw_JASAL$Volume
new_JASAL$issue <- raw_JASAL$Isssue

# pubdate
for(i in 1:JASAL_length) {
  new_JASAL$pubdate[i] <- paste(raw_JASAL$`Date First Published`[i],"-01-01",sep="")
}

new_JASAL$pagerange <- raw_JASAL$`Page range`
new_JASAL$publisher <- c(rep("publisher",JASAL_length))
new_JASAL$type <- c(rep("type",JASAL_length))
new_JASAL$`reviewed-work` <- c(rep("reviewed_work",JASAL_length))

# abstract: urls
library(XML)
my.zip.file <- sub("xlsx", "zip", metadata_file_JASAL)
file.copy(from = metadata_file_JASAL, to = my.zip.file)
unzip(my.zip.file)
xml <- xmlParse("xl/worksheets/_rels/sheet1.xml.rels")
hyperlinks <- xpathApply(xml, "//x:hyperlink/@display", namespaces="x")
new_JASAL$abstract <- raw_JASAL$Url

new_JASAL <- data.frame(id=new_JASAL$id, doi=new_JASAL$doi, 
                            title=new_JASAL$title, author=new_JASAL$author, 
                            journaltitle=new_JASAL$journaltitle, volume=new_JASAL$volume, 
                            issue=new_JASAL$issue, pubdate=new_JASAL$pubdate, 
                            pagerange=new_JASAL$pagerange, publisher=new_JASAL$publisher, 
                            type=new_JASAL$type, `reviewed-work`=new_JASAL$`reviewed-work`, 
                            abstract=new_JASAL$abstract)

# test
i <- 100
c(new_JASAL$id[i], new_JASAL$doi[i], new_JASAL$title[i], new_JASAL$author[i], 
  new_JASAL$journaltitle[i], new_JASAL$volume[i], new_JASAL$issue[i], 
  new_JASAL$pubdate[i], new_JASAL$pagerange[i], new_JASAL$publisher[i], 
  new_JASAL$type[i], new_JASAL$`reviewed-work`[i], new_JASAL$abstract[i])

# output
write.table(new_JASAL, file='new_JASAL.tsv', sep='\t', na = "", eol = "\r",
            row.names = FALSE, quote = FALSE)



###################################
### SRB
###################################
### SRB encode in UNICODE, need to read in UNICODE
### still need to work:
### id
### pagerange
###################################
library(readxl)
library(zoo)
metadata_file_SRB <- file.path("SRB_without_content.xlsx")
raw_SRB <- read_excel(metadata_file_SRB)
SRB_length <- length(raw_SRB$`Page Title`)

new_SRB <- NULL
new_SRB$id <- NULL
new_SRB$doi <- NULL
new_SRB$title <- NULL
new_SRB$author <- NULL
new_SRB$journaltitle <- NULL
new_SRB$volume <- NULL
new_SRB$issue <- NULL
new_SRB$pubdate <- NULL
new_SRB$pagerange <- NULL
new_SRB$publisher <- NULL
new_SRB$type <- NULL
new_SRB$`reviewed-work` <- NULL
new_SRB$abstract <- NULL

# id
new_SRB$id <- c(1:SRB_length)
for(i in 1:SRB_length) {
  new_SRB$id[i] <- paste("data/SRB/",new_SRB$id[i], sep="")
}

new_SRB$doi <- c(rep("doi",SRB_length))

# title
new_SRB$title <- raw_SRB$`Review title`
for(i in 1:SRB_length) {
  try(
    temp_title <- as.Date(as.numeric(new_SRB$title[i]), origin = "1899-12-30"),
    silent = TRUE
  )
  if(!is.na(temp_title)) {
    temp_title <- paste("The Week In Review:", temp_title)
    new_SRB$title[i] <- temp_title
  }
}

# author name
new_SRB$author <- raw_SRB$`Author name`
author_name2 <- raw_SRB$`Author name 2`
author_name3 <- raw_SRB$`Author name 3`
for(i in 1:SRB_length) {
  if(!is.na(author_name2[i])) {
    if(!is.na(author_name3[i])) new_SRB$author[i] = paste(new_SRB$author[i],", ",author_name2[i],sep="")
    else new_SRB$author[i] = paste(new_SRB$author[i],"and",author_name2[i])
  }
  if(!is.na(author_name3[i])) {
    new_SRB$author[i] = paste(new_SRB$author[i],"and",author_name3[i])
  }
}

# journal title
new_SRB$journaltitle <- c(rep("SRB",SRB_length))

# volume
for(i in 1: SRB_length) {
  temp_SRB_pubdate <- raw_SRB$`Date of review`[i]
  new_SRB$pubdate[i] <- toString(as.Date(temp_SRB_pubdate))
  
  temp_volume <- new_SRB$pubdate[i]
  year <- as.integer(substr(temp_volume, 1, 4))
  month <- as.integer(substr(temp_volume, 6, 7))
  new_SRB$volume[i] <- (year-2013) * 12 + month
}


new_SRB$issue <- c(rep("",SRB_length))

new_SRB$pubdate <- as.Date(new_SRB$pubdate)

# page range
new_SRB$pagerange <- c(rep("pagerange",SRB_length))
new_SRB$publisher <- c(rep("publisher",SRB_length))
new_SRB$type <- c(rep("type",SRB_length))
new_SRB$`reviewed-work` <- c(rep("reviewed_work",SRB_length))

# urls
new_SRB$abstract <- raw_SRB$`Review URL`

# test
i <- 1
c(new_SRB$title[i],new_SRB$author[i],
  new_SRB$journaltitle[i],new_SRB$volume[i],
  new_SRB$issue[i], new_SRB$pubdate[i],new_SRB$urls[i])

new_SRB <- data.frame(id=new_SRB$id, doi=new_SRB$doi, title=new_SRB$title, 
                  author=new_SRB$author, journaltitle=new_SRB$journaltitle, 
                  volume=new_SRB$volume, issue=new_SRB$issue, pubdate=new_SRB$pubdate, 
                  pagerange=new_SRB$pagerange, publisher=new_SRB$publisher, 
                  type=new_SRB$type, `reviewed-work`=new_SRB$`reviewed-work`, 
                  abstract=new_SRB$abstract)

# output
write.table(new_SRB, file='New_SRB.tsv', sep='\t', na = "", eol = "\r",
            row.names = FALSE, quote = FALSE)



###################################
### Southerly
###################################
### still need to work:
### urls
###################################
library(readxl)
library(zoo)
metadata_file_Southerly <- file.path("Southerly.xlsx")
raw_Southerly <- read_excel(metadata_file_Southerly)
Southerly_length <- length(raw_Southerly$DOI)

new_Southerly <- NULL
new_Southerly$id <- c(rep("id",Southerly_length))
new_Southerly$doi <- c(rep("doi",Southerly_length))

new_Southerly$title <- raw_Southerly$Article_Title

# author
Southerly_author_firstname <- raw_Southerly$Firstname
Southerly_author_surname <- raw_Southerly$Surname
for(i in 1:Southerly_length) {
  new_Southerly$author[i] <- paste(Southerly_author_firstname[i],
                                   Southerly_author_surname[i])
}

new_Southerly$journaltitle <- c(rep("Southerly",Southerly_length))
new_Southerly$volume <- raw_Southerly$VolumeNumber
new_Southerly$issue <- raw_Southerly$IssueNumber

# pubdate
for(i in 1:Southerly_length) {
  new_Southerly$pubdate[i] <- as.character(as.Date(raw_Southerly$Date_Of_Publication[i]))
}

# page range
new_Southerly$pagerange <- raw_Southerly$Pagination
new_Southerly$pagerange <- gsub("\\[","",new_Southerly$pagerange)
new_Southerly$pagerange <- gsub("\\]","",new_Southerly$pagerange)

new_Southerly$publisher <- c(rep("publisher",Southerly_length))
new_Southerly$type <- c(rep("type",Southerly_length))
new_Southerly$`reviewed-work` <- c(rep("reviewed-work",Southerly_length))

year_list1 <- seq(1939, 2011)
year_list2 <- seq(2012, 2016)

volume_list1 <- seq(1, 71)
volume_list2 <- seq(72, 76)

# id
for(i in 1:Southerly_length) {
  
  # year
  temp_year <- unlist(strsplit(as.character(new_Southerly$pubdate[i]), "-"))[1]
  
  # page range
  if(grepl("-",new_Southerly$pagerange[i]) && grepl(",",new_Southerly$pagerange[i])) {
    temp_first_page <- unlist(strsplit(as.character(new_Southerly$pagerange[i]), "-"))[1]
    if(grepl(",",temp_first_page)) temp_first_page <- 
        unlist(strsplit(as.character(new_Southerly$pagerange[i]), ","))[1]
  } else if(grepl("-",new_Southerly$pagerange[i])) {
    temp_first_page <- unlist(strsplit(as.character(new_Southerly$pagerange[i]), "-"))[1]
  } else if(grepl(",",new_Southerly$pagerange[i])) {
    temp_first_page <- unlist(strsplit(as.character(new_Southerly$pagerange[i]), ","))[1]
  } else {
    temp_first_page <- as.character(new_Southerly$pagerange[i])
  }
  temp_first_page <- formatC(temp_first_page, width=3, flag="0")
  temp_first_page <- gsub(" ", "0", temp_first_page)
  
  volume_number <- new_Southerly$volume[i]
  issue_number <- new_Southerly$issue[i]
  
  # volume, issue, folder, file
  temp_id <- "data/Southerly"
  if(temp_year %in% year_list1) {
    # 1939 to 2012
    temp_volume <- new_Southerly$volume[i]
    temp_volume <- formatC(temp_volume, width=2, flag="0")
    temp_volume <- gsub(" ", "0", temp_volume)
    
    temp_issue <- new_Southerly$issue[i]
    temp_issue <- formatC(temp_issue, width=1, flag="0")
    temp_issue <- gsub(" ", "0", temp_issue)
    
    temp_folder <- paste("Vol",temp_volume,"/No",temp_issue,"/",temp_year, sep="")
    if(volume_number==44&&issue_number==1) {
      temp_file <- paste("Stherly",temp_year,"V0",temp_volume,"N0",temp_issue,"/", 
                         temp_first_page, sep="")
    } else if(volume_number==48&&(issue_number==1||issue_number==4)) {
      temp_year <- as.numeric(temp_year) - 1
      temp_file <- paste("Sthrly",temp_year,"V0",temp_volume,"N0",temp_issue,"/", 
                         temp_first_page, sep="")
    } else if((volume_number==55||volume_number==56)&&issue_number==4) {
      temp_year1 <- as.numeric(temp_year) + 1
      temp_file <- paste("Sthrly",temp_year,"/",temp_year1,"V0",temp_volume,"N0",temp_issue,"/", 
                         temp_first_page, sep="")
    } else if(volume_number==65&&issue_number==3) {
      temp_file <- paste("Sthrly","V",volume_number,"N",issue_number,"/", 
                         temp_first_page, sep="")
    } else if(volume_number%in%c(66,67,68,69,70)) {
      temp_file <- paste("Sthrly","V",volume_number,"N",issue_number,"/", 
                         temp_first_page, sep="")
    } else if(volume_number==71) {
      temp_folder <- paste("Vol",temp_volume,"/No0",temp_issue,"/",temp_year, sep="")
      temp_file <- paste("Sthrly",temp_year,"V0",temp_volume,"N0",temp_issue,"/", 
                         temp_first_page, sep="")
    } else {
      temp_file <- paste("Sthrly",temp_year,"V0",temp_volume,"N0",temp_issue,"/", 
                         temp_first_page, sep="")
    }
  } else if(temp_year %in% year_list2) {
    # 2013 to 2016
    temp_volume <- new_Southerly$volume[i]
    temp_volume <- formatC(temp_volume, width=3, flag="0")
    temp_volume <- gsub(" ", "0", temp_volume)
    
    temp_issue <- new_Southerly$issue[i]
    temp_issue <- formatC(temp_issue, width=2, flag="0")
    temp_issue <- gsub(" ", "0", temp_issue)
    
    temp_folder <- paste(temp_year,"/v",temp_volume,"n",temp_issue, sep="")
    if(volume_number==76 && issue_number==2 &&grepl("LP", temp_first_page)) {
      temp_file <- paste("Sthrly",temp_year,"V",temp_volume,"N",temp_issue, 
                         temp_first_page, sep="")
    } else {
      temp_file <- paste("Sthrly",temp_year,"V",temp_volume,"N",temp_issue,"/", 
                         temp_first_page, sep="")
    }
  }
  temp_id <- paste(temp_id, temp_folder, temp_file, sep="/")
  new_Southerly$id[i] <- temp_id
}

# urls
new_Southerly$abstract <- c(rep("url",Southerly_length))

# test
i <- 3832
c(new_Southerly$id[i], new_Southerly$title[i],new_Southerly$author[i],
  new_Southerly$journaltitle[i],new_Southerly$volume[i],
  new_Southerly$issue[i], new_Southerly$pubdate[i])

new_Southerly <- data.frame(id=new_Southerly$id, doi=new_Southerly$doi, 
                            title=new_Southerly$title, author=new_Southerly$author, 
                            journaltitle=new_Southerly$journaltitle, volume=new_Southerly$volume, 
                            issue=new_Southerly$issue, pubdate=new_Southerly$pubdate, 
                            pagerange=new_Southerly$pagerange, publisher=new_Southerly$publisher, 
                            type=new_Southerly$type, `reviewed-work`=new_Southerly$`reviewed-work`, 
                            abstract=new_Southerly$abstract)

new_Southerly <- new_Southerly[order(new_Southerly$id),]

# output
write.table(new_Southerly, file='New_Southerly.tsv',sep='\t', na = "", eol = "\r",
            row.names = FALSE, quote = FALSE)

# wanted_valume <- seq(1,10)
# new_Southerly_part <- new_Southerly[new_Southerly$volume %in% wanted_valume,]
# 
# write.table(new_Southerly_part, file='New_Southerly_part.tsv',sep='\t', na = "", 
#             eol = "\r", row.names = FALSE, quote = FALSE)

###################################
### Westerly
###################################
### still need to work:
### id
### title
### author
### journal title
### volume
### issue
### pub date
### pagerange
### urls
###################################
library(readxl)
library(zoo)

new_Westerly <- NULL
new_Westerly$id <- NULL
new_Westerly$doi <- NULL
new_Westerly$title <- NULL
new_Westerly$author <- NULL
new_Westerly$journaltitle <- NULL
new_Westerly$volume <- NULL
new_Westerly$issue <- NULL
new_Westerly$pubdate <- NULL
new_Westerly$pagerange <- NULL
new_Westerly$publisher <- NULL
new_Westerly$type <- NULL
new_Westerly$`reviewed-work` <- NULL
new_Westerly$abstract <- NULL

metadata_file_Westerly <- file.path("Westerly.xlsx")

sheet_number <- 3
for(i in 1:sheet_number) {
  raw_Westerly_part <- read_excel(metadata_file_Westerly, sheet = i)
  Westerly_part_length <- length(raw_Westerly_part$ISSUE)
  
  new_Westerly_part <- NULL
  new_Westerly_part$id <- c(rep("id",Westerly_part_length))
  new_Westerly_part$doi <- c(rep("doi",Westerly_part_length))
  
  new_Westerly_part$title <- raw_Westerly_part$TITLE[1:Westerly_part_length]
  new_Westerly_part$author <- raw_Westerly_part$AUTHOR[1:Westerly_part_length]
  new_Westerly_part$journaltitle <- c(rep("Westerly",Westerly_part_length))
  
  # volume and issue
  volume_issue <- as.character(raw_Westerly_part$ISSUE[1])
  volume <- unlist(strsplit(volume_issue, ".", fixed=TRUE))[1]
  issue <- unlist(strsplit(volume_issue, ".", fixed=TRUE))[2]
  new_Westerly_part$volume <- c(rep(volume,Westerly_part_length))
  new_Westerly_part$issue <- c(rep(issue,Westerly_part_length))
  
  new_Westerly_part$pubdate <- c(rep("pubdate",Westerly_part_length))
  new_Westerly_part$pagerange <- c(rep("pagerange",Westerly_part_length))
  new_Westerly_part$publisher <- c(rep("publisher",Westerly_part_length))
  new_Westerly_part$type <- c(rep("type",Westerly_part_length))
  new_Westerly_part$`reviewed-work` <- c(rep("Westerly",Westerly_part_length))
  new_Westerly_part$abstract <- c(rep("urls",Westerly_part_length))
  
  new_Westerly_part <- data.frame(id=new_Westerly_part$id, doi=new_Westerly_part$doi, 
      title=new_Westerly_part$title, author=new_Westerly_part$author, 
      journaltitle=new_Westerly_part$journaltitle, volume=new_Westerly_part$volume, 
      issue=new_Westerly_part$issue, pubdate=new_Westerly_part$pubdate, 
      pagerange=new_Westerly_part$pagerange, publisher=new_Westerly_part$publisher, 
      type=new_Westerly_part$type, `reviewed-work`=new_Westerly_part$`reviewed-work`, 
      abstract=new_Westerly_part$abstract)
  new_Westerly <- rbind(new_Westerly, new_Westerly_part)
}

# test
i <- 19
c(new_Westerly$title[i],new_Westerly$author[i],
  new_Westerly$journaltitle[i],new_Westerly$volume[i],
  new_Westerly$issue[i], new_Westerly$pubdate[i])

# output
write.table(new_Westerly, file='new_Westerly.tsv',sep='\t', na = "", eol = "\r",
            row.names = FALSE, quote = FALSE)





