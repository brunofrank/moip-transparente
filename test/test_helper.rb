require 'rubygems'
require 'test/unit'
require "moip"

class TestHelper < Test::Unit::TestCase
end

Moip::Config.access_token = 'UFTWIIZJQUNTIV97KIDYRV8GK37X8LKM'
Moip::Config.access_key   = 'OXPO54ITJ6DOF91DJEWV3YUQQMU7QVYU719RAYGQ'
Moip::Config.test = true