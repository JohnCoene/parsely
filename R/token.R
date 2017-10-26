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
#' @export
ly_token <- function(key, secret){
  if(missing(key) || missing(secret))
    stop("missing parameters", call. = FALSE)

  structure(list(key = key,secret = secret), class = "parsely")
}
