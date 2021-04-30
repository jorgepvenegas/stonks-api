require_relative 'classes/stonk'
require 'roda'
require 'json'

class Api < Roda
    route do |r|
        r.get "stock", String do |name|
            response['Content-Type'] = 'application/json'
            response['Access-Control-Allow-Origin'] = '*'
            stonk = Stonk.new(name)
            stonk.get_info.to_json
        end
    end
end

run Api
