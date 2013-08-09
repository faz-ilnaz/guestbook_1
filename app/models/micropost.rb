class Micropost < ActiveRecord::Base
	validates :content, presence: true, length: { maximum: 1000 }
	validates :user_id, presence: true
	belongs_to :user

	default_scope order: 'microposts.created_at DESC'
end
