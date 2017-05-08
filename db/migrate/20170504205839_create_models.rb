class CreateModels < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :permalink

      t.timestamps
    end

    create_table :debit_cards do |t|
      t.string :card_number
      t.string :last_four
      t.string :encrypted_card_number
      t.string :encrypted_card_number_iv
      t.integer :expiration_month, :limit => 2
      t.integer :expiration_year, :limit => 4
      t.integer :cvv, :limit => 3

      t.references :user

      t.timestamps
    end
  end
end
