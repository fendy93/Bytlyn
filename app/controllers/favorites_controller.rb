class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:show, :edit, :update, :destroy]

  # GET /favorites
  # GET /favorites.json
  def index
    if user_signed_in?
      # if Restaurant.find_by_user_id(current_user.id) != nil
      favorites = Favorite.get_restaurant_favorite(current_user.id)
      temp = favorites.collect do |favorite|
        Restaurant.find_by_user_id(favorite.rest_id)
      end
      @restaurants = Restaurant.find(temp)
      @users = User.all
      #   render 'index.html.erb' 
      # else
      #   redirect_to restaurant_new_path
      # end  
    else
      redirect_to login_path
    end
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show
  end

  # GET /favorites/new
  # def new
  #   if user_signed_in?
  #     @favorite = Favorite.new
  #   else
  #     redirect_to login_path
  #   end
  # end

  # GET /favorites/1/edit
  def edit
  end

  # POST /favorite
  # POST /favorite.json
  def create
    cur_rest = params[:rest_id]
    favorite_params = {cust_id: current_user.id, rest_id: cur_rest}
    @favorite = Favorite.new(favorite_params)

    if @favorite.check_params
      respond_to do |format|
        if @favorite.save
          flash.now[:notice] = 'Successfully added to favorite list.'
          format.html { redirect_to restaurants_path, notice: 'Favorite was successfully created.' }
          format.json { render :show, status: :created, location: @favorite }
        else
          format.html { redirect_to restaurants_list_path }
          format.json { render json: @favorite.errors, status: :unprocessable_entity }
        end

      end
    else 
     flash[:error] = 'You have favorite on this restaurant.'
      redirect_to favorites_path
    end
  end

  # PATCH/PUT /favorite/1
  # PATCH/PUT /favorite/1.json
  # def update
  #   respond_to do |format|
  #     if @favorite.update(favorite_params)
  #       format.html { redirect_to favorite_path, notice: 'Favorite was successfully added.' }
  #       format.json { render :show, status: :ok, location: @favorite }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @favorite.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    # @favorite.find(cust_id: current_user.id)
    @favorite.destroy
    respond_to do |format|
      format.html { redirect_to favorites_url, notice: 'Favorite was successfully removed' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      if !user_signed_in?
        redirect_to login_path
      else
        @favorite = Favorite.where(rest_id: params[:rest_id], cust_id: current_user.id).first
      end
      # @favorite = Favorite.find(params[:rest_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.require(:favorites).permit(:cust_id, :rest_id)
    end
  end
