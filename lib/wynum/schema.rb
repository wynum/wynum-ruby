class Schema
  attr_reader :key, :type

  def initialize(schema_hash)
    @key = schema_hash["Property"]
    @type = schema_hash["Type"]
  end

  def to_s
    puts "key: #{@key}, type: #{@type}"
  end

  def to_str
    puts "key: #{@key}, type: #{@type}"
  end
end
