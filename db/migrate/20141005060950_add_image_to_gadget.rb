class AddImageToGadget < ActiveRecord::Migration
  def self.up
    add_attachment :gadgets, :image
  end
end
