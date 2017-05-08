require 'rails_helper'

RSpec.describe DebitCardsController, type: :controller do
  let(:user) { User.create(first_name: "Jimmy", last_name: "Johns") }

  describe "#create" do
    before do
      @create_params = {
        permalink: user.permalink,
        debit_card: {
          card_number: "4242424242424242",
          expiration_month: 5,
          expiration_year: 2020,
          cvv: 123
        }
      }
    end

    context "success" do
      it "creates a debit card if all required params are provided" do
        expect do
          post :create, params: @create_params
        end.to change(DebitCard, :count).by(1)

        card = DebitCard.last
        expect(response).to redirect_to(debit_cards_path(user.permalink))
        expect(flash[:success]).to eq "Debit card created successfully!"
        expect(card.last_four).to eq("4242")
        expect(card.expiration_month).to eq(5)
        expect(card.expiration_year).to eq(2020)
        expect(card.cvv).to eq(123)
        expect(card.user.id).to eq(user.id)
      end
    end

    context "failures" do
      it "returns an error if card number is missing" do
        @create_params[:debit_card][:card_number] = nil
        expect do
          post :create, params: @create_params
        end.not_to change(DebitCard, :count)

        expect(response).to redirect_to(new_debit_card_path)
        expect(flash[:error]).to eq "Card number can't be blank"
      end

      it "returns an error if expiration month is missing" do
        @create_params[:debit_card][:expiration_month] = nil
        expect do
          post :create, params: @create_params
        end.not_to change(DebitCard, :count)

        expect(response).to redirect_to(new_debit_card_path)
        expect(flash[:error]).to eq "Expiration month can't be blank"
      end

      it "returns an error if expiration year is missing" do
        @create_params[:debit_card][:expiration_year] = nil
        expect do
          post :create, params: @create_params
        end.not_to change(DebitCard, :count)

        expect(response).to redirect_to(new_debit_card_path)
        expect(flash[:error]).to eq "Expiration year can't be blank"
      end

      it "returns an error if expiration year is missing" do
        @create_params[:debit_card][:cvv] = nil
        expect do
          post :create, params: @create_params
        end.not_to change(DebitCard, :count)

        expect(response).to redirect_to(new_debit_card_path)
        expect(flash[:error]).to eq "Cvv can't be blank"
      end
    end
  end

  describe "#show" do
    before do
      @debit_card = DebitCard.create!(
        card_number: "4242424242424242",
        expiration_month: 5,
        expiration_year: 2020,
        cvv: 123,
        user_id: user.id
      )

      @show_params = {
        permalink: user.permalink,
        id: @debit_card.id
      }
    end

    context "success" do
      xit "shows the debit card if it exists" do
        get :show, params: @show_params

        expect(assigns(:debit_card)).to eq(@debit_card)
      end
    end

    context "failures" do
      it "returns an error if the debit card does not exist" do
        @show_params[:id] = 9999 # id that does not exist

        get :show, params: @show_params

        expect(response).to redirect_to(debit_cards_path)
        expect(flash[:error]).to eq "Couldn't find DebitCard"
      end
    end
  end

  describe "#update" do
    before do
      @debit_card = DebitCard.create!(
        card_number: "4242424242424242",
        expiration_month: 5,
        expiration_year: 2020,
        cvv: 123,
        user_id: user.id
      )

      @update_params = {
        permalink: user.permalink,
        id: @debit_card.id,
        debit_card: {
          card_number: "4444444444444441",
          expiration_month: 9,
          expiration_year: 2019,
          cvv: 222,
        }
      }
    end

    context "success" do
      it "shows the debit card if it exists" do
        put :update, params: @update_params

        expect(response).to redirect_to(debit_card_path(user.permalink, @debit_card.id))
        expect(flash[:success]).to eq "Debit card updated successfully!"
        @debit_card.reload
        expect(@debit_card.last_four).to eq("4441")
        expect(@debit_card.expiration_month).to eq(9)
        expect(@debit_card.expiration_year).to eq(2019)
        expect(@debit_card.cvv).to eq(222)
        expect(@debit_card.user.id).to eq(user.id)
      end
    end

    context "failures" do
      it "returns an error if the debit card does not exist" do
        @update_params[:id] = 9999 # id that does not exist

        get :show, params: @update_params

        expect(response).to redirect_to(debit_cards_path)
        expect(flash[:error]).to eq "Couldn't find DebitCard"
      end
    end
  end

  describe "#new" do
    before do
      @debit_card_1 = DebitCard.create!(
        card_number: "4444444444444441",
        expiration_month: 4,
        expiration_year: 2019,
        cvv: 111,
        user_id: user.id
      )

      @debit_card_2 = DebitCard.create!(
        card_number: "4242424242424242",
        expiration_month: 5,
        expiration_year: 2020,
        cvv: 123,
        user_id: user.id
      )

      @new_params = {
        permalink: user.permalink
      }
    end

    context "success" do
      it "lists the existing debit cards of a user" do
        get :new, params: @new_params

        expect(assigns(:debit_cards)).to match_array([@debit_card_1, @debit_card_2])
      end
    end
  end

end
