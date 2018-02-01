class UserCoinsController < ApplicationController
  before_action :set_user_coins, only: [:show, :edit, :update, :destroy]
  before_action :user_coins_params, except: [:index, :show]
  # before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @user_coins = UserCoin.all
    @q_string = []
    @user_coins.each do |n|
    @q_string << @coins.find_by(id: n.coin_id).name
    end
    query_string = ""
    @q_string.each do |i|
      query_string << i
      query_string << ","
    end

    p query_string
    url = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms="
    fiat_type = "&tsyms=USD"
    @api_endpoint = url + query_string + fiat_type
    p @api_endpoint
    url = @api_endpoint
    response = HTTParty.get(url)
    @data = JSON.parse(response.body)
  end

  def show
  end

  def new
    @user_coins = UserCoin.new
  end

  def edit
  end

  def create
    if params[:coin_id].present?
      @user_coins = UserCoin.new(coin_id: params[:coin_id], user: current_user)
    else
     coins = Coin.find_by_symbol(params[:coin_symbol])
      if coins
        @user_coins = UserCoin.new(user_id: current_user, coin_id: coins)
      else
        coins = Coin.find_by_symbol(params[:coin_symbol])
          if coins.save
            @user_coins = UserCoin.new(user_id: current_user, coin_id: coins)
          else
            @user_coins = nil
          flash[:error] = "Coin is not available"
          end
      end
    end

    respond_to do |format|
      if @user_coins.save
        format.html { redirect_to user_coins_path,
          notice: "Coin #{@user_coins.coin.symbol} was successfully added" }
        format.json { render :show, status: :created, location: @user_coins }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @review.update(review_params)
        flash[:success] = "coin was successfully updated."
        format.html { redirect_to @review }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      flash[:success] = "coin was successfully deleted."
      format.html { redirect_to @review.product }
      format.json { head :no_content }
    end
  end

  private
    def set_user_coins
      @user_coins = UserCoin.find(params[:id])
    end

    def user_coins_params
      params.require(:user_coins).permit(:user_id, :coin_id)
    end

    # def require_same_user
    #   if current_user != @review.user and !current_user.admin?
    #     flash[:danger] = 'You can only edit or delete your own article'
    #     redirect_to root_path
    #   end
    # end
end



# class UserCoinsController < ApplicationController
#   before_action :set_user_coins, only: [:show, :edit, :update, :destroy]
#   before_action :user_coins_params, except: [:index, :show]
  # before_action :require_same_user, only: [:edit, :update, :destroy]

 # def index
 #    @user_coins = UserCoin.all
 #  end
 #
 # def show
 #  end

 # def new
 #    @user_coins = UserCoin.new
 #  end

 # def edit
 #  end

 # def create
 #    @user_coins = UserCoin.new(user_coins_params)
 #    @user_coins.user = current_user

  #  respond_to do |format|
  #     if @review.save
  #       flash[:success] = "coin was successfully saved."
  #       format.html { redirect_to @review.product }
  #       format.json { render :show, status: :created, location: @review }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @review.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

 # def update
 #    respond_to do |format|
 #      if @review.update(review_params)
 #        flash[:success] = "coin was successfully updated."
 #        format.html { redirect_to @review }
 #        format.json { render :show, status: :ok, location: @review }
 #      else
 #        format.html { render :edit }
 #        format.json { render json: @review.errors, status: :unprocessable_entity }
 #      end
 #    end
 #  end

 # def destroy
 #    @review.destroy
 #    respond_to do |format|
 #      flash[:success] = "coin was successfully deleted."
 #      format.html { redirect_to @review.product }
 #      format.json { head :no_content }
 #    end
 #  end
 #
 # private
 #    def set_user_coins
 #      @user_coins = UserCoin.find(params[:id])
 #    end
 #
 #   def user_coins_params
 #      params.require(:user_coins).permit(:user_id, :coin_id)
 #    end

   # def require_same_user
    #   if current_user != @review.user and !current_user.admin?
    #     flash[:danger] = 'You can only edit or delete your own article'
    #     redirect_to root_path
    #   end
    # end
# end
