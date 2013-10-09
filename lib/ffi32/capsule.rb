require 'yaml'

module FFI32
  class Capsule
    def initialize content
      @@objects ||= []
      @@objects << content
      @id = @@objects.last.object_id
    end
    def content
      ObjectSpace._id2ref(@id)
    end
  end
end

