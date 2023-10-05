class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    """sort_key = params[:sort_key] || session[:sort_key]
    case sort
    when 'title'
      ordering,@title_header = {:title => :asc}, 'bg-warning hilite'
    when 'release_date'
      ordering,@date_header = {:release_date => :asc}, 'bg-warning hilite'
    end
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings] || session[:ratings] || {}

    if @ratings_to_show == {}
      @ratings_to_show = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort_key] != session[:sort_key] or params[:ratings] != session[:ratings]
      session[:sort] = sort_key
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
    """
    if not params.has_key?(:home)
      if params.has_key?(:check)
        session[:ratings]=params[:ratings]
      end
    end
    if params[:sort_key]!=nil
      session[:sort_key]=params[:sort_key]
      #redirect_to movies_path
      #@css_class_2='.bg_warning'
    end
    @sort_column=session[:sort_key]
    @all_ratings = Movie.all_ratings
    if session[:ratings]==nil
      @ratings_to_show=@all_ratings
    else
      @ratings_to_show = session[:ratings].keys
      #redirect_to movies_path
    end
    #@ratings_to_show = params[:ratings].keys
    if session[:sort_key]!=params[:sort_key] or session[:ratings]!=params[:ratings]
      redirect_to movies_path(sort_key: session[:sort_key], ratings: session[:ratings])
      return
    end
    @movies = Movie.with_ratings(@ratings_to_show,session[:sort_key])
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
