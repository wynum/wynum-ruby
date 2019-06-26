require "rest-client"
require "json"

require File.dirname(__FILE__) + "/schema"

class Client
  attr_reader :identifier

  def initialize(secret, token)
    @secret = secret
    @token = token
    @data_url = "https://api.wynum.com/data/#{@token}?secret_key=#{@secret}"
    @schema_url = "https://api.wynum.com/component/#{@token}?secret_key=#{@secret}"
  end

  def get_data
    raise NotImplementedError
  end

  def get_schema
    resposne = RestClient.get @schema_url
    resposne_parsed = JSON.parse resposne.body
    @identifier = resposne_parsed["identifer"]
    components = resposne_parsed["components"]
    schemas = components.map { |c| Schema.new c }
    return schemas
  end

  def post_data(data)
    if has_file data
      form_data = prepare_form_data data
      resposne = RestClient.post(@data_url, form_data)
    else
      resposne = RestClient.post(@data_url, data.to_json, {content_type: :json, accept: :json})
    end
    return JSON.parse resposne.body
  end

  def update_data(data)
    if has_file data
      form_data = prepare_form_data data
      resposne = RestClient.put(@data_url, form_data)
    else
      resposne = RestClient.put(@data_url, data.to_json, {content_type: :json, accept: :json})
    end
    return JSON.parse resposne.body
  end

  def has_file(data)
    return data.any? { |key, val| val.class == File }
  end

  def prepare_form_data(data)
    form_data = data.select { |key, val| val.class == File }
    other_data = data.select { |key, val| val.class != File }
    form_data[:inputdata] = other_data.to_json
    form_data[:multipart] = true
    return form_data
  end
end
