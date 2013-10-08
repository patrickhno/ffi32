require 'yaml'
require 'base64'

module FFI32
  class Capsule
    def initialize content
      @content = Base64.encode64(YAML.dump(content))
    end
    def content
      YAML.load(Base64.decode64(@content))
    end
  end
end

