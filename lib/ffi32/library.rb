require 'xmlrpc/client'
require 'yaml'

module FFI32
  module Library
    def self.server
      @server ||= begin
        Thread.new do
          spec = Gem::Specification.find_by_name("ffi32")
          # "cd " + ENV['RBENV_ROOT'] + "; env; " + ENV['RBENV_ROOT'] + "/versions/ruby-1.9.3-p448_32bit/bin/ruby #{spec.gem_dir}/server.rb"
          command = "cd " + ENV['RBENV_ROOT'] + "; " + ENV['RBENV_ROOT'] + "/versions/ruby-1.9.3-p448_32bit/bin/ruby -e 'require \'ffi32/server.rb\'; FFI32::Server.run'"
          Rails.logger.debug command rescue NameError
          system({
            "BUNDLE_GEMFILE" => '',
            "BUNDLE_BIN_PATH" => '',
            "GEM_PATH" => ENV['RBENV_ROOT'] + "/versions/ruby-1.9.3-p448_32bit/lib/ruby/gems/1.9.1",
            "GEM_HOME" => ENV['RBENV_ROOT'] + "/versions/ruby-1.9.3-p448_32bit/lib/ruby/gems/1.9.1"
            },command)
        end
        sleep 5 # TODO: sync somehow
        XMLRPC::Client.new("localhost", "/RPC2", 4321)
      end
    end
    def method_missing(method, *args, &block)
      ret = FFI32::Library.server.call("ffi32.method_missing", method, YAML.dump(args))
      YAML.load(ret)
    end
  end
end
