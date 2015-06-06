class UpDownAnswerController < ApplicationController
	
  before_action :check_auth_token, only [:create, :update, :destroy]

  def ans_upvote
    success = false
    updown_query = UpDownAnswer.where(:user_id => params[:user_id], :answer_id => params[:answer_id]).first
    if (updown_query)
      if(updown_query.down)
        updown_query.down = false
        updown_query.up = true
        updown_query.save
        success = true
        q = Answer.find(params[:answer_id])
        q.downvotes = q.downvotes-1
        q.upvotes = q.upvotes+1
        q.save
      else
        success = false
      end

    else
      UpDownAnswer.create(user_id:params[:user_id], answer_id:params[:answer_id], up:true, down:false)
      success = true
      q = Answer.find(params[:answer_id])
      q.upvotes = q.upvotes+1
      q.save
    end

    render json: {"success": success}

  end

  def ans_downvote
    success = false
    updown_query = UpDownAnswer.where(:user_id => params[:user_id], :answer_id => params[:answer_id]).first
    if (updown_query)
      if(updown_query.up)
        updown_query.up = false
        updown_query.down = true
        updown_query.save
        success = true
        q = Answer.find(params[:answer_id])
        q.upvotes = q.upvotes-1
        q.downvotes = q.downvotes+1
        q.save
      else
        success = false
      end

    else
      UpDownAnswer.create(user_id:params[:user_id], answer_id:params[:answer_id], up:false, down:true)
      success = true
      q = Answer.find(params[:answer_id])
      q.downvotes = q.downvotes+1
      q.save
    end

    render json: {"success": success}

  end
  private
  def check_auth_token
      user = User.find_by_name(params[:username])
      unless user.auth_token == params[:auth_token]
        render json: {success: false}
      end
    end

end
