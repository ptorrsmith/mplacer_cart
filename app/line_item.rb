#!/usr/bin/env ruby
# frozen_string_literal: true

class LineItem
	attr_accessor :product_id, :quantity, :unit_price, :name # could also include discount_percent for each line item

	def initialize(product_id, quantity, unit_price, name)
		@product_id = product_id
		@quantity = quantity
		@unit_price = unit_price
		@name = name
	end

	def line_item_total
		@unit_price * @quantity
	end
end
