options(java.parameters="-Xmx2g")   # optional, but more memory for Java helps
library("dfrtopics")
library("dplyr")
library("ggplot2")
library("lubridate")
library("stringr")

data_dir <- file.path("data/Southerly")

metadata_file <- file.path("New_Southerly.tsv")
meta <- read_dfr_metadata(metadata_file)

counts<- NULL
mydirs <- list.dirs(path = data_dir, full.names = TRUE)
for(folder in mydirs) {
  myfiles <- list.files(path = folder, pattern = ".csv",  full.names = TRUE)
  counts_part <- read_wordcounts(myfiles)
  counts <- rbind(counts, counts_part)
}

stoplist_file <- file.path(path.package("dfrtopics"), "stoplist",
                           "stoplist.txt")
stoplist <- readLines(stoplist_file)
counts <- counts %>% wordcounts_remove_stopwords(stoplist)

ilist <- wordcounts_instances(counts)

m <- train_model(ilist, n_topics=40,
                 n_iters=500,
                 seed=1066,       # "reproducibility"
                 metadata=meta    # optional but handy later
                 # many more parameters...
)

write_mallet_model(m, "modeling_results")

# metadata_file <- file.path("New_Southerly.tsv")
# m <- load_mallet_model_directory("modeling_results", metadata_file=metadata_file)

dfr_browser(m, "browser")
