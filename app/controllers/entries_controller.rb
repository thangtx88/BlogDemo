class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  # GET /entries
  # GET /entries.json
  def index
       @entry = Entry.paginate(page: params[:page])
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @comment = Comment.new
    @entry = Entry.find(params[:id])
    @comments = Comment.where("entry_id = ?", params[:id]).paginate(page: params[:page])
    @user = current_user
    if @entry.nil?
      flash[:danger] = 'Entry not found!'
      redirect_to request.referrer
    end
  end



  # POST /entries
  # POST /entries.json
 def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = "Entry created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end


  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
     if @entry.destroy
      flash[:success] = "Entry deleted"
       redirect_to root_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:title, :body)
    end

    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
end
