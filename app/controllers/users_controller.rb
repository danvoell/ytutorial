class UsersController < Devise::RegistrationsController

def show
  @user = User.find(params[:id])
  @tutorials = @user.tutorials
  # raise @user.inspect

end

end
