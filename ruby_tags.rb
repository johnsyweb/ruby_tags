#!/usr/bin/ruby
#-*-ruby-*-
# A script to run ctags on all .rb files in a project. Can be run on
# the current dir, called from a git callback, or install itself as a
# git post-merge callback.

CTAGS = '/opt/local/bin/ctags'
HOOK = 'post-merge'
HOOKS_DIR = '.git/hooks'

def install
  if !File.writable?(HOOKS_DIR)
    $stderr.print "The install option [-i] can only be used within a git repo; exiting.\n"
    exit 1
  end
  
  full_hook = "#{HOOKS_DIR}/#{HOOK}"
  if File.exists?(full_hook)
    $stderr.print "A file already exists at #{full_hook}; exiting.\n"
    exit 1
  end
  
  print "Linking #{__FILE__} to #{full_hook}\n"
  %x{ln -s #{__FILE__}  #{full_hook}}
end

def run_tags(dir)
  if File.executable?(CTAGS) and File.writable?(dir)
    %x{find #{dir} -name \*.rb | #{CTAGS} -e -f #{dir}/TAGS -L -}
  else
    $stderr.print "FAILED to write TAGS file to #{dir}\n"
  end
end

if ARGV.first == '-i'
  install
else
  # if GIT_DIR is set, we are being called from git
  run_tags( ENV['GIT_DIR'] ? "#{ENV['GIT_DIR']}/.." : Dir.pwd )
end
