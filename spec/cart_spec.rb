#!/usr/bin/env ruby
# frozen_string_literal: true

# require 'pry' # not for production or test

require './app/product'
require './app/cart'

RSpec.describe 'Cart' do
  let (:cart) { Cart.new }
  let (:product) { Product.new( { "uuid"=> 99, "name"=> "Widget", "price"=>"100.00 "} ) }

  context 'The cart is empty' do
    it 'has empty zero values' do
      subtotal = cart.subtotal
      discount = cart.discount
      total = cart.total

      expect(subtotal).to eq(0)
      expect(discount).to eq(0)
      expect(total).to eq(0)
    end
  end

  context 'an item is added to the cart' do
    it 'returns the correct total, discount and subtotal' do
      cart.add_to_cart(product, 1)

      subtotal = cart.subtotal
      discount = cart.discount
      total = cart.total

      expect(subtotal).to eq(100)
      expect(discount).to eq(15)
      expect(total).to eq(85)
    end
  end

  context 'another identical item is added to the cart' do
    it 'returns the correct total, discount and subtotal' do
      cart.add_to_cart(product, 1)
      cart.add_to_cart(product, 1)

      subtotal = cart.subtotal
      discount = cart.discount
      total = cart.total

      expect(subtotal).to eq(200)
      expect(discount).to eq(40)
      expect(total).to eq(160)
    end

    it 'should have a single line_item with a quantity of 2' do
      cart.add_to_cart(product, 1)
      cart.add_to_cart(product, 1)
      expect(cart.line_items.count).to eq(1)
      expect(cart.line_items.first.quantity).to eq(2)
    end
  end
end
