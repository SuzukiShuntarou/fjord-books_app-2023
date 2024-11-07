# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:alice_report)
    visit root_path
    assert_selector 'h2', text: 'ログイン'
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting reports index' do
    visit reports_path
    assert_selector 'h1', text: '日報の一覧'

    assert_text '初めての日報'
    assert_text 'こんにちは！'
    assert_text 'Alice'
    assert_text '2020/12/31'

    assert_text 'ボブ日報'
    assert_text 'おはよう！'
    assert_text 'bob@example.com'
    assert_text '2021/01/01'
  end

  test 'should create report' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
    click_on '日報の新規作成'

    fill_in 'タイトル', with: '2日目'
    fill_in '内容', with: '2日目の日報です。'
    click_button '登録する'

    assert_text '日報が作成されました。'
    assert_text '2日目'
    assert_text '2日目の日報です。'
    assert_text 'Alice'
    assert_text I18n.l(Time.zone.now.to_date)
  end

  test 'should update report' do
    visit report_url(@report)
    assert_selector 'h1', text: '日報の詳細'
    click_on 'この日報を編集'

    fill_in 'タイトル', with: '1日目'
    fill_in '内容', with: '初日報です。'
    click_button '更新する'

    assert_text '日報が更新されました。'
    visit report_path(@report)

    assert_text '1日目'
    assert_text '初日報です。'
    assert_text 'Alice'
    assert_text '2020/12/31'

    refute_text '初めての日報'
    refute_text 'こんにちは！'
    refute_text I18n.l(Time.zone.now.to_date)
  end

  test 'should destroy report' do
    visit report_url(@report)
    assert_selector 'h1', text: '日報の詳細'
    click_button 'この日報を削除'

    assert_text '日報が削除されました。'

    refute_text '初めての日報'
    refute_text 'こんにちは！'

    assert_text 'ボブ日報'
    assert_text 'おはよう！'
  end
end
