#!/usr/bin/env ruby
# frozen_string_literal: true

# TODO: error handling, logging
# class CartError < StandardError
# end

# require 'pry' # not for production or test

require_relative 'line_item'

class Cart
	attr_accessor :user_email, :line_items

	def initialize(user_email = 'customer@example.com')
		@user_email = user_email
		@line_items = []
		clear_cart
	end

	def subtotal
		@line_items.reduce(0.0) { |subtotal, li| subtotal + li.line_item_total}
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

	def add_to_cart(product, quantity)
		# If cart already has that product, increment by quantity
		# else create line_item and addd to cart line_items

		existing_product_line_item = @line_items.find { |li| li.product_id == product.uuid}

		if existing_product_line_item
			existing_product_line_item.quantity += quantity
		else
			line_item = LineItem.new(product_id = product.uuid, quantity=1, unit_price=product.price, name=product.name)
			@line_items << line_item
		end
	end

	def clear_cart
		@line_items = []
		@subtotal, @discount, @total = 0.0
	end
end
