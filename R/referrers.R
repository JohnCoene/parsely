#' Get referrers
#'
#' Return a list of the top referrers for a referrer type. This can be either an
#' overall number, or a number restricted to a specific domain.
#'
#' @param token your token as returned by \code{\link{ly_token}}.
#' @param referrer.type one of \code{social}, \code{search}, \code{other},
#'  \code{internal}. Defaults to \code{social}.
#' @param section section to restrict this query to.
#' @param tag tag to restrict this query to.
#' @param domain domain to restrict this query to.
#' @param start start of date range to consider traffic from,
#'  limited to most recent 90 days. Defaults to \code{Sys.Date()-7}.
#' @param end end of date range to consider traffic from.
#'  Defaults to \code{Sys.Date()-7}.
#' @param pub.start publication filter start date, \code{posts} only.
#' @param pub.end publication filter end date, \code{posts} only.
#' @param n number of results to return
#' @param verbose prints feedback in the console
#'
#' @examples
#' \dontrun{
#' token <- ly_token("agenda.weforum.org", "XXxxX00X0X000XxXxXx000X0X0X00X")
#'
#' refs <- ly_referrers(token)
#' gender <- ly_referrers(token, referrer.type = "search", tag = "gender-parity")
#' }
#'
#' @export
ly_referrers <- function(token, referrer.type = "social", section = NULL,
                         tag = NULL, domain = NULL, start = NULL,
                         end = NULL, pub.start = NULL, pub.end = NULL,
                         n = 100, verbose = FALSE){

  # input check
  if(missing(token)) stop("missing token.")
  if(!referrer.type %in% referrers())
    stop("Invalid referrer.type", call. = FALSE)

  # Build URL
  uri <- httr::parse_url(paste0(getOption("parsely_base_url"), "referrers/",
                                referrer.type))
  uri$query <- list(apikey = token[["key"]],
                    secret = token[["secret"]],
                    tag = tag,
                    section = section,
                    domain = domain,
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
