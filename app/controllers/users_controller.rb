class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.valid?
    if !@user.is_email?
      flash[:alert] = "Input a properly formatted email."
      redirect_to :back
    elsif @user.errors.messages[:email] != nil
      flash[:notice]= "That email " + @user.errors.messages[:email].first
      redirect_to :back
    elsif @user.save
      flash[:notice]= "Signup successful. Welcome to the site!"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:alert] = "There was a problem creating your account. Please try again."
      redirect_to :back
    end
  end

  def new
  end

  def show
    @users = User.all
    @user = User.find(params[:id])
    #hoto.order('created_at ASC')
    @my_users = []
    @users.each do |u|
      if @user.following?(u)
        @my_users.push(u)
      end
    end
    @my_users.push(@user)

    @tag = Tag.new
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :avatar)
  end


end
