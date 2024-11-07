# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should return user email' do
    user = User.new(email: 'foo@example.com', name: '')
    assert_equal 'foo@example.com', user.name_or_email
  end

  test 'should return user name' do
    user = User.new(email: 'foo@example.com', name: 'Test')
    assert_equal 'Test', user.name_or_email
  end
end
