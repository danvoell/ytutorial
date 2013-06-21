class Step < ActiveRecord::Base
  
  
  belongs_to :tutorial
  has_many :comments
  
end
