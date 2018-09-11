#' Search
#'
#' Search for Posts by keyword or query. These can match against full content.
#'
#' @param token your token as returned by \code{\link{ly_token}}.
#' @param q search query keywords; quoting is supported,
#' e.g. \code{q="squirrel facts"} instead of \code{q=squirrel+facts}.
#' @param section return recommendations that belong only in the specified section.
#' @param author return recommendations that only belong to the specified author.
#' @param tag return recommendations that only belong to the specified tag.
#' @param sort Wwat to sort the results by. There are currently 2 valid options:
#' \code{score}, which will sort articles by overall relevance and \code{pub_date}
#'  which will sort results by their publication date. The default is \code{score}
#' @param boost sub-sort value to re-rank relevant posts that receieved high
#' e.g. \code{views}. See
#' \href{available metrics}{https://www.parse.ly/help/api/available-metrics/}
#' for valid metrics. Available for \code{sort="score"} only.
#' @param exclude exclude recommendations from a certain author, section or tag.
#' The syntax is \code{exclude="<meta>:<meta-value>"}, where \code{meta} is one of
#' authors, section, or tags.
#' @param pub.start publication filter start date, \code{posts} only.
#' @param pub.end publication filter end date, \code{posts} only.
#' @param n number of results to return
#' @param verbose prints feedback in the console
#'
#' @examples
#' \dontrun{
#' token <- ly_token("my.domain.com", "XXxxX00X0X000XxXxXx000X0X0X00X")
#'
#' results <- ly_search(token, q = "ggplot2-topic")
#' }
#'
#' @export
ly_search <- function(token, q = NULL, section = NULL, tag = NULL, author = NULL,
                         boost = NULL, sort = NULL, exclude = NULL,
                         pub.start = NULL, pub.end = NULL, n = 100,
                         verbose = FALSE){

  # input check
  if(missing(token)) stop("missing token.", call. = FALSE)
  if(!is.null(boost) && sort != "score")
    stop("boost only valid if sort = score.", call. = FALSE)

  # Build URL
  uri <- httr::parse_url(paste0(getOption("parsely_base_url"), "search"))
  uri$query <- list(apikey = token[["key"]],
                    secret = token[["secret"]],
                    q = q,
                    section = section,
                    author = author,
                    tag = tag,
                    sort = sort,
                    boost = boost,
                    exclude = exclude,
                    pub_date_start = pub.start,
                    pub_date_end = pub.end,
                    limit = 100,
                    page = 1)
  uri <- httr::build_url(uri)

  # call API
  response <- httr::GET(url = uri)

  if(verbose == TRUE) message("page 1")

  content <- httr::content(response)

  contents <- call_api(content, verbose, n)

  data <- parse_json(contents)

  return(data)

}
