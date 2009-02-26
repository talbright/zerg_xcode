require 'test/unit'
require 'test/plugins/test_helper.rb'

require 'zerg_xcode'

require 'rubygems'
require 'flexmock/test_unit'

module Plugins; end

class Plugins::ImportTest < Test::Unit::TestCase
  include Plugins::TestHelper
  
  def setup
    super
    @plugin = ZergXcode.plugin 'import'
  end
  
  def test_import_identical_small
    project = ZergXcode.load 'testdata/TestApp'
    assert_import_identical project
  end
  
  def test_import_identical_large
    project = ZergXcode.load 'testdata/ZergSupport'
    assert_import_identical project    
  end
    
  def test_import_differents
    small = ZergXcode.load 'testdata/TestApp'
    small_file_set = Set.new(small.all_files.map { |file| file[:path] })
    small_target_set = Set.new(small['targets'].map { |t| t['name'] })
    small_target_filesets = target_filesets small
    
    large = ZergXcode.load 'testdata/ZergSupport'
    large_file_set = Set.new(large.all_files.map { |file| file[:path] })
    large_target_set = Set.new(large['targets'].map { |t| t['name'] })
    large_target_filesets = target_filesets large
    
    @plugin.import_project! large, small
    merged_files_set = Set.new(small.all_files.map { |file| file[:path] })
    merged_target_set = Set.new(small['targets'].map { |t| t['name'] })
    merged_target_filesets = target_filesets small
    
    assert_equal((small_file_set + large_file_set), merged_files_set,
                 "Files")
    assert_equal((small_target_set + large_target_set), merged_target_set,
                 "Targets")
    assert_equal small_target_filesets.merge(large_target_filesets),
                 merged_target_filesets, "Targets / files associations"
  end
  
  # Produces a map of target to file associations for a project.
  # 
  # Looks like this:
  # { 'target1' => Set(['filename1.m', 'filename2.h']) }
  def target_filesets(project)
    Hash[*(project['targets']).map { |target|
      [target['name'], Set.new(target.all_files.map { |f| f[:object]['path'] })]
    }.flatten]
  end

  
  # Clones a project, zaps its metadata, and then tries to merge the clone onto
  # the original. The result should be the original.
  def assert_import_identical(project)
    pre_archive = ZergXcode::Archiver.archive_to_hash project
    
    cloned_project = ZergXcode::XcodeObject.from project    
    cloned_project.visit_once do |object, parent, key, value|
      object.version = nil
      object.archive_id = nil
      next true
    end
    
    @plugin.import_project! cloned_project, project
    post_archive = ZergXcode::Archiver.archive_to_hash project
    assert_equal pre_archive, post_archive
  end
  
  def test_bin_mappings
    proj = ZergXcode.load 'testdata/TestApp'
    mappings = @plugin.cross_reference proj, ZergXcode::XcodeObject.from(proj)
    
    bins = @plugin.bin_mappings mappings, proj
    merge, overwrite = bins[:merge], bins[:overwrite]
    
    assert_equal Set.new, merge.intersection(overwrite),
                 "Merge and overwrite sets should be disjoint"
    
    [proj['mainGroup'], proj['buildConfigurationList']].each do |object|    
      assert merge.include?(object), "#{object.merge_key.inspect} not in merge"
    end
    
    assert !merge.include?(proj), "Project should not be in any bin"
    assert !overwrite.include?(proj), "Project should not be in any bin"
  end
  
  def test_cross_reference_identical_small
    project = ZergXcode.load 'testdata/TestApp'
    assert_cross_reference_covers_project project
  end
  
  def test_cross_reference_identical_large
    project = ZergXcode.load 'testdata/ZergSupport'
    assert_cross_reference_covers_project project    
  end
  
  def assert_cross_reference_covers_project(project)
    cloned_project = ZergXcode::XcodeObject.from project
    
    map = @plugin.cross_reference project, cloned_project
    objects = Set.new([cloned_project])
    cloned_project.visit_once do |object, parent, key, value|
      objects << value if value.kind_of? ZergXcode::XcodeObject
      true
    end
    
    objects.each do |object|
      assert map.include?(object), "Missed object #{object.merge_key.inspect}"
      
      assert_equal object.merge_key, map[object].merge_key,
                   "Merge keys for cross-referenced objects do not match"
    end
  end
end
