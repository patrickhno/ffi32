
require 'rubygems'
require 'ffi'
require 'yaml'
require 'xmlrpc/server'
require File.expand_path(File.join(File.dirname(__FILE__), "lib/ffi32/capsule"))

module FFI32
  module Library
    extend FFI::Library

    def self.ffi_lib lib
      puts "LOADING #{ENV['OLDPWD'].inspect}/#{lib}"
      super ENV['OLDPWD'] + "/#{lib}"
    end

    def self.method_missing(method, *args, &block)
      puts "Library.#{method}: #{args.inspect}"
      raise "hell"
    end
  end

  module Server
    def run
      s = XMLRPC::Server.new(4321)
      s.add_handler("ffi32.method_missing") do |method,args|
        res = Library.send(method.to_sym,*YAML.load(args))
        puts res.inspect
        YAML.dump(FFI32::Capsule.new(res))
      end

      s.add_handler("ffi32.struct_method_missing") do |class_name,method,_args|
        args = YAML.load(_args).map do |arg|
          if arg.kind_of?(FFI32::Capsule)
            arg.content
          elsif arg.kind_of?(Syck::DomainType)
            Object.const_get('Library').const_get(arg.value.split('::').last)
          else
            arg
          end
        end
        mod,klass = class_name.split('::')
        mod = 'Library' # TODO: Name it
        a_new_class = begin
          Object.const_get(mod).const_get(klass)
        rescue NameError
          a_new_class = Class.new(FFI::Struct)
          Object.const_get(mod).const_set(klass, a_new_class)
          a_new_class
        end
        begin
          res = a_new_class.send(method,*args)
        rescue => e
          puts "EXCEPTION:"
          puts e.inspect
          puts e.backtrace.join("\n")
          raise "hell"
        end
        YAML.dump(FFI32::Capsule.new(res))
      end

      s.serve
    end
  end
end
