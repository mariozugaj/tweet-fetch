class TweetsController < ApplicationController
  def index
    @tweets = TwitterClient.new.latest_tweets(params[:handle])
    respond_to :html, :js
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
    nil
  end
end
