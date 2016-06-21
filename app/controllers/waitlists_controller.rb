class WaitlistsController < ApplicationController
  before_action :set_waitlist, only: [:show, :edit, :update, :destroy]

  # GET /waitlists
  # GET /waitlists.json
  def index

    # @waitlists = Waitlist.all
    if user_signed_in?
      if current_user.rest
        if Restaurant.find_by_user_id(current_user.id) != nil
          @lists = Waitlist.get_restaurant_waitlist(current_user.id)
          render 'rest_index.html.erb' 
        else
          redirect_to restaurant_new_path
        end
      else
        # @lists = Waitlist.where(:cust_id == current_user.id)
        @waitlists = Waitlist.get_customer_waitlist(current_user.id)
        render 'cust_index.html.erb'   
      end
    else
      redirect_to login_path
    end
  end

  def history
    @history = true
    # @waitlists = Waitlist.all
    if user_signed_in?
      if current_user.rest
        if Restaurant.find_by_user_id(current_user.id) != nil
          @lists = Waitlist.get_restaurant_waitlist_history(current_user.id)
          render 'rest_index.html.erb' 
        else
          redirect_to restaurant_new_path
        end
      else
        # @lists = Waitlist.where(:cust_id == current_user.id)
        @waitlists = Waitlist.get_customer_waitlist_history(current_user.id)
        render 'cust_index.html.erb'   
      end
    else
      redirect_to login_path
    end
  end

  # GET /waitlists/1
  # GET /waitlists/1.json
  def show
  end

  # GET /waitlists/new
  def new
    if user_signed_in?
      @waitlist = Waitlist.new
    else
      redirect_to login_path
    end
  end

  # GET /waitlists/1/edit
  def edit
  end

  # POST /waitlists
  # POST /waitlists.json
  def create
    cur_rest = params[:waitlist][:rest_id]
    cur_people = params[:waitlist][:people]
    cur_name = params[:waitlist][:name]
    # render text: params
    waitlist_params = {cust_id: current_user.id, rest_id: cur_rest, people: cur_people, name: cur_name, status: 1}
    @waitlist = Waitlist.new(waitlist_params)
    if !@waitlist.valid?
      flash[:error] = "Number of People can't be blank"
      redirect_to waitlists_new_path(:rest_id => cur_rest)
      return
    end


    if @waitlist.check_params
      respond_to do |format|
        if @waitlist.save
          flash.now[:notice] = 'Waitlist was successfully created.'
          format.html { redirect_to waitlists_path, notice: 'Waitlist was successfully created.' }
          format.json { render :show, status: :created, location: @waitlist }
        else
          format.html { render :new }
          format.json { render json: @waitlist.errors, status: :unprocessable_entity }
        end

      end
    else 
      flash[:error] = 'You have waitlisted on this restaurant.'
      redirect_to waitlists_path
    end
  end

  # # PATCH/PUT /waitlists/1
  # # PATCH/PUT /waitlists/1.json
  # def update
  #   respond_to do |format|
  #     if @waitlist.update(waitlist_params)
  #       format.html { redirect_to @waitlist, notice: 'Waitlist was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @waitlist }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @waitlist.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def update_status_success
    @waitlist = Waitlist.find(params[:waitlist])
    respond_to do |format|
      if @waitlist.update(status: 2)

        format.html { redirect_to '/waitlists', notice: 'Delivery was successfully updated.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { redirect_to '/waitlists' }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_status_no_show
    @waitlist = Waitlist.find(params[:waitlist])
    respond_to do |format|
      if @waitlist.update(status: 3)

        format.html { redirect_to '/waitlists', notice: 'Delivery was successfully updated.' }
        format.json { render :show, status: :ok, location: @delivery }
      else
        format.html { redirect_to '/waitlists' }
        format.json { render json: @delivery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /waitlists/1
  # DELETE /waitlists/1.json
  def destroy
    @waitlist.destroy
    respond_to do |format|
      format.html { redirect_to waitlists_path, notice: 'Waitlist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waitlist
      @waitlist = Waitlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def waitlist_params
      params.require(:waitlist).permit(:cust_id, :rest_id, :people, :name)
    end
end
