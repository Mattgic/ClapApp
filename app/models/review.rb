class Review < ActiveRecord::Base
	validates :user, :presence => true, :uniqueness => {:scope => :movie}
	validates :movie, :presence => true 
	belongs_to :movie
	belongs_to :user
end
