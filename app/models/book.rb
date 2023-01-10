class Book < ApplicationRecord
  LIBRARIES = [
    'Drexel Library',
    'Free Library of Philadelphia',
    'The Library Company',
    'Penn Libraries',
    'Other'
  ].freeze

  validates :title, presence: true
  validates :author, presence: true
  validates :lender, inclusion: { in: LIBRARIES }

  def full_name
    [call_number, title, author].compact.join '; '
  end

  def lender_display
    lender || lender_other
  end
end
