task :default => :install

desc 'Installen ze dotfiles!'
task :install => [
                  'install:bundler',
                  'install:default_gems',
                  'install:bootstrap',
                  'install:symlinks',
                 ]

namespace :install do

  # disabling for now
  desc 'Get sudo privileges'
  task :sudome do
    info 'Checking for necessary sudo privileges...'
    if ENV["USER"] != "root"
      info "Need sudo privileges to continue, for installing software like bundler."
      # something changed in mountain lion's latest sudo version
      # exec("sudo #{ENV['_']} #{ARGV.join(' ')}")
      exec("sudo #{$0} #{ARGV.join(' ')}")
    else
      success "root access granted! COME ON POOKIE! LET'S BURN THIS MOTHERFUCKER DOWN!!!"
    end
  end

  desc 'Check for and install bundler'
  task :bundler do
    if !system 'command -v bundle > /dev/null 2>&1'
      info "Bundler is not installed, installing it for you."
      unless system 'sudo gem install bundler'
        error "sudo failed, do you have the right password?"
        exit 1
      end
    else
      info "Bundler already installed."
    end
  end

  desc 'Install our default gems'
  task :default_gems do
    info 'Installing default gems...'
    unless system 'sudo bundle install' 
      error "sudo failed, do you have the right password?"
      exit 1
    end
  end

  desc 'Run our bootstrap scripts for each dotfile, if any'
  task :bootstrap do
    run_me.each do |script|
      info "Running #{script}"
      system("./#{script}")
    end
  end

  desc 'Symlink the dotfiles to their correct locations'
  task :symlinks do
    link_me.each do |link|

      l = link.split('/').last.gsub('.symlink','')
      target = "#{ENV['HOME']}/.#{l}"

      if File.exists?(target) && !File.symlink?(target)
        `mv "#{target}" "#{target}.backup"`
        info "Backing up existing file #{target} to #{target}.backup"
      end
      `ln -s "$PWD/#{link}" "#{target}"`
      info "Symlinking #{ENV['PWD']}/#{link} to #{target}"
    end
  end
end

def info(msg)
  puts "\e[36m=> #{msg}\e[0m"
end

def error(msg)
  puts "\e[31m=> #{msg}\e[0m"
end

def success(msg)
  puts "\e[32m=> #{msg}\e[0m"
end

def run_me
  @b_files ||= Dir.glob('*/**{.bootstrap}')
end

def link_me
  @s_files ||= Dir.glob('*/**{.symlink}')
end
