class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  def version_check(params)
    cust = params[:cust_id]
    rest = params[:rest_id]
    @cur_version = {cust_id: cust, rest_id: rest}
    @version = Version.where(cust_id: cust, rest_id: rest).first
    if @version == nil
      @cur_version[:count] = 0
      Version.create(@cur_version)
      return 0
    end
    return @version.count
  end

  def qty_check(params)
    cust = params[:cust_id]
    rest = params[:rest_id]
    menu = params[:menu_id]
    ver = params[:version]
    @cur_cart = Cart.where(cust_id: cust, rest_id: rest, menu_id: menu, version: ver).first
    if @cur_cart == nil
      # render json: params
      return false
    end
    params[:qty] = @cur_cart.qty + 1
    @cur_cart.update(params)
    return true
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)
    @cart.version = version_check(cart_params)
    topass = cart_params
    topass[:version] = @cart.version
    
    if !qty_check(topass)
      @cart.qty = 1
      respond_to do |format|
        if @cart.save
          format.html { redirect_to(:back)}
        else
          format.html { render :new }
          format.json { render json: @cart.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to(:back) 
      #restaurant_page_path(:rest_id => @cart.rest_id)
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def clear
    if user_signed_in?
      cur_version = version_check(cust_id: current_user.id, rest_id: params[:rest_id])
      carts = Cart.find_cart(current_user.id, params[:rest_id], cur_version)
      carts.each do |cart|
        cart.destroy
      end
      redirect_to(:back) 
      # redirect_to restaurant_page_path(:rest_id => params[:rest_id])
    else
      redirect_to login_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.require(:cart).permit(:cust_id, :rest_id, :version, :menu_id, :qty)
    end
end
