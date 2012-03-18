class LinksController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :vote_up, :vote_down]
  
  def index
    @title = "New links"
    @links = Link.paginate(:page => params[:page])
  end

  def show
    @link = Link.find(params[:id])
    @title = @link.description
  end
  
  def new
    @link = Link.new
  end
  
  def create
    @link  = current_user.links.build(params[:link])
    if @link.save
      current_user.vote_for(@link)
      redirect_to links_path
    else
      render 'pages/home'
    end
  end
  
#       render :nothing => true, :status => 200  
  
  def vote_up
    @link = Link.find(params[:id])
    begin
      if current_user.voted_for?(@link)
        current_user.unvote_for(@link)
      else
        current_user.vote_exclusively_for(@link)
      end
      @link.update_hotness!
      respond_to do |format|
        format.js
        format.html {redirect_to :back}
      end
    rescue ActiveRecord::RecordInvalid
      render :nothing => true, :status => 404
    end
  end
  
  def vote_down
    @link = Link.find(params[:id])
    begin
      if current_user.voted_against?(@link)
        current_user.unvote_for(@link)
      else
        current_user.vote_exclusively_against(@link)
      end
      @link.update_hotness!
      respond_to do |format|
        format.js
        format.html {redirect_to :back}
      end
    rescue ActiveRecord::RecordInvalid
      render :nothing => true, :status => 404
    end
  end
end
