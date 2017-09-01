class Voter < ApplicationRecord
  validates :url_slug, uniqueness: true
end
