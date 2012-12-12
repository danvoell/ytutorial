class CommentsController < ApplicationController
  
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_comment, except: [:index, :new, :create]
  before_filter :authenticate_comment, only: [:edit, :update, :destroy]
  
  def index
  end
  
  def show
    redirect_to tutorial_path(@comment.tutorial)
  end
  
  def new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to tutorial_path(@comment.tutorial, step: @comment.step_index), notice: "Comment posted!"
    else
      redirect_to :back, alert: "Sorry, there was a problem. #{@comment.all_errors}"
    end
  end
  
  def edit
  end
  
  def update
    if @comment.update_attributes(params[:comment])
      redirect_to tutorial_path(@comment.tutorial, step: @comment.step_index), notice: "Comment updated!"
    else
      redirect_to :back, alert: "Sorry, there was a problem. #{@comment.all_errors}"
    end
  end
  
  def destroy
    @comment.destroy
    redirect_to tutorial_path(@comment.tutorial, step: @comment.step_index), notice: "Comment deleted."
  end
  
  private
    def find_comment
      @comment = Comment.find_by_id(params[:id])
      redirect_to :back, alert: "Sorry, couldn't find that comment" unless @comment.present?
    end
    
    def authenticate_comment
      redirect_to :back, alert: "You don't have permission to do that" unless @comment.editor?(current_user)
    end
  
end
