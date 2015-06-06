class TagsController < ApplicationController
  #before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
       render :show, status: :created, location: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    if @tag.update(tag_params)
       render :show, status: :ok, location: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    
    render json: {success: true}
  end

  def search
    tag = Tag.find(params[:tag_id])
    questions = tag.questions.select(:title,:id,:upvotes,:downvotes,:created_at)

    questions_all = Array.new
    questions.each do |question|
      question_map = Hash.new
      question_map['question'] = question
      question_map['create_time'] = (question.created_at.to_f*1000).to_i 
      questions_all << question_map
    end
    
    render json: questions_all
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params[:tag]
    end
end
