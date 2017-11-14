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

my_load_mallet_model_directory = function (f, load_topic_words = FALSE,
                                           load_sampling_state = FALSE, metadata_file = NULL, metadata_folder = NULL) 
{
  tw <- if (load_topic_words) 
    file.path(f, "topic_words.csv")
  else NULL
  ss <- if (load_sampling_state) 
    file.path(f, "state.csv")
  else NULL
  my_load_mallet_model(doc_topics_file = file.path(f, "doc_topics.csv"), 
                       doc_ids_file = file.path(f, "doc_ids.txt"), vocab_file = file.path(f, 
                                                                                          "vocabulary.txt"), top_words_file = file.path(f, 
                                                                                                                                        "top_words.csv"), params_file = file.path(f, "params.txt"), 
                       topic_words_file = tw, state_file = ss, metadata_file = metadata_file, metadata_folder = metadata_folder)
}

my_load_mallet_model = function (doc_topics_file, doc_ids_file, vocab_file, top_words_file = NULL, 
                                 topic_words_file = NULL, metadata_file = NULL, metadata_folder = NULL, params_file = NULL, 
                                 state_file = NULL) 
{
  if (!is.null(top_words_file)) {
    top_w <- dplyr::tbl_df(read.csv(top_words_file, as.is = TRUE, 
                                    quote = ""))
  }
  else {
    top_w <- NULL
  }
  if (!is.null(topic_words_file)) {
    tw <- as(read_matrix_csv(topic_words_file), "sparseMatrix")
  }
  else {
    tw <- NULL
  }
  if (!is.null(metadata_file)) {
    metadata <- my_read_dfr_metadata(metadata_file)
  }
  else if (!is.null(metadata_folder)) {
    myfiles <- list.files(path = metadata_folder, pattern = ".tsv", full.names = TRUE)
    metadata <- NULL
    for(metadata_file in myfiles) {
      meta_part <- my_read_dfr_metadata(metadata_file)
      metadata <- rbind(metadata, meta_part)
    }
  } else {
    metadata <- NULL
  }
  if (!is.null(params_file)) {
    p <- dget(params_file)
    params <- p$params
    hyper <- p$hyper
  }
  else {
    params <- NULL
    hyper <- NULL
  }
  if (!is.null(state_file)) {
    ss <- read_sampling_state(state_file)
  }
  else {
    ss <- NULL
  }
  ids <- readLines(doc_ids_file)
  result <- mallet_model(doc_topics = read_matrix_csv(doc_topics_file), 
                         doc_ids = ids, vocab = readLines(vocab_file), top_words = top_w, 
                         topic_words = tw, params = params, hyper = hyper, ss = ss, 
                         metadata = match_metadata(metadata, ids))
  result
}

match_metadata <- function (meta, ids) {
  i <- match(ids, meta$id)
  if (any(is.na(i))) {
    NULL
  } else {
    meta[i, ]
  }
}

data_dir <- file.path("data")

metadata_file <- file.path("New_ALS.tsv")
meta <- my_read_dfr_metadata(metadata_file)

counts <- read_wordcounts(list.files(file.path(data_dir, "ALS"),
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

# doc_ids(m)[!doc_ids(m) %in% meta$id]

write_mallet_model(m, "modeling_results")

# metadata_file <- file.path("New_ALS.tsv")
# m <- my_load_mallet_model_directory("modeling_results", metadata_file=metadata_file)

dfr_browser(m)
