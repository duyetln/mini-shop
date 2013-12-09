class StorefrontSku < ActiveRecord::Base

  belongs_to :sku, polymorphic: true

  validates :title, presence: true
  validates :sku,   presence: true

  def available?
    self.active? && self.sku.available?
  end

  def fulfill!(order)

  end

end