class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id, null: false
      t.integer :gadget_id, null: false
      t.boolean :upvote, null: false

      t.timestamps
    end
  end
end
