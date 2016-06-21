require "net/http"
require "uri"
class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  # GET /restaurants
  # GET /restaurants.json
  def index
      # todo:
      # search each word: http://stackoverflow.com/questions/6337381/search-on-multiple-keywords-in-a-single-search-text-field-rails
      # search by relevance
      # autocomplete: https://rubygems.org/gems/autocomplete/versions/1.0.2
      # advance: https://www.youtube.com/watch?v=eUtUquKc2qQ
      # pg full text search: https://www.youtube.com/watch?v=pfZw6yErsX0
      
      # gem choice :
      # textacular
      @key = search_params[:key].present? ? search_params[:key] : ""
      @checkprice = search_params[:checkprice].present? ? search_params[:checkprice] : "false"
      @price = search_params[:price].present? ? search_params[:price] : "1"
      @checkrating = search_params[:checkrating].present? ? search_params[:checkrating] : "false"
      @rating = search_params[:rating].present? ? search_params[:rating] : "1"
      @category = search_params[:category].present? ? search_params[:category] : ""

      @restaurants = Restaurant.all
      
      # if has key to search for
      @restaurants = Restaurant.joins(:user).where("lower(name) LIKE ? OR lower(description) LIKE ? OR lower(rest_type) LIKE ? OR lower(city) LIKE ?", "%#{search_params[:key].downcase}%", "%#{search_params[:key].downcase}%", "%#{search_params[:key].downcase}%", "%#{search_params[:key].downcase}%") if search_params[:key].present?
      
      # if categories field is present
      @restaurants = @restaurants.where("lower(rest_type) LIKE ?","%#{search_params[:category].downcase}%") if search_params[:category].present?
      # if rating field is present
      @restaurants = @restaurants.where("rating = ?","#{search_params[:rating].downcase}") if search_params[:checkrating]
      # if price field is present
      @restaurants = @restaurants.where("price = ?","#{search_params[:price].downcase}") if search_params[:checkprice]
      # search by open now (day and time)
      @restaurants = @restaurants.joins(:hours).where("day_id = ? AND open <= ? AND close > ?","#{search_params[:day].downcase}","#{search_params[:time].downcase}","#{search_params[:time].downcase}") if search_params[:day].present? and search_params[:time].present? and search_params[:opennow].present?
      # search by location :http://www.scribd.com/doc/2569355/Geo-Distance-Search-with-MySQL
      # search by open hour
      
      # relevance by same zip code
      @relevant = @restaurants.where("zip = ?","#{search_params[:zip].downcase}") if search_params[:zip].present?
      puts @relevant
      @irelevant = @restaurants.where("zip != ?","#{search_params[:zip].downcase}") if search_params[:zip].present?
      puts @irelevant
      @restaurants = (@relevant + @irelevant) if search_params[:zip].present?
      
      @users = User.all
  end

#note for search
#      @restaurants = Restaurant.find_by address: search_params[:key]
# or .where("address = ? OR hours = ?", search_params[:key], search_params[:key])



  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
  end

  # GET /restaurants/new
  def new
    if user_signed_in?
      if current_user.rest && Restaurant.find_by_user_id(current_user.id) == nil
        @restaurant = Restaurant.new
        7.times {@restaurant.hours.build}
      else
        redirect_to profile_path, notice: 'Restricted Path'
      end
    else
      redirect_to sign_in_path, notice: 'Restricted Path'
    end
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    # render text: restaurant_params
    url = "http://api.zippopotam.us/us/" + restaurant_params[:zip]
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    if response.body == nil or response.body.empty? or response.body == '{}'
      flash[:error] = "restaurant zip code not valid"
      redirect_to restaurant_new_path
      return
    else 
      response = JSON.parse(response.body)
      place = response['places']
      a = {}
      a[:lat] = place[0]['latitude']
      params[:restaurant][:lat] = place[0]['latitude']
      params[:restaurant][:lon] = place[0]['longitude']
    end

    @restaurant = Restaurant.new(restaurant_params)
    hours = restaurant_params[:hours_attributes]
    @hour = []
    hours.each  do |k, v|
      v[:day_id] = k.to_i + 1
      v[:rest_id] = restaurant_params[:user_id]
      @hour << Hour.new(v)
    end

    
    @hour.each do |h|
      if !h.valid? 
        flash[:error] = "Opening Hours Not Valid. Either both open and close hour should be empty or closing hour >= opening hour"
        redirect_to restaurant_new_path
        return
      end
    end
    if !@restaurant.valid?
      flash[:error] = "restaurant details not valid"
      redirect_to restaurant_new_path
      return
    end

    @hour.each do |h|
      h.save
    end

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to profile_path, notice: 'Restaurant was successfully created.'}
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end
    
    def hours_params
      params.require(:hours).permit(:close, :hour)
    end
    
    def search_params
        params.permit(:key,:category,:rating,:price,:day,:time,:checkprice,:checkrating,:zip,:opennow)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      # params[:restaurant]
      params.require(:restaurant).permit(:address, :city, :zip, :hours, :user_id, :rest_type, :price, :description, :lon, :lat,hours_attributes: [:day_id, :open, :close, :rest_id])
    end
end
