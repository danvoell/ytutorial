class Tutorial < ActiveRecord::Base
  
  belongs_to :user
  has_many :steps
  has_many :comments
  
  attr_accessible :name, :image, :remote_image_url, :title, :tag_list, :outline, :file, :thumb
   mount_uploader :image, ImageUploader
  
  acts_as_taggable
  
  def editor?(edit_user)
    self.user_id == edit_user.id || edit_user.admin?
  end
end
