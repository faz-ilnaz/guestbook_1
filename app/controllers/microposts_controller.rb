class MicropostsController < ApplicationController
	before_filter :authenticate_user!, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @microposts = []
      render 'microposts/show'
    end
  end

  def show
  	@micropost = current_user.microposts.build if user_signed_in?
    @microposts = Micropost.paginate(page: params[:page])
  end

  def destroy
  	current_user.microposts.find_by_id(params[:id]).destroy
    redirect_to root_url
  end

  private

  	def micropost_params
      params.require(:micropost).permit(:user_id, :content)
    end
end