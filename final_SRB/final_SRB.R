options(java.parameters="-Xmx2g")   # optional, but more memory for Java helps
library("dfrtopics")
library("dplyr")
library("ggplot2")
library("lubridate")
library("stringr")

my_read_dfr_metadata = function (filenames) 
{
  all_rows <- do.call(rbind, lapply(filenames, my_read_dfr_citations))
  result <- unique(all_rows)
  if (any(duplicated(result$id))) {
    warning("Some rows have the same id")
  }
  result
}

my_read_dfr_citations = function (filename, strip.white = TRUE, ...) 
{
  if (grepl("\\.tsv", filename, ignore.case = TRUE)) {
    cols <- scan(filename, nlines = 1, what = character(), 
                 sep = "\t", quiet = TRUE)
    if (length(cols) != 13) {
      warning("Expected 13 tab-delimited columns but found ", 
              length(cols), "\nResults may not be valid")
    }
    result <- read.table(filename, header = FALSE, skip = 1, 
                         sep = "\t", col.names = cols, quote = "", as.is = TRUE, 
                         comment = "", strip.white = strip.white, fill= TRUE, ...)
  }
  else {
    cols <- scan(filename, nlines = 1, what = character(), 
                 sep = ",", quiet = TRUE)
    result <- read.csv(filename, skip = 1, header = FALSE, 
                       col.names = cols, quote = "", as.is = TRUE, comment = "", 
                       strip.white = strip.white, fill= TRUE, ...)
  }
  result <- dplyr::tbl_df(result)
  # result$pubdate <- pubdate_Date(result$pubdate)
  result$type <- factor(result$type)
  result
}

data_dir <- file.path("data")

metadata_file <- file.path("New_SRB.tsv")
meta <- my_read_dfr_metadata(metadata_file)

counts <- read_wordcounts(list.files(file.path(data_dir, "SRB"),
                                     full.names=T))

stoplist_file <- file.path(path.package("dfrtopics"), "stoplist",
                           "stoplist.txt")
stoplist <- readLines(stoplist_file)
counts <- counts %>% wordcounts_remove_stopwords(stoplist)

ilist <- wordcounts_instances(counts)

m <- train_model(ilist, n_topics=10,
                 n_iters=500,
                 seed=1066,       # "reproducibility"
                 metadata=meta    # optional but handy later
                 # many more parameters...
)

write_mallet_model(m, "modeling_results")

dfr_browser(m)
