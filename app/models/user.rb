class User < ActiveRecord::Base
	validates :username, :presence => true, :uniqueness =>true, :length => { :minimum => 3}
	has_many :reviews
	has_many :movies, :through => :reviews
	has_many :movies, :through => :likes
end
