# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  def index
    @reports = Report.order(:id).page(params[:page]).per(3) # 動作確認
    # @reports = Report.order(:id).page(params[:page])
  end

  def show; end

  def new
    @report = Report.new
  end

  def edit; end

  def create
    @report = current_user.reports.build(report_params)
    respond_to do |format|
      if @report.save
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if correct_user?
      respond_to do |format|
        if @report.update(report_params)
          format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    else
      flash[:danger] = t('errors.messages.wrong_user', name: Report.model_name.human)
      redirect_to reports_path
    end
  end

  def destroy
    if correct_user?
      @report.destroy

      respond_to do |format|
        format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
      end
    else
      flash[:danger] = t('errors.messages.wrong_user', name: Report.model_name.human)
      redirect_to reports_path
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
