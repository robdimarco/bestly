class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :destroy]
  before_filter :admin_user, :only => :destroy
  
  def index
    @title = "All users"
    @users = User.all
  end
  
  def show
      @user = User.find(params[:id])
      @links = @user.links.paginate(:page => params[:page])
      @title = @user.username
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to root_path
  end
  
  private
  
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
