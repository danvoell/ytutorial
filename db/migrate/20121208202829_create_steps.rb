class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :tutorial_id
      t.text :content
      t.timestamps
    end
  end
end
