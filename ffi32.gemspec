# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "ffi32/version"

Gem::Specification.new do |s|
  s.name        = "ffi32"
  s.version     = FFI32::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrick Hanevold"]
  s.email       = ["patrick.hanevold@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Handle 32-bit shared libraries in 64-bit ruby with FFI}
  s.description = %q{Yes its true, really handle 32-bit shared libraries in 64-bit ruby with FFI}
  s.required_rubygems_version = ">= 1.3.7"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = [
    "MIT-LICENSE",
    "README.rdoc"
  ]
  s.extensions << 'ext/ruby_32-bit/extconf.rb'

  s.add_dependency "ffi"
end
