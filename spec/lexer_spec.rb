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
    it {should produce_token('{')}
    it {should leave_unconsumed("")}
  end
  
  context "when scanning '\"hello \\\"\\r\\n\\t\\\\\\'$(SRCROOT)\\\"\"'" do
    subject {ZergXcode::Lexer.new("\"hello \\\"\\r\\n\\t\\\\\\'$(SRCROOT)\\\"\" {")}
    it {should produce_token([:string, "hello \"\r\n\t\\'$(SRCROOT)\""])}
    it {should leave_unconsumed(" {")}
  end

  context "when scanning ' /* comment 1  */\\t\\n/* comment 2 */  ={'" do
    subject {ZergXcode::Lexer.new(" /* comment 1  */\t\n/* comment 2 */  ={")}
    it {should produce_token('=')}
    it {should leave_unconsumed("{")}
  end

  context "when scanning ' \\t/* hello */\\n\\t'" do
    subject {ZergXcode::Lexer.new(" \t/* hello */\n\t")}
    it {should produce_token(nil)}
    it {should leave_unconsumed("")}
  end

  context "when scanning '(x'" do
    subject {ZergXcode::Lexer.new("(x")}
    it {should produce_token('(')}
    it {should leave_unconsumed("x")}
  end

  context "when scanning ')x'" do
    subject {ZergXcode::Lexer.new(")x")}
    it {should produce_token(')')}
    it {should leave_unconsumed("x")}
  end

  context "when scanning '{x'" do
    subject {ZergXcode::Lexer.new("{x")}
    it {should produce_token('{')}
    it {should leave_unconsumed("x")}
  end

  context "when scanning '}x'" do
    subject {ZergXcode::Lexer.new("}x")}
    it {should produce_token('}')}
    it {should leave_unconsumed("x")}
  end

  context "when scanning '=x'" do
    subject {ZergXcode::Lexer.new("=x")}
    it {should produce_token('=')}
    it {should leave_unconsumed("x")}
  end

  context "when scanning ';x'" do
    subject {ZergXcode::Lexer.new(";x")}
    it {should produce_token(';')}
    it {should leave_unconsumed("x")}
  end

  context "when scanning ',x'" do
    subject {ZergXcode::Lexer.new(",x")}
    it {should produce_token(',')}
    it {should leave_unconsumed("x")}
  end

  context "when scanning 'archiveVersion ='" do
    subject {ZergXcode::Lexer.new("archiveVersion =")}
    it {should produce_token([:string, "archiveVersion"])}
    it {should leave_unconsumed(" =")}
  end

  context "when scanning '{ foo = \"hello\", bar };'" do
    subject {ZergXcode::Lexer.tokenize("{ foo = \"hello\", bar };")}
    it {should == ['{',
                   [:string, "foo"],
                   '=',
                   [:string, "hello"],
                   ',',
                   [:string, "bar"],
                   '}',
                   ';']}
  end

end
