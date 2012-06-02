class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :movie_id
      t.text :content
      t.integer :mark

      t.timestamps
    end
  end
end
