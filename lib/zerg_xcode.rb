module ZergXcode; end
module ZergXcode::Objects; end


require 'zerg_xcode/file_format/archiver.rb'
require 'zerg_xcode/file_format/encoder.rb'
require 'zerg_xcode/file_format/lexer.rb'
require 'zerg_xcode/file_format/parser.rb'
require 'zerg_xcode/file_format/paths.rb'

require 'zerg_xcode/objects/xcode_object.rb'
require 'zerg_xcode/objects/pbx_build_file.rb'
require 'zerg_xcode/objects/pbx_container_item_proxy.rb'
require 'zerg_xcode/objects/pbx_group.rb'
require 'zerg_xcode/objects/pbx_native_target.rb'
require 'zerg_xcode/objects/pbx_project.rb'
require 'zerg_xcode/objects/pbx_target_dependency.rb'
require 'zerg_xcode/objects/xc_configuration_list.rb'
require 'zerg_xcode/plugins/core/core.rb'

require 'zerg_xcode/shortcuts.rb'
