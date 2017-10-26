.onLoad <- function(libname = find.package("parsely"), pkgname = "parsely") {
  options(parsely_base_url = "https://api.parsely.com/v2/")
}


.onUnload <- function(libpath = find.package("parsely")) {
  options(parsely_base_url = NULL)
}

.onDetach <- function(libpath = find.package("parsely")) {
  options(parsely_base_url = NULL)
}
