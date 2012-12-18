class AddWebsiteurlToTutorials < ActiveRecord::Migration
  def change
    add_column :tutorials, :website, :string

  end
end
