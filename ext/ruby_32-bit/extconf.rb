require 'mkmf'

['make','wget','tar','rbenv'].each do |exe|
  unless find_executable(exe)
    crash "#{exe} needed"
  end
end

$makefile_created = true

dummy_makefile('ruby_32-bit')
unless find_executable('ruby',File.join(Dir.home,'.rbenv/versions/ruby-1.9.3-p448_32bit/bin'))
  if find_executable('apt-get')
    # TODO: Im not comfortable with doing this here. Maybe have a rake task, or even a user mode linux bottle for the 32 bit ruby.
    system 'sudo apt-get -y update'
    %q{build-essential autoconf gcc gcc:i386 c-compiler:i386 zlib1g-dev libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev curl git-core python-software-properties libc6-dev-i386 ia32-libs libssl-dev:i386}.split.each do |package|
      puts "sudo apt-get -y install #{package}"
      system "sudo apt-get -y install #{package}"
    end
  end
  system 'wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz'
  system 'tar -xzf ruby-1.9.3-p448.tar.gz'
  system 'cd ruby-1.9.3-p448; autoconf'
  system 'cd ruby-1.9.3-p448; ./configure --with-opt-dir=$HOME/.rbenv/versions/ruby-1.9.3-p448_32bit --with-arch=i386 --without-pg --prefix=$HOME/.rbenv/versions/ruby-1.9.3-p448_32bit'
  system 'cd ruby-1.9.3-p448; make'
  system 'cd ruby-1.9.3-p448; make install'
  system 'rm -rf ruby-1.9.3-p448'
  system 'rm ruby-1.9.3-p448.tar.gz'
  unless find_executable('ruby',File.join(Dir.home,'.rbenv/versions/ruby-1.9.3-p448_32bit/bin'))
    crash "failed to install ruby-1.9.3-p448_32bit"
  end
  system 'cd ~/.rbenv/plugins; git clone git://github.com/jamis/rbenv-gemset.git'
  system 'cd ~/.rbenv/versions/ruby-1.9.3-p448_32bit; rbenv gemset create 1.9.3-p448 ffi32'
  system 'cd ~/.rbenv/versions/ruby-1.9.3-p448_32bit; >.rbenv-gemsets <<<ffi32'
  system 'cd ~/.rbenv/versions/ruby-1.9.3-p448_32bit; rbenv gemset active'
  system 'cd ~/.rbenv/versions/ruby-1.9.3-p448_32bit; gem install ffi'
  system 'cd ~/.rbenv/versions/ruby-1.9.3-p448_32bit; rbenv rehash'
  system 'cd ~/.rbenv/versions/ruby-1.9.3-p448_32bit; rbenv gemset list'
end
