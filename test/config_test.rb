require 'test_helper'

class ConfigTest < TestHelper

  def setup
  end
  
  def test_test_flag
    assert Moip::Config.test?
  end
  
  def test_access_token_flag
    assert_equal Moip::Config.access_token, 'UFTWIIZJQUNTIV97KIDYRV8GK37X8LKM'
  end  
  
  def test_key_flag
    assert_equal Moip::Config.access_key, 'OXPO54ITJ6DOF91DJEWV3YUQQMU7QVYU719RAYGQ'
  end  
end