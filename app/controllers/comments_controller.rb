class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

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
    @comment = Comment.new(parent_id: params[:parent_id])
    @parent = Comment.find(params[:parent_id])
    @entry = Entry.find(params[:entry_id])
    @user = current_user
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
      @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = 'Comment created!'
      if @parent.nil?
        redirect_to request.referer       
      else
        entry = @parent.entry
        redirect_to entry
      end
    else
      flash[:danger] = 'Something went wrong!'
      redirect_to request.referer
    end

  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if @comment.destroy
      flash[:success] = "Comment deleted"
      redirect_to request.referrer || root_url
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit :content, :user_id, :entry_id
    end
    def correct_user
      begin
        if current_user.admin?
          @comment = Comment.find(params[:id])
        else
          @comment = current_user.comments.find(params[:id])  
          if @comment.nil?
            handle_exception
          end
        end
      rescue Exception => e
          handle_exception
      end
    end
end
