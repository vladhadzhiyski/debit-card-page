class DebitCardsController < ApplicationController
  around_action :handle_errors
  before_action :find_user, only: [:create, :index, :show, :edit, :update, :make_payment]
  before_action :find_debit_card, only: [:show, :edit, :update, :make_payment]

  # class UserNotFound < StandardError; end

  # GET /users/:permalink/debit_cards
  def index
    @debit_cards = DebitCard.where(user_id: @user.id)
  end

  # GET /users/:permalink/debit_cards/:id
  def show
  end

  # GET /users/:permalink/debit_cards/:id/edit
  def edit
  end

  # PUT /users/:permalink/debit_cards/:id
  def update
    update_params = update_params_permit!
    @debit_card.update!(update_params)
    flash[:success] = "Debit card updated successfully!"
    redirect_to debit_card_path(@user.permalink, @debit_card.id)
  end

  def make_payment
    monthly_subscription_amount = 1000 # Note: amount is in cents (1000 => $10.00)
    response_code = @debit_card.stub_perform_payment(monthly_subscription_amount)
    if response_code == '100'
      flash[:success] = "Your payment has been accepted."
    else
      flash[:error] = "Your payment has been declined. Please re-check with the providing bank."
    end
    redirect_to debit_card_path(@user.permalink, @debit_card.id)
  end

  # GET /users/:permalink/debit_cards/new
  def new
    new_params = new_params_permit!
    @user = User.find_by_permalink!(new_params[:permalink])
    @debit_card = DebitCard.new
    @debit_cards = DebitCard.where(user_id: @user.id)
  end

  # POST /users/:permalink/debit_cards
  def create
    create_params = create_params_permit!
    @card = @user.debit_cards.create!(create_params)
    flash[:success] = "Debit card created successfully!"
    redirect_to debit_cards_path(@user.permalink)
  end

  private

    def find_user
      find_params = find_user_params_permit!
      @user = User.find_by_permalink(find_params[:permalink])
      raise Errors::UserNotFound.new("User not found") if @user.nil?
    end

    def find_user_params_permit!
      params.permit(
        :permalink
      ).to_h
    end

    def update_params_permit!
      params.require(:debit_card).permit(
        :card_number,
        :expiration_month,
        :expiration_year,
        :cvv
      ).to_h
    end

    def create_params_permit!
      params.require(:debit_card).permit(
        :card_number,
        :expiration_month,
        :expiration_year,
        :cvv
      ).to_h
    end

    def new_params_permit!
      params.permit(
        :permalink
      ).to_h
    end

    def find_debit_card
      @debit_card = DebitCard.find_by_id!(find_debit_card_params[:id])
    end

    def find_debit_card_params
      params.permit(:id).to_h
    end

    def handle_errors
      yield
    rescue Errors::UserNotFound => e
      flash[:error] = e.message
      redirect_to users_path
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = e.message
      redirect_to debit_cards_path
    rescue ActiveRecord::RecordInvalid => e
      record = e.record
      errors_message = record.errors.full_messages.join(", ")
      path_to_redirect_to = record.persisted? ? record.reload : new_debit_card_path
      flash[:error] = errors_message
      redirect_to path_to_redirect_to
    end
end
