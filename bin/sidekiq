#!/usr/bin/env ruby
$:.unshift File.expand_path File.join File.dirname(__FILE__), '../../cryptcheck/lib'
require 'rubygems'
require 'bundler/setup'

$TESTING = false
$CELLULOID_DEBUG = false

require 'sidekiq/cli'

begin
	cli = Sidekiq::CLI.instance
	cli.parse
	cli.run
rescue => e
	raise e if $DEBUG
	STDERR.puts e.message
	STDERR.puts e.backtrace.join("\n")
	exit 1
end
