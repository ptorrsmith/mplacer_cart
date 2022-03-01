#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"

require_relative "product"
require_relative "cart"
require_relative "line_item"

class CartApp
  def initialize(args)
    if args.any?
      # Configure app with startup config arg values
      # Currently there are none
    end

    @products = []
    @cart = Cart.new
  end

  def call
    load_products
    load_product_quantity_discounts
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

    products_file = File.open("./data/products.json")
    @json_products = JSON.load(products_file)
    @products = @json_products.map { |j|
      product = Product.new(j)
    }

    # provide user feedback on progress
    faux_loading(@products.count)

    products_file.close
  end

  def load_product_quantity_discounts
    puts "=== Loading Product Discounts ==="

    # load the product discounts and assign them to the matching product
    product_discounts_file = File.open("./data/product_discounts.json")
    @json_product_discounts = JSON.load(product_discounts_file)
    @product_discounts = @json_product_discounts.map { |j|
      product_discount = ProductDiscount.new(j)
      # find the matching product
      product = @products.find { |p| p.uuid == product_discount.product_uuid }
      if product
        product.quantity_discounts << product_discount
      else
        # raise/log exception
        puts "Product Discount Exception: No matching product with ID #{product_discount.product_uuid}"
      end
    }

    # provide user feedback on progress
    faux_loading(@product_discounts.count)

    product_discounts_file.close

    puts
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
      show_options

      print ">> "
      input = STDIN.gets.chomp.strip

      if %w[c co checkout].include?(input.downcase)
        print "Please confirm ok to charge your card $#{"%.2f" % @cart.total} ... (y/n)"
        break if gets.chomp.downcase == "y"
        clear_screen
      else
        clear_screen
        if input.to_i.is_a? Numeric # product uuid
          product_id = input.to_i

          # confirm valid product
          product = @products.find { |p| p.uuid == product_id }
          if product
            puts "adding 1 x '#{product.name}'"

            @cart.add_to_cart(product = product, quantity = 1)
            sleep(1)

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
    puts "Your card has been charged $#{"%.2f" % @cart.total} and your goods"
    puts "  are being prepared for shipping."
    puts "-------------------------------------------------"
    puts "Have a great day - thank you for using Shopiby"
    puts "================================================="
  end

  def show_catalog
    puts "=================== CATALOG ==================="
    @products&.each { |product|
      puts "ID: #{product.uuid} - `#{product.name}` @ $#{"%.2f" % product.base_price}"
    }
    puts
  end

  def show_cart
    puts "===================   CART   =================="

    if @cart.line_items.any?
      puts "YOUR CART CONTENTS:"
      @cart.line_items.each { |line_item|
        puts "ID: #{line_item.product_id} - '#{line_item.name}' x #{line_item.quantity} @ $#{"%.2f" % line_item.unit_price} = $#{line_item.line_item_total}"
      }
      puts "----------------------------------"
      puts "Subtotal: $#{"%.2f" % @cart.subtotal}"
      puts "less discount: $#{"%.2f" % @cart.discount} (#{@cart.subtotal > 0 ? "%.0f" % (@cart.discount / @cart.subtotal * 100) : "0"}%)"
      puts "----------------------------------"
      puts "Total: $#{"%.2f" % @cart.total}"
      puts "=================================="
    else
      puts " Your cart is empty.  Add something to your cart."
    end
    puts
  end

  def show_options
    puts "===================   SHOP   =================="
    puts ">> Enter item ID to add to cart. 'c' to checkout and pay <<"
  end

  def faux_loading(product_count)
    (10 * product_count).times do
      print "."
      sleep(0.02)
    end
    puts
  end
end
