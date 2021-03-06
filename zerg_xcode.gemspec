# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "zerg_xcode"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Victor Costan"]
  s.date = "2012-01-12"
  s.email = "victor@zergling.net"
  s.executables = ["zerg-xcode"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.textile"
  ]
  s.files = [
    ".document",
    ".project",
    "CHANGELOG",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "Manifest",
    "README.textile",
    "RUBYFORGE",
    "Rakefile",
    "VERSION",
    "bin/zerg-xcode",
    "lib/zerg_xcode.rb",
    "lib/zerg_xcode/builder/runner.rb",
    "lib/zerg_xcode/builder/sdks.rb",
    "lib/zerg_xcode/file_format/archiver.rb",
    "lib/zerg_xcode/file_format/encoder.rb",
    "lib/zerg_xcode/file_format/id_generator.rb",
    "lib/zerg_xcode/file_format/lexer.rb",
    "lib/zerg_xcode/file_format/parser.rb",
    "lib/zerg_xcode/file_format/scan_buffer.rb",
    "lib/zerg_xcode/objects/pbx_build_file.rb",
    "lib/zerg_xcode/objects/pbx_build_phase.rb",
    "lib/zerg_xcode/objects/pbx_container_item_proxy.rb",
    "lib/zerg_xcode/objects/pbx_group.rb",
    "lib/zerg_xcode/objects/pbx_native_target.rb",
    "lib/zerg_xcode/objects/pbx_project.rb",
    "lib/zerg_xcode/objects/pbx_target_dependency.rb",
    "lib/zerg_xcode/objects/xc_configuration_list.rb",
    "lib/zerg_xcode/objects/xcode_object.rb",
    "lib/zerg_xcode/paths.rb",
    "lib/zerg_xcode/plugins/addlibrary.rb",
    "lib/zerg_xcode/plugins/core/core.rb",
    "lib/zerg_xcode/plugins/help.rb",
    "lib/zerg_xcode/plugins/import.rb",
    "lib/zerg_xcode/plugins/irb.rb",
    "lib/zerg_xcode/plugins/ls.rb",
    "lib/zerg_xcode/plugins/lstargets.rb",
    "lib/zerg_xcode/plugins/retarget.rb",
    "lib/zerg_xcode/shortcuts.rb",
    "spec/archiver_spec.rb",
    "spec/builder/runner_spec.rb",
    "spec/builder/sdk_spec.rb",
    "spec/encoder_spec.rb",
    "spec/fixtures/ClosedLib/ClosedLib.xcodeproj/project.pbxproj",
    "spec/fixtures/ClosedLib/ClosedLib_Prefix.pch",
    "spec/fixtures/ClosedLib/ClosedNative.c",
    "spec/fixtures/ClosedLib/ClosedNative.h",
    "spec/fixtures/FlatTestApp/FlatTestApp.xcodeproj/project.pbxproj",
    "spec/fixtures/TestApp/TestApp.xcodeproj/project.pbxproj",
    "spec/fixtures/TestApp30.xcodeproj/project.pbxproj",
    "spec/fixtures/TestLib30.xcodeproj/project.pbxproj",
    "spec/fixtures/ZergSupport.xcodeproj/project.pbxproj",
    "spec/fixtures/project.pbxproj",
    "spec/fixtures/project.pbxproj.compat",
    "spec/id_generator_spec.rb",
    "spec/lexer_spec.rb",
    "spec/objects/pbx_group_spec.rb",
    "spec/parser_spec.rb",
    "spec/paths_spec.rb",
    "spec/shortcuts_spec.rb",
    "test/objects/pbx_build_file_test.rb",
    "test/objects/pbx_build_phase_test.rb",
    "test/objects/pbx_container_item_proxy_test.rb",
    "test/objects/pbx_native_target_test.rb",
    "test/objects/pbx_project_test.rb",
    "test/objects/pbx_target_dependency_test.rb",
    "test/objects/xc_configuration_list_test.rb",
    "test/objects/xcode_object_test.rb",
    "test/plugins/addlibrary_test.rb",
    "test/plugins/core/core_test.rb",
    "test/plugins/helper.rb",
    "test/plugins/import_test.rb",
    "test/plugins/irb_test.rb",
    "test/plugins/ls_test.rb",
    "test/plugins/lstargets_test.rb",
    "test/plugins/retarget_test.rb",
    "zerg_xcode.gemspec"
  ]
  s.homepage = "http://github.com/zerglings/zerg_xcode"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Automated modifications for Xcode project files"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7.0"])
      s.add_development_dependency(%q<flexmock>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.7.0"])
      s.add_dependency(%q<flexmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.7.0"])
    s.add_dependency(%q<flexmock>, [">= 0"])
  end
end

