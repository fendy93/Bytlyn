class DeliveriesController < ApplicationController
  before_action :set_delivery, only: [:show, :edit, :update, :destroy]

  # GET /deliveries
  # GET /deliveries.json
  def index
     if user_signed_in?
      if current_user.rest
        if Restaurant.find_by_user_id(current_user.id) != nil
          @deliveries = Delivery.get_restaurant_delivery(current_user.id)
          render 'rest_index.html.erb' 
        else
          redirect_to restaurant_new_path
        end
      else
        # @lists = Waitlist.where(:cust_id == current_user.id)
        @deliveries = Delivery.get_customer_delivery(current_user.id)
        render 'cust_index.html.erb'   
      end
    else
      redirect_to login_path
    end
  end

  def history
    if user_signed_in?
      if current_user.rest
        if Restaurant.find_by_user_id(current_user.id) != nil
          @deliveries = Delivery.get_restaurant_delivery_history(current_user.id)
          @history = true
          render 'rest_index.html.erb' 
        else
          redirect_to restaurant_new_path
        end
      else
        # @lists = Waitlist.where(:cust_id == current_user.id)
        @deliveries = Delivery.get_customer_delivery_history(current_user.id)
        @history = true
        render 'cust_index.html.erb'   
      end
    else
      redirect_to login_path
    end
  end

  # GET /deliveries/1
  # GET /deliveries/1.json
  def show
  end

  # GET /deliveries/new
  def new
    if user_signed_in?
      @delivery = Delivery.new
      gon.client_token = generate_client_token
    else
      redirect_to login_path
    end
  end

  # # GET /deliveries/1/edit
  # def edit
  # end

  # POST /deliveries
  # POST /deliveries.json
  def create
    if user_signed_in?
      unless current_user.has_payment_info?
        @result = Braintree::Transaction.sale(
                    amount: delivery_params[:total],
                    payment_method_nonce: params[:payment_method_nonce],
                    customer: {
                      first_name: current_user.name,
                      email: current_user.email,
                      phone: delivery_params[:phone]
                    },
                    options: {
                      store_in_vault: true
                    })

      else
        @result = Braintree::Transaction.sale(
                  amount: delivery_params[:total],
                  payment_method_nonce: params[:payment_method_nonce])
      end
      if @result.success?
        current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
        @delivery = Delivery.new(delivery_params)
        rest = delivery_params[:rest_id]
        cust = delivery_params[:user_id]
        params = {rest_id: rest, cust_id: cust}
        @version = Version.where(rest_id: rest, cust_id: cust).first
        @delivery.version = @version.count
        @delivery.status = 1
        params[:count] = @version.count + 1

        respond_to do |format|
          @version.update(params)
          if @delivery.save
            format.html { redirect_to restaurants_path , notice: 'Thank you. Your order is being processed'}
            # format.json { render :show, status: :created, location: @delivery }
          else
            format.html { render :new }
            format.json { render json: @delivery.errors, status: :unprocessable_entity }
          end
        end
      else 
        flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
        gon.client_token = generate_client_token
        redirect_to profile_path
      end
    else
      redirect_to login_path
    end

  end

  # PATCH/PUT /deliveries/1
  # PATCH/PUT /deliveries/1.json
  # def update
  #   respond_to do |format|
  #     if @delivery.update(delivery_params)
  #       format.html { redirect_to @delivery, notice: 'Delivery was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @delivery }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @delivery.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def payment
  #   gon.client_token = generate_client_token
  # end
  def update_status
    @delivery = Delivery.find(params[:delivery])
    respond_to do |format|
      if @delivery.update(status: @delivery.status + 1)

        format.html { redirect_to '/delivery', notice: 'Delivery was successfully updated.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { redirect_to '/delivery' }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /deliveries/1
  # DELETE /deliveries/1.json
  # def destroy
  #   @delivery.destroy
  #   respond_to do |format|
  #     format.html { redirect_to '/delivery', notice: 'Delivery was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery
      @delivery = Delivery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delivery_params
      params.require(:delivery).permit(:phone, :rest_id, :version, :user_id, :address, :total, :payment_method_nonce)
    end

    def generate_client_token
      if current_user.has_payment_info?
        Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
      else
        Braintree::ClientToken.generate
      end
    end
end
