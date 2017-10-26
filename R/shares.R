#' Get shares
#'
#' Calls Parsely Analytics API
#'
#' @param token your token as returned by \code{\link{ly_token}}.
#' @param start start of date range to consider traffic from,
#'  limited to most recent 90 days.
#' @param end end of date range to consider traffic from.
#' @param pub.start publication filter start date, \code{posts} only.
#' @param pub.end publication filter end date, \code{posts} only.
#' @param n number of results to return
#' @param verbose prints feedback in the console
#'
#' @examples
#' \dontrun{
#' token <- ly_token("agenda.weforum.org", "XXxxX00X0X000XxXxXx000X0X0X00X")
#'
#' shares <- ly_shares(token)
#' gender <- ly_shares(token, n = 1000, verbose = TRUE)
#' }
#'
#' @export
ly_shares <- function(token, start = NULL, end = NULL,
                      pub.start = NULL, pub.end = NULL, n = 100,
                      verbose = FALSE){

  if(missing(token)) stop("missing token.")

  # Build URL
  uri <- httr::parse_url(paste0(getOption("parsely_base_url"), "shares/posts"))
  uri$query <- list(apikey = token[["key"]],
                    secret = token[["secret"]],
                    start = start,
                    end = end,
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

#' Get post shares detail
#'
#' For a given canonical URL, return the total share counts across the top
#' social networks. The following table shows what each integer value returned
#' in the response contains.
#'
#' @param token your token as returned by \code{\link{ly_token}}.
#' @param url canonical URL for which share counts should be retrieved.
#' @param verbose prints feedback in the console
#'
#' @examples
#' \dontrun{
#' token <- ly_token("agenda.weforum.org", "XXxxX00X0X000XxXxXx000X0X0X00X")
#'
#' # get shares
#' shares <- ly_shares(token)
#'
#' # get details on random shares
#' gender <- ly_shares_details(token, url = sample(shares$url, 1))
#' }
#'
#' @export
ly_shares_details <- function(token, url, verbose = FALSE){

  if(missing(token)) stop("missing token.")

  # Build URL
  uri <- httr::parse_url(paste0(getOption("parsely_base_url"), "shares/post/detail"))
  uri$query <- list(apikey = token[["key"]],
                    secret = token[["secret"]],
                    url = url)
  uri <- httr::build_url(uri)

  # call API
  response <- httr::GET(url = uri)

  if(verbose == TRUE) message("page 1")

  content <- httr::content(response)

  contents <- call_api(content, verbose, n = 100)

  data <- parse_json(contents)

  return(data)

}
