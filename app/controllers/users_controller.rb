class UsersController < ApplicationController
  before_action :verify_user_for_editing, only: [:edit, :update]

  def index
  end

  def edit
  end

  def create
    @loc = Location.find_or_create_by(loc_params)
    @user = User.new(reg_params)
    @user.location = @loc
    if @user.save
      session[:user_id] = @user.id
      redirect_to "/events"
    else
      flash[:error] = @user.errors.full_messages
      redirect_to "/"
    end
  end

  def update
    @loc = Location.find_or_create_by(loc_params)
    @user.update(edit_params)
    @user.update(location: @loc)
    redirect_to "/events"
  end

  def login
    @user = User.find_by_email(params[:user][:email]).try(:authenticate, params[:user][:password])
    if @user
      session[:user_id] = @user.id
      redirect_to "/events"
    else
      flash[:error] = ["Incorrect Email or Password"]
      redirect_to "/"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to "/"
  end

  private
  def reg_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
  def edit_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end
  def loc_params
    params.require(:user).require(:location).permit(:city, :state)
  end
  def verify_user_for_editing
    @user = User.find(session[:user_id]) if session.include?(:user_id)
    redirect_to "/events" unless @user && session[:user_id] == params[:id].to_i
  end
end
