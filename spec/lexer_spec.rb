require 'zerg_xcode'

RSpec::Matchers.define :produce_token do |expected|
  match do |actual|
    actual.send(:scan_token) == expected
  end
  failure_message_for_should do |actual|
    "expected Lexer to leave #{expected.dump} unconsumed instead of #{unconsumed(actual).dump}"
  end
end

RSpec::Matchers.define :leave_unconsumed do |expected|
  def unconsumed(actual)
    actual.instance_variable_get(:@scan_buffer).unconsumed
  end
  match do |actual|
    actual.send(:scan_token)
    unconsumed(actual) == expected
  end
  failure_message_for_should do |actual|
    "expected Lexer to leave #{expected.dump} unconsumed instead of #{unconsumed(actual).dump}"
  end
end

describe ZergXcode::Lexer do

  context "when scanning '// !$*UTF8*$!\\n{'" do
    subject {ZergXcode::Lexer.new("// !$*UTF8*$!\n{")}
    it {should produce_token([:encoding, "UTF8"])}
    it {should leave_unconsumed("\n{")}
  end
  
  context "when scanning '\"hello\"{'" do
    subject {ZergXcode::Lexer.new("\"hello\"{")}
    it {should produce_token([:string, "hello"])}
    it {should leave_unconsumed("{")}
  end

  context "when scanning '\\\"$(SRCROOT)/build/Debug-iphonesimulator\\\"'" do
    subject {ZergXcode::Lexer.new("\"\\\"$(SRCROOT)/build/Debug-iphonesimulator\\\"\" {")}
    it {should produce_token([:string, "\"$(SRCROOT)/build/Debug-iphonesimulator\""])}
    it {should leave_unconsumed(" {")}
  end

  context "when scanning ' /* comment 1  */\\t\\n/* comment 2 */  ={'" do
    subject {ZergXcode::Lexer.new(" /* comment 1  */\t\n/* comment 2 */  ={")}
    it {should produce_token(:assign)}
    it {should leave_unconsumed("{")}
  end

  context "when scanning ' \\t/* hello */\\n\\t'" do
    subject {ZergXcode::Lexer.new(" \t/* hello */\n\t")}
    it {should produce_token(nil)}
    it {should leave_unconsumed("")}
  end

  it "produces expected results for our fixture" do
    pbxdata = File.read 'test/fixtures/project.pbxproj'
    golden_starts = [[:encoding, "UTF8"],
                     :begin_hash,
                       [:symbol, "archiveVersion"], :assign, [:symbol, "1"],
                       :stop,
                       [:symbol, "classes"], :assign, :begin_hash, :end_hash,
                       :stop,
                       [:symbol, "objectVersion"], :assign, [:symbol, "45"],
                       :stop,
                       [:symbol, "objects"], :assign, :begin_hash,
                         [:symbol, "1D3623260D0F684500981E51"], :assign,
                         :begin_hash,
                           [:symbol, "isa"], :assign, [:symbol, "PBXBuildFile"],
                           :stop,
                           [:symbol, "fileRef"], :assign,
                             [:symbol, "1D3623250D0F684500981E51"],
                           :stop,
                         :end_hash,
                         :stop,
                         [:symbol, "1D60589B0D05DD56006BFB54"], :assign,
                         :begin_hash,
                           [:symbol, "isa"], :assign, [:symbol, "PBXBuildFile"],
                           :stop,
                           [:symbol, "fileRef"], :assign,
                             [:symbol, "29B97316FDCFA39411CA2CEA"],
                           :stop,
                         :end_hash,
                         :stop,
                         [:symbol, "1D60589F0D05DD5A006BFB54"], :assign,
                         :begin_hash,
                           [:symbol, "isa"], :assign, [:symbol, "PBXBuildFile"],
                           :stop,
                           [:symbol, "fileRef"], :assign,
                             [:symbol, "1D30AB110D05D00D00671497"],
                           :stop,
                         :end_hash,
                         :stop]
    
    tokens = ZergXcode::Lexer.tokenize pbxdata
    tokens[0, golden_starts.length].should == golden_starts
  end
end
