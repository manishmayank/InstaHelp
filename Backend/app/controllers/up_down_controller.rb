class UpDownController < ApplicationController

  before_action :check_auth_token, only [:create, :update, :destroy]
	def ques_upvote
    success = false

    updown_query = UpDown.where(:user_id => params[:user_id], :question_id => params[:question_id]).first
    if (updown_query)
      if(updown_query.down)
        updown_query.down = false
        updown_query.up = true
        updown_query.save
        success = true
        q = Question.find(params[:question_id])
        q.downvotes = q.downvotes-1
        q.upvotes = q.upvotes+1
        q.save
      else
        success = false
      end

    else
      UpDown.create(user_id:params[:user_id], question_id:params[:question_id], up:true, down:false)
      success = true
      q = Question.find(params[:question_id])
      q.upvotes = q.upvotes+1
      q.save
    end

    render json: {"success": success}

  end

  def ques_downvote
    success = false
    updown_query = UpDown.where(:user_id => params[:user_id], :question_id => params[:question_id]).first
    if (updown_query)
      if(updown_query.up)
        updown_query.up = false
        updown_query.down = true
        updown_query.save
        success = true
        q = Question.find(params[:question_id])
        q.upvotes = q.upvotes-1
        q.downvotes = q.downvotes+1
        q.save
      else
        success = false
      end

    else
      UpDown.create(user_id:params[:user_id], question_id:params[:question_id], up:false, down:true)
      success = true
      q = Question.find(params[:question_id])
      q.downvotes = q.downvotes+1
      q.save
    end

    render json: {"success": success}

  end

  private
    def check_auth_token
      user = User.find_by_username(params[:username])
      unless user.auth_token == params[:auth_token]
        render json: {success: false}
      end
    end

end
