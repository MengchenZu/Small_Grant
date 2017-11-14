dest <- "test"

mydir <- list.dirs(path = dest, full.names = TRUE)

# get every csv file in each folder
for(folder in mydir) {
  myfiles <- list.files(path = folder, pattern = ".csv",  full.names = TRUE)
  
  for(csv_file in myfiles) {
    
    # get the output file name
    out_file <- basename(csv_file)
    out_file <- paste('JASAL_after_rename/', out_file, sep="")
    
    # get the content from csv file
    csv_content <- read.csv(csv_file)
    
    write.csv(csv_content,out_file,  row.names = FALSE, quote = FALSE)
  }
}