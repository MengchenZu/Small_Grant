dest <- "antipodes"
new_folder <- "Antipodes_after_rename"

mydir <- list.dirs(path = dest, full.names = TRUE)

# get every csv file in each folder
for(folder in mydir) {
  myfiles <- list.files(path = folder, pattern = ".csv",  full.names = TRUE)
  
  for(csv_file in myfiles) {
    if(csv_file != "antipodes/2013/27/1/10.13110%2Fantipodes.27.issue-1/10.13110%2Fantipodes.27.1.0099/10.13110%2Fantipodes.27.1.0099-NGRAMS1.csv" &&
       csv_file != "antipodes/2015/29/1/10.13110%2Fantipodes.29.issue-1/10.13110%2Fantipodes.29.1.0129/10.13110%2Fantipodes.29.1.0129-NGRAMS1.csv" &&
       csv_file != "antipodes/2015/29/1/10.13110%2Fantipodes.29.issue-1/10.13110%2Fantipodes.29.1.0193/10.13110%2Fantipodes.29.1.0193-NGRAMS1.csv"
    ) {
      
      # get the output file name
      #out_file_dir <- dirname(csv_file)
      #out_file_dir <- basename(out_file_dir)
      out_file <- basename(csv_file)
      out_file <- paste(new_folder,'/',out_file, sep="")
      
      # get the content from csv file
      csv_content <- read.csv(csv_file)
      csv_content <- data.frame(WORDCOUNTS=csv_content$V1, WEIGHT=csv_content$V2)
      
      write.csv(csv_content,out_file, row.names = FALSE, quote = FALSE)
    }
  }
}

