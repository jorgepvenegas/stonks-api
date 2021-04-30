require 'httparty'
require 'redis'
require 'json'

TOKEN = ENV["TOKEN"]                            # IEXCloud token
BASE_URL = "https://cloud.iexapis.com/stable"   # IEXCloud base url


class Stonk
    attr_accessor :ticker, :company_name, :week_52_high, :week_52_low, :dividend_yield, :pe_ratio, :close

    @@redis = Redis.new(host: 'localhost')

    def initialize ticker
        @ticker = ticker
    end

    def get_info
        if @@redis.get(@ticker) == nil
            get_data
        else
            get_cache
        end
        to_hash
    end

    private
    def get_data
        # puts "> Fetching #{ticker} from API"

        puts "#{BASE_URL}/stock/#{ticker}/stats?token=#{TOKEN}"
        stats = HTTParty.get("#{BASE_URL}/stock/#{ticker}/stats?token=#{TOKEN}")
        puts "#{BASE_URL}/stock/#{ticker}/previous?token=#{TOKEN}"
        previous = HTTParty.get("#{BASE_URL}/stock/#{ticker}/previous?token=#{TOKEN}")

        @company_name = stats['companyName']
        @week_52_high = stats['week52high']
        @week_52_low = stats['week52low']
        @dividend_yield = stats['dividendYield']
        @pe_ratio = stats['peRatio']
        @close = previous['close']
        @change_percent = previous['changePercent']

        hash = to_hash
        persist(hash)

    end

    def get_cache
        # puts "> Fetching #{ticker} from cache"

        cache_data = @@redis.get(@ticker)
        hash = JSON.parse(cache_data)
        @company_name = hash['company_name']
        @week_52_high = hash['week_52_high']
        @week_52_low = hash['week_52_low']
        @dividend_yield = hash['dividend_yield']
        @pe_ratio = hash['pe_ratio']
        @close = hash['close']
        @change_percent = hash['change_percent']
    end

    def to_hash
        hash = {}
        instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
        hash
    end

    def persist hash
        @@redis.set(@ticker, hash.to_json)
    end
end
  