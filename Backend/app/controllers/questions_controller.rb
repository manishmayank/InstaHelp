class QuestionsController < ApplicationController
  
  before_action :check_auth_token, only: [:create, :update, :destroy]
  
  def index
    # TODO :- URL's parent's questions

    questions = Question.where("url=?",params[:url]).paginate(:page => params[:page_num], :per_page => 10).order('difference DESC').select(:title,:id,:upvotes,:downvotes,:created_at)
    questions_all = Array.new
    questions.each do |question|
      question_map = Hash.new
      question_map['question'] = question
      question_map['create_time'] = (question.created_at.to_f*1000).to_i 
      questions_all << question_map
    end

    render json: questions_all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    question_id = params[:question_id]

    question = Question.find(question_id)
    answers = question.answers
    comments = question.comments
    all_comments = Array.new
    answer_list = Array.new
    answers.each do |answer|
      answer_map = Hash.new
      answer_map["answer"] = answer
      answer_map["comments"] = answer.comments
      answer_list << answer_map
    end

    tags = question.tags

    actual_tags = Array.new

    tags.each do |tag|
      tag_map = Hash.new
      tag_map["name"] = tag.name
      tag_map["id"] = tag.id
      actual_tags << tag_map
    end

    
    render json: {question: question, tags: actual_tags, create_time: (question.created_at.to_f * 1000).to_i, question_comments: comments, answers: answer_list}
  
  end

  # GET /questions/new
  def new
    question = Question.new
    respond_to do |format|
      format.json {render json: question}
    end
  end

  # GET /questions/1/edit
  def edit
    question = Question.find(params[:question_id])
    
    render json: question
    
  end

  # POST /questions
  # POST /questions.json
  def create
    question = Question.new(content: params[:content], title: params[:title], url: params[:url], upvotes: 0, downvotes: 0, difference: 0, user_id: params[:user_id])

    if question.save
       render json: {success: true, question: question, create_time: (question.created_at.to_f * 1000).to_i}
    else
       render json: {success: false} 
    end

    tag_list = Array.new

    tag_list << params[:tag1]
    tag_list << params[:tag2]
    tag_list << params[:tag3]
    tag_list << params[:tag4]
    tag_list << params[:tag5]

    actual_tag_list = Array.new

    tag_list.each do |tag|
      t = Tag.find_by_name(tag)
      unless t
        t = Tag.create(name: tag)
      end
      actual_tag_list << t
    end
    question.tags << actual_tag_list
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    question = Question.find(params[:question_id])
    if question.update(content: params[:content], title: params[:title])
      question.save
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    question = Question.find(params[:question_id])
    question.destroy
    
    render json: {success: true}
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def question_params
    #   params[:question, :]
    # end

    def check_auth_token
      user = User.find_by_username(params[:username])
      unless user.auth_token == params[:auth_token]
        render json: {success: false}
      end
    end
end
