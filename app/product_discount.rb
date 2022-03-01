#!/usr/bin/env ruby
# frozen_string_literal: true

class ProductDiscount
  attr_accessor :product_uuid, :qty_threshold, :unit_price

  def initialize(json)
    @product_uuid = json["product_uuid"]
    @unit_price = json["unit_price"].to_f
    @qty_threshold = json["qty_threshold"].to_i
  end
end
