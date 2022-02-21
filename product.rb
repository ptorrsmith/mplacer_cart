#!/usr/bin/env ruby
# frozen_string_literal: true

class Product
	attr_accessor :uuid, :name, :price

	def initialize(json)
		@uuid = json["uuid"]
		@name = json["name"]
		@price = json["price"]
	end
end
