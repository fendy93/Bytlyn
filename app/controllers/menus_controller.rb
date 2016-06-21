class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json
  def index
    if user_signed_in? and current_user.rest
      if Restaurant.find_by_user_id(current_user.id) != nil
        @lists = Menu.get_restaurant_menu(current_user.id)
        render 'rest_menu.html.erb' 
      else
        redirect_to restaurant_new_path
      end

      # else
      #   @waitlists = Waitlist.get_customer_waitlist(current_user.id)
      #   render 'cust_index.html.erb'   
    else
      redirect_to login_path
    end
  end

  # GET /menus/1
  # GET /menus/1.json
  def show
  end

  # GET /menus/new
  def new
    if user_signed_in? and current_user.rest
      @menu = Menu.new
    else
      redirect_to login_path
    end
  end

  # GET /menus/1/edit
  def edit
    if user_signed_in? and current_user.rest
      render 'new.html.erb'
    else
      redirect_to login_path
    end
  end

  # POST /menus
  # POST /menus.json
  def create
    @menu = Menu.new(menu_params)

    respond_to do |format|
      if @menu.save
        format.html { redirect_to menus_path, notice: 'Menu was successfully created.' }
        format.json { render :show, status: :created, location: @menu }
      else
        format.html { render :new }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    respond_to do |format|
      if @menu.update(menu_params)
        format.html { redirect_to menus_path, notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @menu }
      else
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      if params[:id] != nil
        @menu = Menu.find(params[:id])
      else
        redirect_to login_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      params.require(:menu).permit(:rest_id, :name, :description, :price, :avatar)
    end
end
