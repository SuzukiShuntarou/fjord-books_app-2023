# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @comment = Comment.new
    @comments = @report.comments
  end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if correct_user?(@report)
      if @report.update(report_params)
        redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:danger] = t('errors.messages.wrong_user', name: Report.model_name.human)
      redirect_to @report
    end
  end

  def destroy
    if correct_user?(@report)
      @report.destroy
      redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
    else
      flash[:danger] = t('errors.messages.wrong_user', name: Report.model_name.human)
      redirect_to @report
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :text)
  end
end
