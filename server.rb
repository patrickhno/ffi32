
# $LOAD_PATH.clear
# $LOAD_PATH << "/home/patrick/.rbenv/versions/ruby-1.9.3-p448_32bit/lib/ruby/site_ruby/1.9.1"
# $LOAD_PATH << "/home/patrick/.rbenv/versions/ruby-1.9.3-p448_32bit/lib/ruby/site_ruby/1.9.1/i386-linux"
# $LOAD_PATH << "/home/patrick/.rbenv/versions/ruby-1.9.3-p448_32bit/lib/ruby/site_ruby"
# $LOAD_PATH << "/home/patrick/.rbenv/versions/ruby-1.9.3-p448_32bit/lib/ruby/vendor_ruby/1.9.1"
# $LOAD_PATH << "/home/patrick/.rbenv/versions/ruby-1.9.3-p448_32bit/lib/ruby/vendor_ruby/1.9.1/i386-linux"
# $LOAD_PATH << "/home/patrick/.rbenv/versions/ruby-1.9.3-p448_32bit/lib/ruby/vendor_ruby"
# $LOAD_PATH << "/home/patrick/.rbenv/versions/ruby-1.9.3-p448_32bit/lib/ruby/1.9.1"
# $LOAD_PATH << "/home/patrick/.rbenv/versions/ruby-1.9.3-p448_32bit/lib/ruby/1.9.1/i386-linux"

puts Gem.path.inspect

require 'rubygems'
require 'ffi'
require 'yaml'
require 'xmlrpc/server'
require File.expand_path(File.join(File.dirname(__FILE__), "lib/ffi32/capsule")) #'lib/ffi32/capsule'

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

s = XMLRPC::Server.new(4321)
s.add_handler("ffi32.method_missing") do |method,args|
puts "METHOD MISSING: #{method}: #{YAML.load(args).inspect}"
puts "\#\# Library.#{method} #{args.inspect}"
  res = Library.send(method.to_sym,*YAML.load(args))
  puts res.inspect
res.class.name.inspect
  YAML.dump(FFI32::Capsule.new(res))
end

s.add_handler("ffi32.struct_method_missing") do |class_name,method,_args|
  args = YAML.load(_args).map{ |arg| arg.kind_of?(FFI32::Capsule) ? arg.content : arg }
puts "METHOD MISSING FOR CLASS #{class_name}: #{method}: #{args.inspect}"
  mod,klass = class_name.split('::')
mod = 'Library'
  a_new_class = begin
    Object.const_get(mod).const_get(klass)
puts "\#\# a_new_class = Object.const_get('#{mod}').const_get('#{klass}')"
  rescue NameError
    a_new_class = Class.new(FFI::Struct)
    Object.const_get(mod).const_set(klass, a_new_class)
puts "\#\# a_new_class = Class.new(FFI::Struct)"
puts "\#\# Object.const_get('#{mod}').const_set('#{klass}', a_new_class)"
    a_new_class
  end
puts "GOT THE CLASS #{a_new_class.inspect}, CALLING METHOD #{method} with arguments #{args.inspect}"
  begin
puts "\#\# a_new_class.#{method} #{args.inspect}"
    res = a_new_class.send(method,*args)
  rescue => e
    puts "EXCEPTION:"
    puts e.inspect
    puts e.backtrace.join("\n")
    raise "hell"
  end
  puts res.inspect
puts res.class.name.inspect
  YAML.dump(FFI32::Capsule.new(res))
end

s.serve
