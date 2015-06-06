class AnswersController < ApplicationController
  # before_action :set_answer, only: [:show, :edit, :update, :destroy]
    before_action :check_auth_token, only: [:update, :destroy, :create]
  # GET /answers
  # GET /answers.json
  def index
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    answer = Answer.new(content: params[:content], upvotes: 0, downvotes:0, user_id: params[:user_id], question_id: params[:question_id])
  
    if answer.save
      render json: {answer: answer, create_time: (answer.created_at.to_f * 1000).to_i, success: true}
    else
      render json: @answer.errors, success: false
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    answer = Answer.find(params[:answer_id])
    if answer.update(content: params[:content])
      render json: {answer: answer, success: true} 
    else
      render json: @answer.errors, success: false 
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    answer = Answer.find(params[:answer_id])
    answer.destroy
    
    render json: {success: true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params[:answer]
    end

    def check_auth_token
      user = User.find_by_name(params[:username])
      unless user.auth_token == params[:auth_token]
        render json: {success: false}
      end
    end
end
