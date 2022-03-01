#!/usr/bin/env ruby
# frozen_string_literal: true
require "./app/cart_app"

if ARGV.any?
	if ARGV.include?("--help") || ARGV.include?("-h")
		puts "Shopiby shopping cart platform - help"
		puts "-------------------------------------"
		puts
		puts "Usage: ruby shopiby.rb [options]"
		puts
		puts "options:"
		puts "--help, -h   'Shows this help guide'"
		puts
		puts "-------------------------------------"
	else
		puts "invalid option. Please see `ruby shopiby.rb --help` for guidance"
	end
else
	CartApp.new(ARGV).call
end
