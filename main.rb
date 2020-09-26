require "twitter"
require "date"
require "json"
require "dotenv"

class TwitterClient
    attr_reader :client
    def initialize()
        Dotenv.load(
            File.join(File.dirname(File.expand_path(__FILE__)), '.env')
        )
        @client = Twitter::REST::Client.new do |config|
            config.consumer_key         = ENV["CONSUMER_KEY"]
            config.consumer_secret      = ENV["CONSUMER_SECRET"]
            config.access_token         = ENV["ACCESS_TOKEN"]
            config.access_token_secret  = ENV["ACCESS_TOKEN_SECRET"]
        end
    end
    def tweet(str)
        @client.update(str)
    end
    def tweet_with_media(str,media_url)
        @client.update_with_media(str,media_url)
    end
    def get_current_time_str
        t = Time.new
        return t.strftime("%Y%m%d%H%M")
    end
    def tweet_check
        # 自動ツイートのチェックを開始
        # 現在時刻を取得
        currnet_time = self.get_current_time_str

        tweet = File.open("tweet.json") do |file|
            JSON.load(file)
        end
        if tweet.has_key?(currnet_time) then
            # 画像の有無で処理を分岐
            if tweet[currnet_time].has_key?("img")
                # p "img true"
                img_dir = "./tweet/" + tweet[currnet_time]["img"] + "/*"
                imgs = Dir.glob(img_dir).map{ |img| open(img) }
                # p imgs
                self.tweet_with_media(tweet[currnet_time]["tweet"], imgs)
            else
                # p "img False"
                self.tweet(tweet[currnet_time]["tweet"])
            end
        else
            p "tweet.json not found"
        end

    end
end


twitter = TwitterClient.new
# twitter.tweet("自動投稿テスト")
# images = []
# images << File.new("picture1.JPG")
# p twitter.tweet_with_media("投稿テスト","picture1.JPG")
twitter.tweet_check