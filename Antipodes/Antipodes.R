# create the directories with multiple layers
Create_multi_layer_dir = function(name){
  if(grepl('/',name)) Create_multi_layer_dir(dirname(name))
  
  if(!dir.exists(name)) {
    dir.create((name), showWarnings = FALSE)
  }
}

dest = 'data'

# get every folder name in dest
mydir <- list.dirs(path = dest, full.names = TRUE)
for(folder in mydir) {
  myfiles <- list.files(path = folder, pattern = "txt",  full.names = TRUE)
  
  # convert txt wordcount file to csv file
  for(txt_wordcount_file in myfiles) {
    require(stringr)
    # get the output file name
    # out_name <- sub('data/', 'csv/', txt_wordcount_file)
    # out_name <- sub('\\.txt$', '.csv', out_name)
    out_name <- sub('\\.txt$', '.csv', txt_wordcount_file)
    out_name <- paste('Antipodes/',basename(out_name),sep="")
    
    # get the text from pdf file
    if(txt_wordcount_file != "data/antipodes/2013/27/1/10.13110%2Fantipodes.27.issue-1/10.13110%2Fantipodes.27.1.0099/10.13110%2Fantipodes.27.1.0099-NGRAMS1.txt" &&
       txt_wordcount_file != "data/antipodes/2015/29/1/10.13110%2Fantipodes.29.issue-1/10.13110%2Fantipodes.29.1.0129/10.13110%2Fantipodes.29.1.0129-NGRAMS1.txt" &&
       txt_wordcount_file != "data/antipodes/2015/29/1/10.13110%2Fantipodes.29.issue-1/10.13110%2Fantipodes.29.1.0193/10.13110%2Fantipodes.29.1.0193-NGRAMS1.txt"
       ) {
      mydata = read.table(txt_wordcount_file, as.is = TRUE, stringsAsFactors=FALSE)
    } else {
      mydata <- read.table(txt_wordcount_file, header = FALSE, 
                           sep = "\t", quote = "", as.is = TRUE, stringsAsFactors=FALSE)
    }
    
    mydata <- data.frame(WORDCOUNTS=mydata$V1, WEIGHT=mydata$V2, 
                         as.is = TRUE, stringsAsFactors=FALSE)
    
    # the following code is to transfer "," in to another format, such as:
    # 1,700,000 convert to 1700000
    # 1,2,3,4,5 convert to five different rows
    for(i in 1:length(mydata$WORDCOUNTS)) {
      each <- mydata$WORDCOUNTS[i]
      if(str_detect(each, ",")) {
        list <- unlist(str_split(each,","))
        
        # figure out is 1,700 or 1,2,3
        flag <- TRUE
        for(j in 2:length(list)) {
          if(str_length(list[2]) != 3) {
            flag <- FALSE
          }
        }
        
        if(flag) {
          # 1,700,000 convert to 1700000
          new_word <- NULL
          for(part in list) {
            new_word <- paste(new_word, part, sep="")
          }
          mydata$WORDCOUNTS[i] <- new_word
        } else {
          # 1,2,3,4,5 convert to five different rows
          number <- mydata$WEIGHT[i]
          mydata$WEIGHT[i] <- 0
          new_word <- NULL
          for(part in list) {
            new_word <- paste(new_word, part, sep="")
          }
          mydata$WORDCOUNTS[i] <- new_word
          for(each_number in list) {
            have_write <- FALSE
            for(j in 1:length(mydata$WORDCOUNTS)) {
              new_each <- mydata$WORDCOUNTS[j]
              if(new_each == each_number) {
                mydata$WEIGHT[j] <- mydata$WEIGHT[j] + number
                have_write <- TRUE
                break
              }
            }
            if(have_write <- FALSE) {
              mydata[nrow(mydata) + 1,] = c(each_number,number, TRUE)
            }
          }
        }
      }
    }
    
    mydata <- data.frame(WORDCOUNTS=mydata$WORDCOUNTS, WEIGHT=mydata$WEIGHT)
    
    # create the directories
    Create_multi_layer_dir(file.path(dirname(out_name)))
    write.csv(mydata, out_name, row.names = FALSE, quote = FALSE)
  }
}
