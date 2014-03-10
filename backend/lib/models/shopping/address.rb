class Address < ActiveRecord::Base

  attr_accessible :user_id, :line1, :line2, :line3, :city, :region, :postal_code, :country
  attr_readonly   :user_id, :line1, :line2, :line3, :city, :region, :postal_code, :country

  belongs_to :user

  validates :user,    presence: true
  validates :line1,   presence: true
  validates :city,    presence: true
  validates :country, presence: true
  
end