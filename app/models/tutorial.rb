class Tutorial < ActiveRecord::Base
  
  belongs_to :user
  has_many :steps
  has_many :comments
  
  attr_accessible :name, :image, :remote_image_url, :title, :tag_list, :outline, :file, :thumb, :website, :steptitle
   mount_uploader :image, ImageUploader
  
  acts_as_taggable
  
has_reputation :votes, source: :user, aggregated_by: :sum

  def editor?(edit_user)
    self.user_id == edit_user.id || edit_user.admin?
  end

  def to_param
  	"#{id}-#{title}".parameterize
  end

def tagged
  if params[:tag].present? 
    @tutorials = Tutorial.tagged_with(params[:tag])
  else 
    @tutorials = Tutorial.postall
  end  
end

end
