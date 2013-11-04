module FFI32
  class Struct
    def self.method_missing(method, *args, &block)
      YAML.load(FFI32::Library.server.call("ffi32.struct_method_missing", name, method, YAML.dump(args)))
    end
  end
end
