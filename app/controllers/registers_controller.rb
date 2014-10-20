class RegistersController < ApplicationController

  def index
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(reg_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def reg_params
      params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation)
    end

end
