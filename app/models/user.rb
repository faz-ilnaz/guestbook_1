class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :microposts, dependent: :destroy


  validates :name,  presence: true, 
                    length: {maximum: 40}, 
                    uniqueness: { case_sensitive: false }
end
