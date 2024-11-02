# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

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
        create_mentions(@report) if @report.content.include?(REPORTS_URI)
      end
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end
  end

  def update
    before_report = @report
    begin
      ActiveRecord::Base.transaction do
        @report.update!(report_params)
        if @report.content.include?(REPORTS_URI) && before_report.mentioning_reports.empty?
          create_mentions(@report)
        elsif !@report.content.include?(REPORTS_URI)
          destroy_mentions(@report)
        else
          destroy_mentions(@report)
          create_mentions(@report)
        end
      end
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
end
