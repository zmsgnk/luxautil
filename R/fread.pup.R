#' data.table::fread() for exported files from PupSQLite 
#' 
#' @param input Either the file name to read (containing no \n character), a shell command that preprocesses the file (e.g. fread("grep blah filename")) or the input itself as a string (containing at least one \n), see examples. In both cases, a length 1 character string. A filename input is passed through path.expand for convenience and may be a URL starting http:// or file://.
#' @param sep The separator between columns. Defaults to the first character in the set [,\t |;:] that exists on line autostart outside quoted ("") regions, and separates the rows above autostart into a consistent number of fields, too.
#' @param sep2 The separator within columns. A list column will be returned where each cell is a vector of values. This is much faster using less working memory than strsplit afterwards or similar techniques. For each column sep2 can be different and is the first character in the same set above [,\t |;:], other than sep, that exists inside each field outside quoted regions on line autostart. NB: sep2 is not yet implemented.
#' @param nrows The number of rows to read, by default -1 means all. Unlike read.table, it doesn't help speed to set this to the number of rows in the file (or an estimate), since the number of rows is automatically determined and is already fast. Only set nrows if you require the first 10 rows, for example. 'nrows=0' is a special case that just returns the column names and types; e.g., a dry run for a large file or to quickly check format consistency of a set of files before starting to read any.
#' @param header Does the first data line contain column names? Defaults according to whether every non-empty field on the first data line is type character. If so, or TRUE is supplied, any empty column names are given a default name.
#' @param na.strings A character vector of strings to convert to NA_character_. By default for columns read as type character ",," is read as a blank string ("") and ",NA," is read as NA_character_. Typical alternatives might be na.strings=NULL or perhaps na.strings=c("NA","N/A","").
#' @param stringsAsFactors Convert all character columns to factors?
#' @param verbose Be chatty and report timings?
#' @param autostart Any line number within the region of machine readable delimited text, by default 30. If the file is shorter or this line is empty (e.g. short files with trailing blank lines) then the last non empty line (with a non empty line above that) is used. This line and the lines above it are used to auto detect sep, sep2 and the number of fields. It's extremely unlikely that autostart should ever need to be changed, we hope.
#' @param skip If -1 (default) use the procedure described below starting on line autostart to find the first data row. skip>=0 means ignore autostart and take line skip+1 as the first data row (or column names according to header="auto"|TRUE|FALSE as usual). skip="string" searches for "string" in the file (e.g. a substring of the column names row) and starts on that line (inspired by read.xls in package gdata).
#' @param select Vector of column names or numbers to keep, drop the rest.
#' @param drop Vector of column names or numbers to drop, keep the rest.
#' @param colClasses A character vector of classes (named or unnamed), as read.csv. Or a named list of vectors of column names or numbers, see examples. colClasses in fread is intended for rare overrides, not for routine use. fread will only promote a column to a higher type if colClasses requests it. It won't downgrade a column to a lower type since NAs would result. You have to coerce such columns afterwards yourself, if you really require data loss.
#' @param integer64 "integer64" (default) reads columns detected as containing integers larger than 2^31 as type bit64::integer64. Alternatively, "double"|"numeric" reads as base::read.csv does; i.e., possibly with loss of precision and if so silently. Or, "character".
#' @param showProgress TRUE displays progress on the console using \r. It is produced in fread's C code where the very nice (but R level) txtProgressBar and tkProgressBar are not easily available.
#' @return A \code{data.table}.
#' @author Koji MAKIYAMA
#' 
#' @export
fread.pup <- function(input = "test.csv", sep = "auto", sep2 = "auto", nrows = -1L, 
                      header = "auto", na.strings = "NA", stringsAsFactors = FALSE, 
                      verbose = FALSE, autostart = 30L, skip = -1L, select = NULL, 
                      drop = NULL, colClasses = NULL, integer64 = getOption("datatable.integer64"), 
                      showProgress = getOption("datatable.showProgress")) {
  data <- fread(input = input, sep = sep, sep2 = sep2, nrows = nrows, 
                header = header, na.strings = na.strings, stringsAsFactors = stringsAsFactors,
                verbose = verbose, autostart = autostart, skip = skip, select = select, 
                drop = drop, colClasses = colClasses, integer64 = integer64, showProgress = showProgress)
  first <- colnames(data)[1]
  Sys.setlocale('LC_ALL','C')
  setnames(data, first, first %>% str_replace("\xefｻｿ" , "") %>% str_replace_all("\"", ""))
  data
}
