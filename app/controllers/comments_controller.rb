# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit destroy update]

  def edit; end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @comments = @commentable.comments
      render_show_path
    end
  end

  def destroy
    if correct_user?(@comment)
      @comment.destroy
      redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      flash[:danger] = t('errors.messages.wrong_user', name: Comment.model_name.human)
      redirect_to @commentable
    end
  end

  def update
    if correct_user?(@comment)
      if @comment.update(comment_params)
        redirect_to @commentable, notice: t('controllers.common.notice_update', name: Comment.model_name.human)
      else
        render :edit, status: :unprocessable_entity
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
