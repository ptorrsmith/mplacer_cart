#!/usr/bin/env ruby
# frozen_string_literal: true

require "./app/product"
require "./app/cart"

RSpec.describe "Cart" do
  let(:cart) { Cart.new }
  let(:product) { Product.new({"uuid" => 99, "name" => "Widget", "price" => "100.00 "}) }
  let(:poduct_discount_for_2) { ProductDiscount.new({"product_uuid" => 99, "unit_price" => "90.00", "qty_threshold" => "2"}) }
  let(:poduct_discount_for_3) { ProductDiscount.new({"product_uuid" => 99, "unit_price" => "80.00", "qty_threshold" => "3"}) }

  before(:each) do
    product.quantity_discounts << poduct_discount_for_2
    product.quantity_discounts << poduct_discount_for_3
  end

  context "The cart is empty" do
    it "has empty zero values" do
      subtotal = cart.subtotal
      discount = cart.discount
      total = cart.total

      expect(subtotal).to eq(0)
      expect(discount).to eq(0)
      expect(total).to eq(0)
    end
  end

  context "an item is added to the cart" do
    it "returns the correct total, discount and subtotal" do
      cart.add_to_cart(product, 1)

      subtotal = cart.subtotal
      discount = cart.discount
      total = cart.total

      expect(subtotal).to eq(100)
      expect(discount).to eq(15)
      expect(total).to eq(85)
    end
  end

  context "another identical item is added to the cart" do
    it "returns the correct total, discount and subtotal" do
      cart.add_to_cart(product, 1)
      cart.add_to_cart(product, 1)

      subtotal = cart.subtotal
      discount = cart.discount
      total = cart.total

      expect(subtotal).to eq(180)
      expect(discount).to eq(36)
      expect(total).to eq(144)
    end

    it "should have a single line_item with a quantity of 2" do
      cart.add_to_cart(product, 1)
      cart.add_to_cart(product, 1)
      expect(cart.line_items.count).to eq(1)
      expect(cart.line_items.first.quantity).to eq(2)
    end
  end

  context "a third identical item is added to the cart to go over a second discount quantity threshold" do
    it "returns the correct total, discount and subtotal" do
      cart.add_to_cart(product, 1)
      cart.add_to_cart(product, 1)
      cart.add_to_cart(product, 1)

      subtotal = cart.subtotal
      discount = cart.discount
      total = cart.total

      expect(subtotal).to eq(240)
      expect(discount).to eq(48)
      expect(total).to eq(192)
    end

    it "should have a single line_item with a quantity of 3" do
      cart.add_to_cart(product, 1)
      cart.add_to_cart(product, 1)
      cart.add_to_cart(product, 1)
      expect(cart.line_items.count).to eq(1)
      expect(cart.line_items.first.quantity).to eq(3)
    end
  end
end
