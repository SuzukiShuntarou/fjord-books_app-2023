# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @target_user = users(:alice)
    @other_user = users(:bob)
    @report = reports(:alice_report)
  end

  test 'should be able to edit' do
    assert @report.editable?(@target_user)
  end

  test 'should not be able to edit' do
    assert_not @report.editable?(@other_user)
  end

  test 'should convert DateClass' do
    assert_equal @report[:created_at].to_date, @report.created_on
  end
end
