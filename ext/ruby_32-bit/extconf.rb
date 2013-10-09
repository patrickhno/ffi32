require 'mkmf'

['make','autoconf','wget','tar','rbenv'].each do |exe|
  unless find_executable(exe)
    crash "#{exe} needed"
  end
end

$makefile_created = true

dummy_makefile('ruby_32-bit')
unless find_executable('ruby',File.join(Dir.home,'.rbenv/versions/ruby-1.9.3-p448_32bit/bin'))
  if find_executable('apt-get')
    system 'sudo apt-get -y update'
    system 'sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev curl git-core python-software-properties libc6-dev-i386 ia32-libs libssl-dev:i386'
  end
  system 'wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz'
  system 'tar -xzf ruby-1.9.3-p448.tar.gz'
  system 'cd ruby-1.9.3-p448; autoconf'
  system 'cd ruby-1.9.3-p448; ./configure --with-opt-dir=$HOME/.rbenv/versions/ruby-1.9.3-p448_32bit --with-arch=i386 --prefix=$HOME/.rbenv/versions/ruby-1.9.3-p448_32bit'
  system 'cd ruby-1.9.3-p448; make'
  system 'cd ruby-1.9.3-p448; make install'
  system 'rm -rf ruby-1.9.3-p448'
  system 'rm ruby-1.9.3-p448.tar.gz'
  unless find_executable('ruby',File.join(Dir.home,'.rbenv/versions/ruby-1.9.3-p448_32bit/bin'))
    crash "failed to install ruby-1.9.3-p448_32bit"
  end
  system '~/.rbenv/versions/ruby-1.9.3-p448_32bit/bin/gem install ffi'
end
