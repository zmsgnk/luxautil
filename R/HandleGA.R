#' Handle Google Analytics using rga::rga()
#' 
#' @param start.date  Start date of the period. %Y-%m-%d
#' @param end.date End date of the period. %Y-%m-%d
#' @param domain Domain from which extract data. character
#' @param metrics Metrics as character (e.g.: "ga:users,ga:sessions,ga:pageviews")
#' @param dimensions Dimensions  as character (e.g.: "ga:date")
#' @param sort Metrics used to sort (e.g.: "ga:date")
#' @param filters Filter (e.g.: "ga:pagePath=~/lx/"")
#' @param segment Segment (e.g.: "gaid::-14")
#' @param start Start point of the data (usually 1)
#' @param max Max record of the data. 
#' @param where Path to your ga instance.
#' @return A \code{data.frame}.
#' @author zmsgnk
#' 
#' @export
HandleGA <- function(start.date = format(Sys.Date() - 8, "%Y-%m-%d"),
	                   end.date = format(Sys.Date() - 1, "%Y-%m-%d"),
	                   domain, metrics = "ga:users,ga:sessions,ga:pageviews", 
	                   dimensions = "ga:date", sort = "", filters = "", segment = "", start=1, max=10000, where="ga.rga") {
	rga.open(instance="ga", where=where)
  props <- ga$getProfiles()

	GetGAByProfileID <- function() {
		p <- props[props$name %in% domain, ]
		profile.ids <- as.character(p$id)
		foreach(id=profile.ids, .combine=rbind) %do% {
			ga$getData(id, 
				         start.date = start.date,
				         end.date = end.date,
				         metrics = metrics,
				         dimensions = dimensions,
				         filters = filters,
				         sort = sort,
				         segment = segment,
				         start = start, 
				         max = max)
		}
	}
	GetGAByProfileID()
}