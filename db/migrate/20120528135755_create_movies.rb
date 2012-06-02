class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.integer :alloCineCode
      t.string :title

      t.timestamps
    end
  end
end
