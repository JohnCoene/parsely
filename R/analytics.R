#' Get analytics
#'
#' Returns a list of posts, authors, sections or tags depending on the specified type.
#' This is typically used to generate front page or article page widgets featuring
#' your "Most Popular" content.
#'
#' @param token your token as returned by \code{\link{ly_token}}.
#' @param type one of \code{posts}, \code{authors}, \code{sections}, \code{tags},
#' \code{referrers}.
#' @param start start of date range to consider traffic from,
#'  limited to most recent 90 days.
#' @param end end of date range to consider traffic from.
#' @param pub.start publication filter start date, \code{posts} only.
#' @param pub.end publication filter end date, \code{posts} only.
#' @param section filter the current top posts by a specific section, \code{posts} only.
#' @param author filter the current top posts by a specific author, \code{posts} only.
#' @param tag filter the current top posts by a specific tag, \code{posts} only.
#' @param sort sort value; defaults to \code{views}. See
#'  \href{https://www.parse.ly/help/api/available-metrics/}{available metrics}.
#' @param n number of results to return.
#' @param verbose prints feedback in the console.
#'
#' @examples
#' \dontrun{
#' token <- ly_token("my.domain.com", "XXxxX00X0X000XxXxXx000X0X0X00X")
#'
#' posts <- ly_analytics(token)
#' gender <- ly_analytics(token, verbose = T, tag = "gender-parity",
#'   sort = "engaged_minutes", n = 1000)
#' }
#'
#' @export
ly_analytics <- function(token, type = "posts", start = NULL,
                         end = NULL, pub.start = NULL, pub.end = NULL,
                         section = NULL, author = NULL, tag = NULL, sort = "views",
                         n = 100, verbose = FALSE){

  # input check
  if(missing(token)) stop("missing token.", call. = FALSE)
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
                    period_start = start,
                    period_end = end,
                    pub_date_start = pub.start,
                    pub_date_end = pub.end,
                    section = section,
                    author = author,
                    sort = sort,
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

#' Get post analytics details
#'
#' Returns the post's metadata, as well as total views and visitors in the
#' metrics field. By default, this returns the total pageviews on the link
#' for the last 90 days.
#'
#' @param token your token as returned by \code{\link{ly_token}}.
#' @param url URL of post to fetch details on. This must be in canonical form,
#' including \code{http://} scheme. see examples
#' @param start start of date range to consider traffic from,
#'  limited to most recent 90 days. Defaults to \code{Sys.Date()-7}.
#' @param end end of date range to consider traffic from.
#'  Defaults to \code{Sys.Date()-7}.
#' @param verbose prints feedback in the console.
#'
#' @examples
#' \dontrun{
#' token <- ly_token("my.domain.com", "XXxxX00X0X000XxXxXx000X0X0X00X")
#'
#' # get all posts
#' posts <- ly_analytics(token)
#'
#' # get details of random post
#' post_details <- ly_analytics_details(token, url = sample(posts$url, 1))
#' }
#'
#' @export
ly_analytics_details <- function(token, url, start = NULL, end = NULL,
                                 verbose = FALSE){

  # input check
  if(missing(token)) stop("missing token.", call. = FALSE)
  if(missing(url)) stop("missing url.", call. = FALSE)

  # Build URL
  uri <- httr::parse_url(paste0(getOption("parsely_base_url"),
                                "analytics/post/detail"))
  uri$query <- list(apikey = token[["key"]],
                    secret = token[["secret"]],
                    url = url,
                    period_start = start,
                    period_end = end,
                    sort = "engaged_minutes")
  uri <- httr::build_url(uri)

  # call API
  response <- httr::GET(url = uri)

  if(verbose == TRUE) message("page 1")

  content <- httr::content(response)

  contents <- call_api(content, verbose, n = 100)

  data <- parse_json(contents)

  return(data)

}

#' Get meta analytics details
#'
#' Get detailed analytics on a meta object.
#'
#' @param token your token as returned by \code{\link{ly_token}}.
#' @param meta type of \code{value}, see details.
#' @param value value of \code{meta} to fetch detaisl of.
#' @param pub.start,pub.end publication filter start and end date.
#' @param period.start,period.end start and end of period to consider traffic from.
#' @param verbose prints feedback in the console.
#' @param n number of results to return.
#' @param sort sort value; defaults to \code{engaged_minutes}. See
#'
#' @details
#' valid meta:
#' \itemize{
#'   \item{\code{author}}
#'   \item{\code{section}}
#'   \item{\code{tag}}
#' }
#'
#' @importFrom utils URLencode
#'
#' @examples
#' \dontrun{
#' token <- ly_token("my.domain.com", "XXxxX00X0X000XxXxXx000X0X0X00X")
#'
#' # get 100 authors
#' authors <- ly_analytics(token, type = "authors", verbose = TRUE)
#'
#' # get author details
#' details <- ly_analytics_meta_details(token, "author", value = sample(authors$author, 1))
#' }
#'
#' @export
ly_analytics_meta_details <- function(token, meta, value, pub.start = NULL, pub.end = NULL,
                                      period.start = NULL, period.end = NULL, n = 100, verbose = FALSE,
                                      sort = "engaged_minutes"){

  # input check
  if(missing(token)) stop("missing token.", call. = FALSE)
  if(missing(meta)) stop("missing meta", call. = FALSE)
  if(missing(value)) stop("missing value", call. = FALSE)

  if(!meta %in% valid_metas())
    stop("invalid meta, see details.", call. = FALSE)

  # Build URL
  uri <- httr::parse_url(paste0(getOption("parsely_base_url"),
                                "analytics/", meta, "/", URLencode(as.character(value)) ,"/detail"))
  uri$query <- list(apikey = token[["key"]],
                    secret = token[["secret"]],
                    period_start = period.start,
                    period_end = period.end,
                    pub_date_start = pub.start,
                    pub_date_end = pub.end,
                    limit = 100,
                    page = 1,
                    sort = sort)
  uri <- httr::build_url(uri)

  # call API
  response <- httr::GET(url = uri)

  if(verbose == TRUE) message("page 1")

  content <- httr::content(response)

  contents <- call_api(content, verbose, n = n)

  data <- parse_json(contents)

  return(data)

}
