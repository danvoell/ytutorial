class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.integer :user_id
      t.string :title
      t.text :outline
      t.string :link
      t.timestamps
    end
  end
end
