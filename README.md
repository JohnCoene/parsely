# parsely

![WEF](https://www.parse.ly/static/img/brand/logo-parsely-green-vertical.png)

Easily call [parse.ly](http://parse.ly/) API from R.

## Install

```R
devtools::install_github("JohnCoene/parsely")
```

## functions

* `ly_token`
* `ly_search`
* `ly_analytics`
* `ly_analytics_details`
* `ly_analytics_meta_details`
* `ly_shares`
* `ly_shares_details`
* `ly_referrers`

## Example

```R
token <- ly_token("subdomain.domain.net", "XXxxX00X0X000XxXxXx000X0X0X00X")

gender_posts <- ly_search(token, q = "gender") # search articles by keyword

# get analytics of posts tagged gender-parity
gender_analytics <- ly_analytics(token, type = "posts", tags = "gender-parity")

# get details for specific URL
url <- "https://www.r-project.org/"
    
url_data <- ly_analytics_details(token, url = url)
```

