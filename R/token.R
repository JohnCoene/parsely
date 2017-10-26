#' Build token
#'
#' Build parse.ly token
#'
#' @param key the API key specified in your Parse.ly JavaScript
#' tracker; Required for all requests.
#' @param secret this parameter is required for every request and should
#' contain the secret token obtainable from the
#' \href{https://dash.parsely.com/agenda.weforum.org/settings/api/}{API Settings}
#'  page.
#'
#' @examples
#' \dontrun{
#' token <- ly_token("subdomain.domain.net", "XXxxX00X0X000XxXxXx000X0X0X00X")
#' }
#'
#' @export
ly_token <- function(key, secret){
  if(missing(key) || missing(secret))
    stop("missing parameters", call. = FALSE)

  structure(list(key = key,secret = secret), class = "parsely")
}
