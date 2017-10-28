# Small_Grant
Use dfr-topics to do the natural language processing with Australian Literatures from the following journals: Antipodes, Australian Literary Studies, Journal of the Association for the Study of Australian Literature (TODO), Southerly, Sydney Review of Books and Westerly (TODO).



General:
To get the dfr topics browser, we need two components: wordcounts files and metadata file. The following is some important tips:
1.	The id in metadata file must be as same as the directory of the wordcounts file without the “.csv”, such as “data/SRB/1”. If you have already written the mallet model, the generated ids of wordcounts can be found in “modeling_results/doc_ids.txt”. If you want to see in R, it can be found in “m$doc_ids” or “doc_ids(m)”.
2.	Every wordcount file must have a corresponding metadata in metadata file, otherwise metadata won't run in “dfr_browser(m)”.
3.	If there is any problem when you connect the mallet model ids with metadata ids, you can use “metadata(m)” to see if the loaded metadata is error. You can also use “doc_ids(m)[!doc_ids(m) %in% meta$id]” to see which wordcount file's id is not in metadata file.
4.	In those “final_” packages, there are two functions help to read metadata: “my_read_dfr_metadata” and “my_read_dfr_citations”. These two functions are the corrected function for “read_dfr_metadata” and “read_dfr_citations” in package “dfrtopics”. The former functions in package are wrong, which is not suitable for our metadata.



The R packages:
1.	Antipodes: “Antipodes” package is used to convert wordcount in text files to wordcount in csv files. There is a variable “dest” to set the resource of wordcount in text files and store in csv files.
2.	convert_pdf_to_txt: “convert_pdf_to_txt” package is used to convert pdf files to text files and then convert text files to wordcount csv files. There are some code used to remove error text, which sometimes will lead to error in different operating system. You can delete those code, in order to avoid error.
a.	“convert_pdf_to_txt” function: If parameter “dest” is “data”, it will convert pdf files from folder “data” to text files and store in folder “txt”. If the parameter “dest” isn’t “data”, the generated text files will store in the same folder.
b.	“convert_txt_to_csv” function: If parameter “dest” is “txt”, it will convert text files from folder “txt” to wordcount csv files and store in folder “csv”. If the parameter “dest” isn’t “txt”, the generated csv files will store in the same folder.
3.	“final_”: those “final_” packages are used to generate the dfr topic from wordcount csv files and metadata with single journal.
4.	Antipodes_metadata_intigration: “Antipodes_metadata_intigration” package is used to generate Antipodes “.tsv” metadata file from those “.xml” files.
5.	easyLoad_metadata: “easyLoad_metadata” package is used to generate “.tsv” file for different journals, including ALS, JASAL, SRB, Southerly and Westerly. There are five parts in this package for those five journals metadata.
6.	JASAL_files_rename: “JASAL_files_rename” package is used to move all the wordcount csv files into the same folder. However, after we generate the JASAL ids manually, this package may become useless.
7.	SRB_generate text_file_from_excel: “SRB_generate text_file_from_excel” package is used to generate text files from “SRB-data-2017.xlsx” file.
8.	zzz_final: “zzz_final” package is the final product for “final_” packages, which combines all the Australian Literatures from the following journals: Antipodes, Australian Literary Studies, Journal of the Association for the Study of Australian Literature, Southerly, Sydney Review of Books and Westerly.



Description for each journal:
Sydney Review of Books:
The following R package will be useful for SRB wordcounts files and metadata file:
“SRB_generate text_file_from_excel” to get the text files from “SRB-data-2017.xlsx” file, “convert_pdf_to_txt” to get wordcount from text files, “easyLoad_metadata” to get metadata from “. SRB-data-2017.xlsx” file, “final_SRB” to get the dfr topic browser from wordcount files and metadata file.
Tips:
1.	There is some error code in the initial “SRB-data-2017.xlsx” file, which need to be corrected later.
2.	The reference in articles have been removed when generating text file.



Australian Literary Studies:
The following R package will be useful for ALS wordcounts files and metadata file:
convert_pdf_to_txt” to get wordcount from pdf files, “easyLoad_metadata” to get metadata from “ALS.csv” file, “final_ALS” to get the dfr topic browser from wordcount files and metadata file.
Tips:
1.	There are some words cannot generate into text file or leading to error code, because those words are “picture” in pdf file. For example, there is a word “Asia” in article “a-bellyful-of-bali-robin-gerster-17-4.pdf”
2.	The reference and work cited haven’t been removed when generating text files.



Antipodes:
The following R package will be useful for Antipodes wordcounts files and metadata file:
“Antipodes” to generate wordcount csv files from wordcount text files, “Antipodes_metadata_intigration” to get metadata from “.xml” files, “final_Antipodes” to get the dfr topic browser from wordcount files and metadata file.
Tips:
1.	There are several files with Chinese character, which will lead to error. You should delete the Chinese character first, and then use Antipodes.R, at last add them mannually. They are:
antipodes/2013/27/1/10.13110%2Fantipodes.27.issue-1/10.13110%2Fantipodes.27.1.0099/10.13110%2Fantipodes.27.1.0099-NGRAMS1.txt
antipodes/2015/29/1/10.13110%2Fantipodes.29.issue-1/10.13110%2Fantipodes.29.1.0129/10.13110%2Fantipodes.29.1.0129-NGRAMS1.txt
antipodes/2015/29/1/10.13110%2Fantipodes.29.issue-1/10.13110%2Fantipodes.29.1.0193/10.13110%2Fantipodes.29.1.0193-NGRAMS1.txt



Southerly:
The following R package will be useful for Antipodes wordcounts files and metadata file:

Tips:
1.	The poetries haven’t been removed from the article.
2.	If one article has multiple authors, the metadata can only show one of the author.
3.	If there are multiple articles on the same page, the metadata can only show the first one.
4.	The page range of some of the articles is correct in the metadata, but incorrect in the file name. To integrate them, I edit the metadata with the incorrect file name.
