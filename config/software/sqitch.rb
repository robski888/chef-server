name "sqitch"
version "0.973"

dependency "perl"
dependency "postgresql92" # only because we're compiling DBD::Pg here, too.

source :url => "http://www.cpan.org/authors/id/D/DW/DWHEELER/App-Sqitch-#{version}.tar.gz",
       :md5 => "0994e9f906a7a4a2e97049c8dbaef584"

relative_path "App-Sqitch-#{version}"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
}

# See https://github.com/theory/sqitch for more
build do

  # What the hell... all of a sudden, we have a missing dependency in
  # Role::HasMessage
  #
  # Install cpanminus in order to install it, because cpan is such a
  # pain.
  #
  #   ;_;
  #
  command "cpan App::Cpanminus", :env => env
  command "cpanm Role::HasMessage", :env => env

  command "perl Build.PL", :env => env
  command "./Build installdeps", :env => env
  command "./Build", :env => env
  command "./Build test", :env => env
  command "./Build install", :env => env

  # We're using PostgreSQL as our database engine, so we need the right driver
  command "yes | cpan DBD::Pg", :env => env
end
