# This file is used by Rack-based servers to start the application.
$:.unshift File.expand_path File.join File.dirname(__FILE__), '../../cryptcheck/lib'
require 'rubygems'
require 'bundler/setup'

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
