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

  def get_data(params = {})
    params = validate_and_parse_args params
    resposne = RestClient.get @data_url, {params: params}
    return JSON.parse resposne.body
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

  def validate_and_parse_args(args)
    for key, val in args
      case key
      when :limit
        if !val.is_a? Integer
          raise ArgumentError.new "limit must be a non-negative integer"
        end
      when :ids
        if !val.kind_of? Array
          raise ArgumentError.new "ids must be an array of string values"
        end
        args[key] = val.join ","
      when :order_by
        if !["asc", "desc"].include? val
          raise ArgumentError.new "order_by must be one 'asc' or 'desc'"
        end
        args[key] = val.upcase
      when :start, :to
        if !val.is_a? Integer
          raise ArgumentError.new "#{key} must be a non-negative integer"
        end
      end
    end
    return args
  end
end
