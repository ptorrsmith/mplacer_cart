#!/usr/bin/env ruby
# frozen_string_literal: true

# require 'pry' # not for production or test env

require 'json'

require_relative "product"
require_relative "cart"
require_relative "line_item"

class CartApp
	def initialize(args)
		# TODO handle --help, -h args
		@products = []
		@cart = Cart.new
	end

	def call
		load_products
		welcome
		shop
		finish
	end

private
	def clear_screen
		system("clear")
	end

	def load_products
		clear_screen
		puts "=== Fetching available Products ==="

		products_file = File.open("products.json")
		@json_products = JSON.load(products_file)
		@products = @json_products.map { |j|
			product = Product.new(j)
		}

		# provide user feedback on progress
		faux_loading(@products.count)

		products_file.close

		clear_screen
	end

	def welcome
		puts "=================================================================="
		puts "Welcome to Shopiby - We've got it all because they've got it all!"
		puts "=================================================================="
		puts
	end

	def shop
		loop do
			show_cart
			show_catalog
			show_menu
			print '>> '
			input = STDIN.gets.chomp.strip
			if %w[q quit].include?(input.downcase)
				print 'Quitting... are you sure? (y/n)'
				break if gets.chomp.downcase == 'y'
				clear_screen
			else
				clear_screen
				# puts "You entered '#{input.strip}'"
				if input.to_i.is_a? Numeric # product uuid
					# find product
					product = @products.find { |p| p.uuid == input.to_i }
					if product
						puts "adding 1 x '#{product.name}'"
						line_item = LineItem.new(product_id = product.uuid, quantity=1, unit_price=product.price, name=product.name)
						@cart.line_items << line_item
						sleep(1.5)
						clear_screen
						puts "added 1 x '#{product.name}'"
					else
						puts "No product with ID #{input}"
						sleep(1)
					end
				end
			end
		end
	end

	def finish
		clear_screen
		puts "================================================="
		puts "Have a great day - thank you for using Shopiby"
		puts "================================================="
	end

	def show_catalog
		puts "=================== CATALOG ==================="
		@products&.each { |product|
			puts "ID: #{product.uuid} - `#{product.name}` @ $#{product.price}"
		}
		puts
	end

	def show_cart
		puts "===================   CART   =================="

		unless @cart.line_items.any?
			puts " Your cart is empty.  Add something to your cart."
		else
			puts "YOUR CART CONTENTS:"
			@cart.line_items.each { |line_item|
				puts "ID: #{line_item.product_id} - '#{line_item.name}' x #{line_item.quantity} @ $#{line_item.unit_price} = $#{line_item.line_item_total}"
			}
			puts "Subtotal: $#{'%.2f' % @cart.subtotal}"
			puts "less discount: $#{'%.2f' % @cart.discount} (#{@cart.subtotal > 0 ? '%.0f' % (@cart.discount/@cart.subtotal * 100) : '0'}%)"
			puts "----------------------------------"
			puts "Total: $#{'%.2f' % @cart.total}"
			puts "=================================="
		end
		puts
	end

	def show_menu
		puts "===================   SHOP   =================="
		puts ">> Enter item number. 'q' to quit <<"
	end

	def faux_loading(product_count)
		(10 * product_count).times do
			print '.'
			sleep(0.02)
		end
		puts
	end
end
