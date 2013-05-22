#!/usr/bin/env ruby
#-*-ruby-*-
# A script to run ctags on all .rb files in a project. Can be run on
# the current dir, called from a git callback, or install itself as a
# git post-merge and post-commit callback.

CTAGS = %x{ which ctags }.chomp
HOOKS = %w{ post-merge post-commit post-checkout }
HOOKS_DIR = '.git/hooks'
VIM_MODE = /_vim/.match($0)
TAGS_FILE = VIM_MODE ? 'tags' : 'TAGS'
EMACS_FLAG = VIM_MODE ? '' : '-e'

DEBUG_MODE = false

def install
  if !File.writable?(HOOKS_DIR)
    $stderr.print "The install option [-i] can only be used within a git repo; exiting.\n"
    exit 1
  end
  
  HOOKS.each { |hook| install_hook("#{HOOKS_DIR}/#{hook}") }
end

def run_tags(dir, run_in_background = false)
  if File.executable?(CTAGS) and File.writable?(dir)
    cmd = "find #{dir} -name \\\*.rb | #{CTAGS} #{EMACS_FLAG} -f #{dir}/#{TAGS_FILE} -L - 2>>/dev/null "
    cmd << '&' if run_in_background
    $stderr.print "[#{$0}] calling #{cmd}\n" if DEBUG_MODE
    system cmd
  else
    $stderr.print "[#{$0}] #{CTAGS} failed to write #{dir}/#{TAGS_FILE}\n"
  end
end

def install_hook(hook)
  if File.exists?(hook)
    $stderr.print "A file already exists at #{hook}, and will NOT be replaced.\n"
    return
  end
  
  print "Linking #{__FILE__} to #{hook}\n"
  %x{ln -s #{__FILE__}  #{hook}}
end

if ARGV.first == '-i'
  install
else
  run_tags Dir.pwd, HOOKS.include?(File.basename(__FILE__))
end
