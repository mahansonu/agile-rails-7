class Product < ApplicationRecord

  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :price, :image_url, presence: true
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {with: %r{\.(png|gif|jpg)\z}i, message: 'must be a url for png, jpg or gif image'}
  validates :price, numericality: {greater_than_or_equal_to: 0.01}

  private
  def ensure_not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line Items present')
      throw :abort
    end
  end
end
