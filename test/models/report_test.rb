# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @target_user = users(:alice)
    @other_user = users(:bob)
    @report = reports(:alice_report)
  end

  test 'should be able to edit' do
    assert_equal true, @report.editable?(@target_user)
  end

  test 'should not be able to edit' do
    assert_not_equal true, @report.editable?(@other_user)
  end

  test 'should convert DateClass' do
    assert_equal Date, @report.created_on.class
  end

  test 'should save mentions' do
    new_report = @other_user.reports.new
    new_report.title = '参考になりました！'
    new_report.content = "参考日報 http://localhost:3000/reports/#{@report.id}"
    new_report.save
    assert_equal @report.id, new_report.mentioning_reports.first.id
  end
end
