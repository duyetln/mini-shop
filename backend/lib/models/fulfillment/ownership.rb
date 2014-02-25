class Ownership < ActiveRecord::Base

  attr_accessible :user_id, :item_type, :item_id

  belongs_to :user
  belongs_to :item, polymorphic: true

  validates :user_id,   presence: true
  validates :item_type, presence: true
  validates :item_id,   presence: true

  validates :item, presence: true
  validates :user, presence: true

end