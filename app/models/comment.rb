class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :tutorial
  belongs_to :step
  validate :tutorial_or_step
  
  def tutorial
    self.tutorial_id.present? ? Tutorial.find_by_id(self.tutorial_id) : Step.find_by_id(self.step_id).try(:tutorial)
  end
  
  def tutorial_or_step
    errors.add(:base, "You must comment on a tutorial or step") unless self.step.present? || self.tutorial.present?
  end
  
  def step_index
    return 0 unless self.step_id.present?
    
    # step 0 is always tutorial outline, so steps are 1-indexed
    self.tutorial.steps.all.index(self.step) + 1
  end
  
  def editor?(user)
    self.user_id == user.id || user.admin?
  end
end
