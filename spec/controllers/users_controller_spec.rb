require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "#create" do
    before do
      @create_params = {
        user: {
          first_name: "Al",
          last_name: "Pacino"
        }
      }
    end

    context "success" do
      it "creates a user if first and last name are present" do
        expect do
          post :create, params: @create_params
        end.to change(User, :count).by(1)

        user = User.last
        expect(response).to redirect_to(user)
        expect(flash[:success]).to eq("User created successfully!")
        expect(user.first_name).to eq("Al")
        expect(user.last_name).to eq("Pacino")
        expect(user.permalink).to eq("al-pacino")
      end
    end

    context "failures" do
      it "returns an error if first name is missing" do
        @create_params[:user][:first_name] = nil
        expect do
          post :create, params: @create_params
        end.not_to change(User, :count)

        expect(response).to redirect_to(new_user_path)
        expect(flash[:error]).to eq("First name can't be blank")
      end

      it "returns an error if last name is missing" do
        @create_params[:user][:last_name] = nil
        expect do
          post :create, params: @create_params
        end.not_to change(User, :count)

        expect(response).to redirect_to(new_user_path)
        expect(flash[:error]).to eq("Last name can't be blank")
      end

      it "returns an error if there is an existing user with the same credential" do
        user = User.create!(@create_params[:user])
        expect do
          post :create, params: @create_params
        end.not_to change(User, :count)

        expect(response).to redirect_to(new_user_path)
        expect(flash[:error]).to eq("This user is already registered")
      end
    end
  end

  describe "#update" do
    before do
      @user = User.create!(
        first_name: "Jim",
        last_name: "Carey"
      )

      @update_params = {
        permalink: @user.permalink,
        user: {
          first_name: "Jimmy",
          last_name: "Butler"
        }
      }
    end

    context "success" do
      it "updates a user if first or last name are present" do
        put :update, params: @update_params

        @user.reload
        expect(response).to redirect_to(user_path(@user.permalink))
        expect(flash[:success]).to eq("User updated successfully!")
        expect(@user.first_name).to eq("Jimmy")
        expect(@user.last_name).to eq("Butler")
        expect(@user.permalink).to eq("jimmy-butler")
      end
    end

    context "failures" do
      it "returns an error if user is not found" do
        @update_params[:permalink] = "does-not-exist"
        put :update, params: @update_params

        expect(response).to redirect_to(users_path)
        expect(flash[:error]).to eq("Couldn't find User")
      end
    end
  end

  describe "#show" do
    before do
      @user = User.create!(
        first_name: "Al",
        last_name: "Pacino"
      )

      @show_params = { permalink: @user.permalink }
    end

    context "success" do
      it "shows the user if it exists" do
        get :show, params: @show_params

        expect(assigns(:user)).to eq(@user)
      end
    end

    context "failures" do
      it "returns an error if the user does not exist" do
        @show_params[:permalink] = "does-not-exist"

        get :show, params: @show_params

        expect(response).to redirect_to(users_path)
        expect(flash[:error]).to eq("Couldn't find User")
      end
    end
  end

  describe "#edit" do
    before do
      @user = User.create!(
        first_name: "Al",
        last_name: "Pacino"
      )

      @edit_params = { permalink: @user.permalink }
    end

    context "success" do
      it "allows the user details to be updated" do
        get :edit, params: @edit_params

        expect(assigns(:user)).to eq(@user)
      end
    end

    context "failures" do
      it "returns an error if the user does not exist" do
        @edit_params[:permalink] = "does-not-exist"

        get :edit, params: @edit_params

        expect(response).to redirect_to(users_path)
        expect(flash[:error]).to eq("Couldn't find User")
      end
    end
  end

end
