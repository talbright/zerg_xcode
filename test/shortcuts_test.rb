# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Zergling.Net
# License:: MIT

require 'zerg_xcode'
require 'test/unit'

class ShortcutsTest < Test::Unit::TestCase
  def test_plugin
    ls_instance = ZergXcode.plugin 'ls'
    ls_class = ZergXcode::Plugins::Ls
    assert ls_instance.kind_of?(ls_class), 'plugin retrieves wrong object'    
  end
end
