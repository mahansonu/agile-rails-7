require "test_helper"

class SupportMailboxTest < ActionMailbox::TestCase
  # test "receive mail" do
  #   receive_inbound_email_from_mail \
  #     to: '"someone" <someone@example.com>',
  #     from: '"else" <else@example.com>',
  #     subject: "Hello world!",
  #     body: "Hello?"
  # end

  test "we create a SupportRequest when we get a support mail" do
    receive_inbound_email_from_mail(
      to: 'support@example.com',
      from: 'test@test.com',
      subject: 'How are you?',
      body: 'I am great!'
    )

    support_request = SupportRequest.last
    assert_equal 'test@test.com', support_request.email
    assert_equal 'How are you?', support_request.subject
    assert_equal 'I am great!', support_request.body
    assert_nil support_request.order
  end

  test "we create a SupportRequest with the most recent order" do
    recent_one = orders(:one)
    another_one = orders(:another_one)
    non_customer = orders(:other_customer)

    receive_inbound_email_from_mail(
      to: 'support@example.com',
      from: 'sonu@test.com',
      subject: 'for recent order',
      body: 'for recent order'
    )
    support_request = SupportRequest.last
    assert_equal 'sonu@test.com', support_request.email
    assert_equal 'for recent order', support_request.subject
    assert_equal 'for recent order', support_request.body
    assert_equal recent_one, support_request.order
  end
end
