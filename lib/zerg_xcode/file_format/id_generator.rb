
# :nodoc: namespace
module ZergXcode

# Generates archive IDs for objects.
class IdGenerator
  def initialize
    @assigned_ids = Set.new
  end
  
  def new_id
    loop do
      id = (0...24).map { '%02X' % rand(256) }.join
      next if @assigned_ids.include? id
      @assigned_ids << id
      return id
    end
  end

  def id_for(object)
    if object.archive_id && !@assigned_ids.include?(object.archive_id)
      @assigned_ids << object.archive_id 
      return object.archive_id 
    else
      return new_id
    end
  end
end

end
