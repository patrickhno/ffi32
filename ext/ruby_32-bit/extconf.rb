require 'mkmf'

['make','autoconf','wget','tar','rbenv'].each do |exe|
  unless find_executable(exe)
    crash "#{exe} needed"
  end
end

$makefile_created = true

unless find_executable('ruby',File.join(Dir.home,'.rbenv/versions/ruby-1.9.3-p448_32bit/bin'))
  system 'wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz'
  system 'tar -xzf ruby-1.9.3-p448.tar.gz'
  system 'cd ruby-1.9.3-p448; autoconf'
  system 'cd ruby-1.9.3-p448; ./configure --disable-pthread --with-opt-dir=$HOME/.rbenv/versions/ruby-1.9.3-p448_32bit --with-arch=i386 --prefix=$HOME/.rbenv/versions/ruby-1.9.3-p448_32bit'
  system 'cd ruby-1.9.3-p448; make'
  system 'cd ruby-1.9.3-p448; make install'
  system 'rm -rf ruby-1.9.3-p448'
  system 'rm ruby-1.9.3-p448.tar.gz'
end
