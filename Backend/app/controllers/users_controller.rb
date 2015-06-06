class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  require 'digest'

  # GET /users
  # GET /users.json
   def login
    user = User.where(:username => params[:username]).first
    user = user.authenticate(params[:password])
    success = true
    if user
      md5_hash = Digest::SHA2.hexdigest(params[:username])
      user.auth_token = md5_hash
      user.save
    else
      success = false
    end

    if success
      render json: {success:true, auth_token:md5_hash} 
    else
     render json: {success:false} 
    end
  end

  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    # require 'pry'
    # binding.pry
    user = User.where(:username => params[:username]).first
    success = true
    if user
      success = false
    else
      success = true
      md5_hash = Digest::SHA2.hexdigest(params[:username])
      user = User.create(username:params[:username], email:params[:email], auth_token:md5_hash, password:params[:password])
    end

    if success
      render json: {success:true, auth_token:md5_hash, user_id: user.id} 
    else
      render json: {success:false} 
    end
  end

  def logout
    user = User.where(:username => params[:username], :auth_token => params[:auth_token]).first
    if(user)
      user.auth_token = ""
      user.save
      render json: {success:true}
    else
      render json: {success:false} 
    end
  end

 

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    render json: {success: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
