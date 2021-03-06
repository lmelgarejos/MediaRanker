class WorksController < ApplicationController
  before_action :require_login, except: [:index]
  
  def index
    @works = Work.all
  end

  def new
    @work = Work.new
  end

  def new_movie
    @work = Work.new(category: "movie")
  end

  def new_book
    @work = Work.new(category: "book")
  end

  def new_album
    @work = Work.new(category: "album")
  end

  def create
    @work = Work.new(work_params)

    if @work.save
      redirect_to root_path
    else
      render :new, status: :bad_request
    end
  end

  def show
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
    end
  end

  def show_movies
    @movies = Work.where(category: "movie")

    if @movies.empty?
      head :not_found
    end
  end

  def show_books
    @books = Work.where(category: "book")

    if @books.empty?
      head :not_found
    end
  end

  def show_albums
    @albums = Work.where(category: "album")

    if @albums.empty?
      head :not_found
    else

    end
  end

  def edit
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
    end
  end

  def update
    @work = Work.find_by(id: params[:id])
    if @work.nil?
      head :not_found
    else
      @work.update_attributes(work_params)
      if @work.save
        redirect_to work_path(@work.id)
      else
        render :edit, status: :bad_request
      end
    end
  end

  def destroy
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
    else
      @work.destroy
      redirect_to works_path
    end
  end

  def vote
    @work = Work.find(params[:id])
    if Vote.where(user_id: session[:user_id], work_id: params[:id]).empty?
      Vote.create(user_id: session[:user_id], work_id: params[:id])
      flash[:success] = "Successfully voted"
    else
      flash[:failure] = "You can only vote for this #{@work.category} once."
    end
    redirect_to work_path
  end

  private

  def work_params
    return params.require(:work).permit(:title, :created_by, :published_year, :description, :category)
  end

end
