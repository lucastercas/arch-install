#!/usr/bin/ruby

require 'yaml'

def read_yaml(path)
  file = File.read(path)
  content = YAML.load(file)
  return content
end

def print_header()
  puts('    _             _       ___           _        _ _ ')
  puts('   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |')
  puts("  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _\` | | |")
  puts(' / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |')
  puts('/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|')
end
