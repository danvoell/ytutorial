class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :profile_attributes

  has_one :profile
  accepts_nested_attributes_for :profile
  
 
  has_many :tutorials
  has_many :comments
  
has_reputation :user_votes, source: {reputation: :votes, of: :tutorials}, aggregated_by: :sum

  
  def admin?
    self.email == "andrew@atevans.com" || self.email == "danvoell@gmail.com"
  end
end
