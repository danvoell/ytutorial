class Tutorial < ActiveRecord::Base
  
  belongs_to :user
  has_many :steps
  
  def editor?(edit_user)
    self.user_id == edit_user.id || edit_user.admin?
  end
end
