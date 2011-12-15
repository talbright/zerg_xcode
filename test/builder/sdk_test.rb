# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class SdkTest < Test::Unit::TestCase
  def test_can_find_any_macosx_sdk
    all_sdks = ZergXcode::Builder::Sdk.all
    macsdk = all_sdks.detect{|sdk| sdk[:arg] =~ /^macosx[0-9\.]+$/}
    assert_not_nil macsdk
  end
end
