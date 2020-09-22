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
        dir_path = "./tweet/"+currnet_time
        # dir_path = "./tweet/"+"202009222224"
        if File.directory?(dir_path)
            json = File.open(dir_path + "/tweet.json") do |file|
                JSON.load(file)
            end
            p json["tweet"]
            imgs = json["img"].map{ |img| open(dir_path + "/" + img)}
            if imgs.length === 0 then
                # 文章のみ
                p "not img"
                self.tweet(json["tweet"])
            else
                # 画像含む
                p "img"
                self.tweet_with_media(json["tweet"],imgs)
            end
        else
            p "False"
        end
    end
end


twitter = TwitterClient.new
# twitter.tweet("自動投稿テスト")
# images = []
# images << File.new("picture1.JPG")
# p twitter.tweet_with_media("投稿テスト","picture1.JPG")
twitter.tweet_check