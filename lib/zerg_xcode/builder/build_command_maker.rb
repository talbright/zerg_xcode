
module ZergXcode::Builder

class BuildCommandMaker
  def make
    ['xcodebuild', '-alltargets']
  end
end

end
