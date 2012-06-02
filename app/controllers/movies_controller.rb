class MoviesController < ApplicationController
  # @@proxyUTC = 'http://proxyweb.utc.fr:3128';
  @@proxyUTC = nil;
  
  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all
	# @alloCineJson = JSON.parse(open("http://api.allocine.fr/rest/v3/movielist?partner=YW5kcm9pZC12M3M&count=25&filter=nowshowing&order=toprank&format=json").read)["feed"]
	@alloCineJson = JSON.parse(open("http://api.allocine.fr/rest/v3/movielist?partner=YW5kcm9pZC12M3M&count=40&filter=nowshowing&order=toprank&format=json&profile=small").read)["feed"]
	response = {}
	movies = []
	@alloCineJson["movie"].each{ |mv|
		movie=Movie.where(:alloCineCode => mv["code"]).first
		if !movie
			movie = Movie.create(:alloCineCode => mv["code"], :title=>mv["title"])
		end
		movieHash = {}
		movieHash["id"] = movie.id
		movieHash["code"] = movie["title"]
		movieHash["code"] = mv["title"]
		movieHash["title"] = mv["title"]
		movieHash["poster"] = mv["poster"]["href"]
		movies << movieHash
	}
	response["movies"] = movies

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: response }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
	# require 'net/http'
	require 'open-uri'
	require 'json'

    @movie = Movie.find(params[:id])
	response = {}
	@alloCineJson = JSON.parse(open("http://api.allocine.fr/rest/v3/movie?partner=YW5kcm9pZC12M3M&format=json&filter=movie&profile=small&code="+ @movie.alloCineCode.to_s, :proxy => @@proxyUTC).read)["movie"]
	response["title"]=@alloCineJson["title"]
	response["directors"]=@alloCineJson["castingShort"]["directors"]
	response["actors"]=@alloCineJson["castingShort"]["actors"]
	response["synopsisShort"]=@alloCineJson["synopsisShort"]
	response["releaseDate"]=@alloCineJson["release"]["releaseDate"]
	response["poster"]=@alloCineJson["poster"]["href"]
	response["trailer"]=@alloCineJson["trailer"]["href"]
	response["runtime"]=@alloCineJson["runtime"]
	

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: response }
    end
  end

  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end
  
  def like
	@user = User.find(params[:userId])
	@movie = Movie.find(params[:id])
	like = Like.create(:user => @user, :movie=> @movie)
	render :action => 'show'
  end
  
  def review
	@user = User.find(params[:userId])
	@movie = Movie.find(params[:id])
	review = Review.create(:user => @user, :movie=> @movie, :content => params[:textContent])
	render :action => 'show'
  end
  
end
