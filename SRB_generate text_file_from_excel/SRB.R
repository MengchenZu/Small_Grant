# some of SRB content encode in string code
# todo: e is still wrong
library(readxl)
library(stringr)

metadata_file_SRB <- file.path("SRB.xlsx")
raw_SRB <- read_excel(metadata_file_SRB)
SRB_length <- length(raw_SRB$`Page Title`)

# some strang code
a <- substr(raw_SRB$Content[1],262,262)
aa <- str_sub(raw_SRB$Content[1], -485, -484)
# b is "-", short
b <- paste(a, "€“", sep="")
# bb is "--", long
bb <- paste(a, "€”", sep="")
# c is "'", right quote
c <- paste(a, "€™", sep="")
# d is "'", left quote
d <- paste(a, "€˜", sep="")
# todo: e is still wrong
# e is "..."
#e <- paste(a, "€\\¦", sep="")
# f is """, left double quote
f <- paste(a, "€œ", sep="")
# g is """, right double quote
g <- paste(a, "€\u009d", sep="")
# h is £
h <- paste(substr(aa,1,1), "£", sep="")
# one is ï
one <- paste(substr(aa,1,1), "¯", sep="")

for(i in 1:SRB_length) {
  text <- raw_SRB$Content[i]
  
  # remove content after reference
  text <- gsub("<h4>References</h4>.*?$", "", text)
  
  # remove the html code
  text <- gsub("<[^>]+>", "", text)
  
  # remove some unkown code into UNICODE
  text <- gsub(aa, " ", text)
  text <- gsub(b, "-", text)
  text <- gsub(bb, "—", text)
  text <- gsub(c, "’", text)
  text <- gsub(d, "‘", text)
  # text <- gsub(e, "…", text)
  text <- gsub(f, "“", text)
  text <- gsub(g, "”", text)
  text <- gsub(h, "£", text)
  text <- gsub(one, "ï", text)
  
  text <- gsub("&nbsp;", "\n", text)
  text <- gsub("Â ", " ", text)
  text <- gsub("Â", "", text)
  
  out_name <- paste("SRB/",i,".txt",sep="")
  write(text, out_name)
}


test <- raw_SRB$Content[i]
test1 <- strsplit(test, "Commonwealth Literary Fund grants")[[1]][2]
test2 <- strsplit(test1, "1947")[[1]][1]

