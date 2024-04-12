ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module AuthenticationHelper
  def login_as(user)
    if respond_to? :visit
      puts 'in visit'
      visit login_url
      fill_in :name, with: user.name
      fill_in :password, with: 'secret'
      click_on 'Login'
    else
      post login_url, params: {name: user.name, password: 'secret'}
    end
  end

  def logout
    delete logout_url
  end

  def setup
    login_as users(:one)
  end
end

class ActionDispatch::IntegrationTest
  include AuthenticationHelper
end

class ActionDispatch::SystemTestCase
  include AuthenticationHelper
end
