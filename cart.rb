#!/usr/bin/env ruby
# frozen_string_literal: true

# TODO: error handling, logging
# class CartError < StandardError
# end

class Cart
	attr_accessor :user_email, :line_items

	def initialize(user_email = 'customer@example.com')
		@user_email = user_email
		@line_items = []
		clear_cart
	end

	def subtotal
		@line_items.reduce(0.0) { |subtotal, li| subtotal + li.unit_price.to_f}
	end

	def discount
		# 10% off on total greater than $20
		# 15% off on total greater than $50
		# 20% off on total greater than $100
		case
		when subtotal > 100
			(subtotal * 0.2).round(2)
		when subtotal > 50
			(subtotal * 0.15).round(2)
		when subtotal > 20
			(subtotal * 0.10).round(2)
		else
			0
		end
	end

	def total
		subtotal - discount
	end

	def clear_cart
		@line_items = []
		@subtotal, @discount, @total = 0.0
	end
end
