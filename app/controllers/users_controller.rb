class UsersController < ApplicationController
	before_filter :authenticate_user!, only: [:destroy]
	before_filter :admin_user

  def index
  	@users = User.paginate(page: params[:page])
  end

  def destroy
  	User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private
  	def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
