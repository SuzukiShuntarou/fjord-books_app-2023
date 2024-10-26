# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: :destroy

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) if @comment.save
  end

  def destroy
    if correct_user?(@comment)
      @comment.destroy

      respond_to do |format|
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human) }
      end
    else
      flash[:danger] = t('errors.messages.wrong_user', name: Comment.model_name.human)
      redirect_to @commentable
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
