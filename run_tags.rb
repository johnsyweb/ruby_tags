#!/usr/bin/env ruby
# encoding: utf-8
# -*-ruby-*-
# A script to run ctags on all .rb files in a project. Can be run on
# the current dir, called from a git callback, or install itself as a
# git post-merge and post-commit callback.

require 'yaml'

config_file = File.expand_path('~/.run_tags.yml')
config = File.file?(config_file) ? YAML.load_file(config_file) : {}
DEBUG_MODE = config['debug'] || false
CTAGS = config['ctags'] || `which ctags`.chomp
HOOKS = config['hooks'] || %w( post-merge post-commit post-checkout )
HOOKS_DIR = config['hooks_file'] || '.git/hooks'
TAGS_FILE = config['tags_file'] || 'TAGS'
CTAGS_FLAGS = config['ctags_flags'] || '-e'

def install
  unless File.writable?(HOOKS_DIR)
    $stderr.print(
      "The install option [-i] can only be used within a git repo; exiting.\n")
    exit 1
  end

  HOOKS.each { |hook| install_hook("#{HOOKS_DIR}/#{hook}") }
end

def run_tags(dir, run_in_background = false)
  if File.executable?(CTAGS) && File.writable?(dir)
    cmd = "find #{dir} -name \\\*.rb | #{CTAGS} #{CTAGS_FLAGS}"
    cmd << " -f #{dir}/#{TAGS_FILE} -L - 2>>/dev/null"
    cmd << ' &' if run_in_background
    $stderr.print "[#{$PROGRAM_NAME}] calling #{cmd}\n" if DEBUG_MODE
    system cmd
  else
    $stderr.print(
      "[#{$PROGRAM_NAME}] #{CTAGS} failed to write #{dir}/#{TAGS_FILE}\n")
  end
end

def install_hook(hook)
  if File.exists?(hook)
    $stderr.print(
      "A file already exists at #{hook}, and will NOT be replaced.\n")
    return
  end

  print "Linking #{__FILE__} to #{hook}\n"
  `ln -s #{__FILE__} #{hook}`
end

if ARGV.first == '-i'
  install
else
  run_tags Dir.pwd, HOOKS.include?(File.basename(__FILE__))
end
