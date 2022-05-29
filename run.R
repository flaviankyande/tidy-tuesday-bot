# load libraries
library(rtweet)
library(googledrive)

# store API keys as variables
ck <- "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
cs <- "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
at <- "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
as <- "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

# save keys and tokens to environment variable
token <- create_token(
  app = "madeinrbot",
  consumer_key = ck,
  consumer_secret = cs,
  access_token = at,
  access_secret = as)

get_token()

# function to like and retweet a tweet
like_retweet <- function(statusId){
  rtweet::post_favorite(statusId, destroy = FALSE)
  rtweet::post_tweet(retweet_id =  statusId)
}

# set current date and search input value
date <- Sys.Date()
value <- sprintf("#rstats #tidytuesday since:%s -filter:replies", date)

# get tweets from the day
tweets <- search_tweets(value, n = 100, type = "recent", include_rts = FALSE)

# loop condition to retweet the tweets
for (tweet in tweets$status_id) {
  like_retweet(tweet)
}

# save tweets collected in a csv file
file_name <- sprintf("tweets_%s.csv", date)
write_as_csv(tweets, file_name)

# create the file path
file_path <- paste0(getwd(), "/", file_name)

# authorize login
drive_auth(email = "yourname@email.com", token = "tts.rds")

# load the csv files to Google drive
drive_upload(file_path)
  
# delete the file
file.remove(file_name)
