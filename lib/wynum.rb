require File.dirname(__FILE__) + "/wynum/version"
require File.dirname(__FILE__) + "/wynum/client"

module Wynum
  class Error < StandardError; end

  Client = Client
end
