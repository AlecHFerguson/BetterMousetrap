class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :gadget_id
      t.string  :title
      t.string  :text
      t.boolean :have_it

      t.timestamps
    end
  end
end
