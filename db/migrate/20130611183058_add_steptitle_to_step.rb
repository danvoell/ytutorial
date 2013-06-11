class AddSteptitleToStep < ActiveRecord::Migration
  def change
    add_column :steps, :steptitle, :string

  end
end
