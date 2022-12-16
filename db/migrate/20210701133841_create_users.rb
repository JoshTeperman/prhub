class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :github_id
      t.string :encrypted_access_token

      t.timestamps
    end
  end
end
