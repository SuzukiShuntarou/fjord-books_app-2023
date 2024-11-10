# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]
  REPORTS_URI = 'http://127.0.0.1:3000/reports/'

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mentioned_reports = @report.mentioned_reports
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    begin
      ActiveRecord::Base.transaction do
        @report.save!
        create_mentions(@report)
      end
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end
  end

  def update
    ActiveRecord::Base.transaction do
      @report.update!(report_params)
      destroy_mentions(@report)
      create_mentions(@report)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    rescue ActiveRecord::RecordInvalid
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def create_mentions(report)
    mentioned_ids = extract_mentioned_ids(extract_urls(report)).map(&:to_i) - report.mentioning_reports.ids
    mentioned_ids.each do |id|
      Mention.create!(mentioning_id: report.id, mentioned_id: id)
    end
  end

  def destroy_mentions(report)
    mentioned_ids = extract_mentioned_ids(extract_urls(report))
    Mention.where(mentioning_id: report.id).where.not(mentioned_id: mentioned_ids).destroy_all
  end

  def extract_urls(report)
    report.content.scan(%r{http://127\.0\.0\.1:3000/reports/\d+}).to_s
  end

  def extract_mentioned_ids(content_url)
    urls = URI.extract(content_url, ['http']).uniq
    urls.map { |url| url.split(REPORTS_URI)[1] }
  end
end
