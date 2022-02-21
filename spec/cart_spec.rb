require './app/line_item'
require './app/cart'

RSpec.describe 'Cart' do
  let (:cart) { Cart.new }
  let (:line_item) { LineItem.new(product_id = 123, quantity=1, unit_price="100", name="Widget")}

  it 'has empty zero values' do
    subtotal = cart.subtotal
    discount = cart.discount
    total = cart.total

    expect(subtotal).to eq(0)
    expect(discount).to eq(0)
    expect(total).to eq(0)
  end

  it 'returns the correct total, discount and subtotal' do
    cart.line_items << line_item

    subtotal = cart.subtotal
    discount = cart.discount
    total = cart.total

    expect(subtotal).to eq(100)
    expect(discount).to eq(15)
    expect(total).to eq(85)
  end

end
