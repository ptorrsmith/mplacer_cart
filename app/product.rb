#!/usr/bin/env ruby
# frozen_string_literal: true

class Product
	attr_accessor :uuid, :name, :base_price, :quantity_discounts

	# has_many: product_discounts

	def initialize(json)
		@uuid = json["uuid"]
		@name = json["name"]
		@base_price = json["price"].to_f
		@quantity_discounts = [] # a collection of product_discounts for this product UUID. May have multiple tiers
	end

	def unit_price(quantity = 1)
		if quantity == 1
			return @base_price
		else
			if @quantity_discounts.any?
				# sort from highest qty_threshold to lowest, then get first that is less than or equal to the quantity
				quantity_discounts_sorted =  @quantity_discounts.sort{ |a, b| a.qty_threshold <=> b.qty_threshold }.reverse
				quantity_discount = quantity_discounts_sorted.find{ |d| d.qty_threshold <= quantity }
				if quantity_discount
					return quantity_discount.unit_price
				else
					return @base_price
				end
			else
				return @base_price
			end
		end
	end
end
