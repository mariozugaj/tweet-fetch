class TweetsController < ApplicationController
  def index
    @tweets = Kaminari.paginate_array(TwitterClient.new
                                                   .latest_tweets(params[:handle]))
                      .page
    @endpoint = pagination_tweets_path
    @page_amount = @tweets.total_pages
  end

  def pagination
    @tweets = Kaminari.paginate_array(TwitterClient.new
                                                   .latest_tweets(params[:handle]))
                      .page(params[:page])
    render partial: 'tweets/tweet', layout: false, collection: @tweets
  end
end

class TwitterClient
  require 'twitter'
  attr_reader :client

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Figaro.env.twitter_key
      config.consumer_secret     = Figaro.env.twitter_secret
      config.access_token        = Figaro.env.twitter_token
      config.access_token_secret = Figaro.env.twitter_token_secret
    end
  end

  def latest_tweets(handle)
    client.user_timeline(handle, count: 200)
  rescue => e
    Rails.logger.error { "#{e.message}" }
    []
  end
end
