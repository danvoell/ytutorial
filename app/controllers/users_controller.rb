class UsersController < Devise::RegistrationsController

def show
  @user = User.find(params[:id])
  @tutorials = @user.tutorials
  # raise @user.inspect
  @search = params[:search]  
   @tutorials = Tutorial.search(@search) 

end

end
