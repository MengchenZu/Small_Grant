# create the directories with multiple layers
Create_multi_layer_dir = function(name){
  if(grepl('/',name)) Create_multi_layer_dir(dirname(name))
  
  if(!dir.exists(name)) {
    dir.create((name), showWarnings = FALSE)
  }
}

#######################################
###   create txt files from pdf files
#######################################
convert_pdf_to_txt = function(dest) {
  require(pdftools)
  require(tools)
  
  # get every folder name in dest
  mydir <- list.dirs(path = dest, full.names = TRUE)
  
  # get every pdf file in each folder
  for(folder in mydir) {
    myfiles <- list.files(path = folder, pattern = ".pdf",  full.names = TRUE)
    
    # convert each pdf file to txt file
    for(pdf_file in myfiles) {
      # get the output file name
      out_name <- sub('data/', 'txt/', pdf_file)
      out_name <- sub('\\.pdf$', '.txt', out_name)
      
      # get the text from pdf file
      text <- pdf_text(pdf_file)
      
      # amend some error characters in text, such as "‘" and "’"
      #text <- gsub("‘", "'", text)
      #text <- gsub("’", "'", text)
      
      # create the directories
      Create_multi_layer_dir(file.path(dirname(out_name)))
      
      #if(!dir.exists(file.path(dirname(out_name))))
      #    dir.create(file.path(dirname(out_name)), showWarnings = TRUE)
      
      write(text, out_name)
    }
  }
}

#######################################
###   create csv files from txt files
#######################################
convert_txt_to_csv = function(dest) {
  require(tm)
  mydir <- list.dirs(path = dest, full.names = TRUE)
  for(folder in mydir) {
    # or if you want DFR-style csv files...
    # read txt files into R
    mytxtfiles <- list.files(path = folder, pattern = ".txt",  full.names = TRUE)
    
    # if the directory is empty, go to next directory, avoid
    # error in function DirSource()
    if(length(mytxtfiles) == 0) next
    
    mycorpus <- Corpus(DirSource(folder, pattern = "txt"))
    # warnings may appear after you run the previous line, they
    # can be ignored
    mycorpus <- tm_map(mycorpus,  removeNumbers)
    mycorpus <- tm_map(mycorpus,  removePunctuation)
    mycorpus <- tm_map(mycorpus,  stripWhitespace)
    mydtm <- DocumentTermMatrix(mycorpus)
    # remove some OCR weirdness
    # words with more than 2 consecutive characters
    mydtm <- mydtm[,!grepl("(.)\\1{2,}", mydtm$dimnames$Terms)]
    
    # get each doc as a csv with words and counts
    for(i in 1:nrow(mydtm)){
      # get word counts
      counts <- as.vector(as.matrix(mydtm[i,]))
      # get words
      words <- mydtm$dimnames$Terms
      
      # combine into data frame
      df <- data.frame(WORDCOUNTS = words, WEIGHT = counts,stringsAsFactors = FALSE)
      
      # exclude words with count of zero
      df <- df[df$WEIGHT != 0,]
      
      # remove rows with error wordcounts
      if(length(grep("uff", df$WORDCOUNTS)) > 0) df <- df[- grep("uff", df$WORDCOUNTS),]
      # remove rows with error wordcounts
      if(length(grep("a鈧\xac", df$WORDCOUNTS)) > 0) df <- df[- grep("a鈧\xac", df$WORDCOUNTS),]
      
      # order the df with the frequency of words
      df <- df[order(df$WEIGHT,decreasing = TRUE),]
      
      # get the output file name
      out_name <- paste0(mydtm$dimnames$Docs[i])
      out_name <- paste0(folder,"/",out_name)
      out_name <- sub('txt/', 'csv/', out_name)
      out_name <- sub('\\.txt$', '.csv', out_name)
      
      # create the directories
      Create_multi_layer_dir(file.path(dirname(out_name)))
      
      # write to CSV with original txt filename
      write.csv(df, out_name, row.names = FALSE, quote = FALSE) 
    }
  }
}

# input folder with pdf files
dest <- "data"
convert_pdf_to_txt(dest)

dest <- "txt"
convert_txt_to_csv(dest)





