types <- function(){
  x <- c("posts", "authors", "sections", "tags", "referrers")
  return(x)
}

# loop through pages
call_api <- function(content, verbose, n){

  all <- content$data

  i <- 1

  while(length(content$links$`next`) && length(all) < n){

    next_page <- httr::GET(content$links$`next`) # call next url
    content <- httr::content(next_page) # extract content
    all <- append(all, content$data) # bind
    if(verbose == TRUE)
      i <- i + 1;
      message("page ", i)
    Sys.sleep(1)
  }

  return(all)
}

# list to data.frame
parse_json <- function(x){
  lst <- lapply(x, unlist)
  lst <- lapply(lst, function(x){
    as.data.frame(as.list(x))
  })
  plyr::ldply(lst, data.frame)
}
