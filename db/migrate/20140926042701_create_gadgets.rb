class CreateGadgets < ActiveRecord::Migration
  def change
    create_table :gadgets do |t|
      t.string :name
      t.string :website
      t.string :description
      t.string :buy_now_url

      t.timestamps
    end
  end
end
