require "rest-client"
require "json"

require File.dirname(__FILE__) + "/schema"

class Client
  attr_reader :identifier

  def initialize(secret, token)
    @secret = secret
    @token = token
    @data_url = "https://api.wynum.com/data/#{@token}"
    @schema_url = "https://api.wynum.com/component/#{@token}"
  end

  def get_schema
    resposne = RestClient.get @schema_url
    resposne_parsed = JSON.parse resposne.body
    @identifier = resposne_parsed["identifier"]
    components = resposne_parsed["components"]
    schemas = components.map { |c| Schema.new c }
    return schemas
  end

  def post_data(data)
    resposne = RestClient.post(@data_url, data.to_json, {content_type: :json, accept: :json})
    return JSON.parse resposne.body
  end

  def update_data(data)
    resposne = RestClient.put(@data_url, data.to_json, {content_type: :json, accept: :json})
    return JSON.parse resposne.body
  end
end
