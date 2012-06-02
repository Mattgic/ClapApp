class Movie < ActiveRecord::Base
	validates :alloCineCode, :presence => true, :uniqueness =>true
	validates :title, :presence => true
	has_many :reviews
	has_many :users, :through => :reviews
	has_many :users, :through => :likes
	
end
