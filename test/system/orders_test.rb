require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  setup do
    @order = orders(:one)
  end

  test "check dynamic fields" do
    visit store_index_url
    click_on "Add to cart", match: :first
    click_on "Checkout"

    assert has_no_field? 'Account number'
    assert has_no_field? 'Routing number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_no_field? 'Po number'

    select 'Check', from: 'Pay type'

    assert has_field? 'Account number'
    assert has_field? 'Routing number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_no_field? 'Po number'

    select 'Credit card', from: 'Pay type'
    assert has_no_field? 'Account number'
    assert has_no_field? 'Routing number'
    assert has_field? 'Credit card number'
    assert has_field? 'Expiration date'
    assert has_no_field? 'Po number'

    select 'Purchase order', from: 'Pay type'
    assert has_no_field? 'Account number'
    assert has_no_field? 'Routing number'
    assert has_no_field? 'Credit card number'
    assert has_no_field? 'Expiration date'
    assert has_field? 'Po number'
  end

  test "check order and delivery" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url
    click_on 'Add to cart', match: :first
    click_on 'Checkout'

    fill_in 'Name', with: 'Dhanu Mahan'
    fill_in 'Address', with: '123 Main street'
    fill_in 'Email', with: 'dhanu@test.com'

    select 'Check', from: 'Pay type'
    fill_in 'Routing number', with: "1234567"
    fill_in 'Account number', with: '12345678'

    click_button 'Place Order'
    assert_text 'Thank you for your order'

    perform_enqueued_jobs
    perform_enqueued_jobs
    assert_performed_jobs 2

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal 'Dhanu Mahan', order.name
    assert_equal '123 Main street', order.address
    assert_equal 'Check', order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['dhanu@test.com'], mail.to
    assert_equal 'Sonu Mahan <sonu-mahan@test.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject 
  end

end
