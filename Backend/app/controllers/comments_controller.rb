class CommentsController < ApplicationController
  # before_action :set_comment, only: [:show, :edit, :update, :destroy]
    before_action :check_auth_token, only [:create, :update, :destroy]
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    comment = Comment.new(content: params[:content], user_id: params[:user_id], question_id: params[:question_id], answer_id: params[:answer_id])
  
    if comment.save
       render json: {comment: comment, create_time: (comment.created_at.to_f * 1000).to_i, success: true} 
    else
       render json: comment.errors, success: false 
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    comment = Comment.find(params[:comment_id])
    
    if comment.update(content: params[:content])
      render json: {comment: comment, success: true}
    else
      render json: comment.errors, success: false
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    comment = Comment.find(params[:comment_id])
    comment.destroy
    render json: {success: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params[:comment]
    end

    def check_auth_token
      user = User.find_by_name(params[:username])
      unless user.auth_token == params[:auth_token]
        render json: {success: false}
      end
    end
end
