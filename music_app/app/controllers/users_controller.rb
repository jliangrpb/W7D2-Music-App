class UsersController < ApplicationRecord
    def create 
        @user = User.new(params.require(:user).permit(:email, :password))
        if @user.save!
            login!(@user)
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new 
        end
    end

    def new 
        @user = User.new 
        render :new 
    end

    def show 
        @user = User.find_by(id: params[:id])
        render :show 
    end
end