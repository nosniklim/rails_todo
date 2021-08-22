class UserController < ApplicationController
  def edit
    if params[:id].to_i != current_user.id
      redirect_to edit_user_path(current_user.id)
      return
    end
    @user = User.find_by(id: current_user.id)
  end

  def update
    @user = User.find_by(id: current_user.id)
    if @user.update(user_params)
      redirect_to :root
    else
      render action: :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name).merge(id: current_user.id)
  end
end
