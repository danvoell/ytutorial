class TutorialsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show, :tagged]
  before_filter :find_tutorial, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_tutorial, only: [:edit, :update, :destroy]
  
  def index
    @tutorials = Tutorial.all
    @tutorials = Tutorial.paginate(:page => params[:page], :per_page => 8, :order => 'id DESC')
  end
  
  def show
    @tutorial = Tutorial.find(params[:id])
  end
  
  def new
    @tutorial = Tutorial.new
  end
  
def tagged
  if params[:tag].present? 
    @tutorials = Tutorial.tagged_with(params[:tag])
  else 
    @tutorials = Tutorial.postall
  end  
end

def vote
  value = params[:type] == "up" ? 1 : -1
  @tutorial = Tutorial.find(params[:id])
  @tutorial.add_or_update_evaluation(:votes, value, current_user)
  redirect_to :back, notice: "Congratulations, you did it! Please spread the word about your momentous achievement to your social stratosphere. We are a free tool and don't have a marketing budget, each share might help another developer in training get unstuck."
end


  def create
    @tutorial = Tutorial.new(params[:tutorial])
    @tutorial.user = current_user
    if @tutorial.save
      redirect_to edit_tutorial_path(@tutorial), notice: "Tutorial created!"
    else
      flash.now[:alert] = "Oops, there was a problem: #{@tutorial.all_errors}"
      render :new
    end
  end
  
  def edit
    @tutorial.steps.build(content: "")
  end
  
  def update
    @tutorial.steps.destroy_all
    steps = params[:tutorial].delete(:step) || []
    steps = steps.to_a.collect{|k, v| v }.compact if steps.present?
    steps.each do |step|
      next if step['content'].empty?
      @tutorial.steps.create(step)
    end
    
    if @tutorial.update_attributes(params[:tutorial])
      
      redirect_to edit_tutorial_path(@tutorial), notice: "Tutorial saved!"
    else
      flash.now[:alert] = "Oops, there was a problem: #{@tutorial.all_errors}"
      render :edit
    end
  end
  
  def destroy
    @tutorial.destroy
    redirect_to tutorials_path, notice: "Tutorial deleted."
  end
  
  private
    def find_tutorial
      @tutorial = Tutorial.find_by_id(params[:id])
      redirect_to tutorials_path, alert: "Couldn't find that tutorial" unless @tutorial.present?
    end
    
    def authenticate_tutorial
      redirect_to tutorials_path, alert: "You don't have permission to do that" unless @tutorial.editor?(current_user)
    end
end
