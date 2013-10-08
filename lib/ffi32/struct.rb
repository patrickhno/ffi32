module FFI32
  class Struct
    # def self.layout *args
    #   puts "Struct.layout: #{args.inspect}"
    #   ret = @server.call("ffi32.struct_method_missing", self.class.name, method, YAML.dump(args))
    #   raise "hell"
    # end
    def self.method_missing(method, *args, &block)
      puts "Struct.#{method}: #{args.inspect}"
      YAML.load(FFI32::Library.server.call("ffi32.struct_method_missing", name, method, YAML.dump(args)))
    end
  end
end
