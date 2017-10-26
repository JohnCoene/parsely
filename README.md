# parsely

![WEF](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/World_Economic_Forum_logo.svg/2000px-World_Economic_Forum_logo.svg.png)

# functions

* `ly_token`
* `ly_search`
* `ly_analytics`
* `ly_analytics_details`
* `ly_shares`
* `ly_shares_details`
* `ly_referrers`

## Example

```R
token <- ly_token("subdomain.domain.net", "XXxxX00X0X000XxXxXx000X0X0X00X")

gender_posts <- ly_search(token, q = "gender") # search articles by keyword

# get analytics of posts tagged gender-parity
gender_analytics <- ly_analytics(token, type = "posts"", tags = "gender-parity")
```
-------------------------------------

Issue? email: <Jean-Philippe.Coene@weforum.org>
