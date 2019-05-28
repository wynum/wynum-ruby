class Schema
  attr_reader :key, :value

  def initialize(schema_hash)
    @key = schema_hash["Property"]
    @type = schema_hash["Type"]
  end

  def to_s
    puts "key: #{@key}, value: #{@type}"
  end

  def to_str
    puts "key: #{@key}, value: #{@type}"
  end
end
