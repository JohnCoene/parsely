#' Get Anaqlytics
#'
#' Calls Parsely Analytics API
#'
#' @param token your token as returned by \code{\link{ly_token}}.
#' @param type one of \code{posts}, \code{authors}, \code{sections}, \code{tags},
#' \code{referrers}.
#' @param start start of date range to consider traffic from,
#'  limited to most recent 90 days. Defaults to \code{Sys.Date()-7}.
#' @param end end of date range to consider traffic from.
#'  Defaults to \code{Sys.Date()-7}.
#' @param pub.start publication filter start date, \code{posts} only.
#' @param pub.end publication filter end date, \code{posts} only.
#' @param section filter the current top posts by a specific section, \code{posts} only.
#' @param author filter the current top posts by a specific author, \code{posts} only.
#' @param tag filter the current top posts by a specific tag, \code{posts} only.
#' @param sort sort value; defaults to \code{views}. See
#'  \href{https://www.parse.ly/help/api/available-metrics/}{available metrics}.
#' @param n number of results to return
#' @param verbose prints feedback in the console
#'
#' @export
ly_analytics <- function(token, type = "posts", start = Sys.Date()-7,
                         end = Sys.Date(), pub.start = NULL, pub.end = NULL,
                         section = NULL, author = NULL, tag = NULL, sort = "views",
                         n = 100, verbose = FALSE){

  # input check
  if(!is.null(pub.start) || !is.null(pub.end) && type != "posts")
    stop("pub.start and pub.end are only available for type = posts", call. = FALSE)
  if(!is.null(section) && type != "posts")
    stop("section is only available for type = posts", call. = FALSE)
  if(!is.null(author) && type != "posts")
    stop("section is only available for type = posts", call. = FALSE)
  if(!is.null(tag) && type != "posts")
    stop("section is only available for type = posts", call. = FALSE)
  if(!type %in% types())
    stop("Invalid type", call. = FALSE)

  # Build URL
  uri <- httr::parse_url(paste0(getOption("parsely_base_url"), "analytics/", type))
  uri$query <- list(apikey = token[["key"]],
                    secret = token[["secret"]],
                    start = start,
                    end = end,
                    pub_date_start = pub.start,
                    pub_date_end = pub.end,
                    section = section,
                    author = author,
                    tag = tag,
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
