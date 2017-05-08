class UsersController < ApplicationController
  around_action :handle_errors
  before_action :find_user, only: [:show, :edit, :update]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:permalink
  def show
  end

  # GET /users/:permalink/edit
  def edit
  end

  # PUT /users/:permalink
  def update
    update_params = update_params_permit!
    @user.update!(update_params)
    flash[:success] = "User updated successfully!"
    redirect_to user_path(@user.permalink)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    create_params = create_params_permit!
    @user = User.create!(create_params)
    flash[:success] = "User created successfully!"
    redirect_to @user
  end

  private

    def update_params_permit!
      params.require(:user).permit(
        :first_name,
        :last_name
      ).to_h
    end

    def create_params_permit!
      params.require(:user).permit(
        :first_name,
        :last_name
      ).to_h
    end

    def find_user
      @user = User.find_by_permalink!(find_user_params[:permalink])
    end

    def find_user_params
      params.permit(:permalink).to_h
    end

    def handle_errors
      yield
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = e.message
      redirect_to users_path
    rescue ActiveRecord::RecordInvalid => e
      record = e.record
      errors_message = record.errors.full_messages.join(", ")
      path_to_redirect_to = record.persisted? ? record.reload : new_user_path
      flash[:error] = errors_message
      redirect_to path_to_redirect_to
    end
end
