require "net/https"
require "uri"
require "moip/version"
require "moip/checkout"

module Moip
  class Config
    def self.access_token
      @access_token
    end
    
    def self.access_token=(value)
      @access_token = value
    end
    
    def self.access_key
      @access_key
    end
    
    def self.access_key=(value)
      @access_key = value
    end    
    
    def self.test?
      @test || false
    end

    def self.test=(test)
      @test = test
    end    
  end
end
