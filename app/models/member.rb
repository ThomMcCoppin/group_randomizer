class Member < ApplicationRecord
  belongs_to :group, optional: true
end
