class FixHaveSqlType < ActiveRecord::Migration
  def change
    drop_table :comments if ActiveRecord::Base.connection.table_exists? :comments
  end
end
