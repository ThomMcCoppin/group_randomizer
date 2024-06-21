class Group < ApplicationRecord
  has_many :members

  validates :members, length: { maximum: 3 }

  before_destroy :clear_members, prepend: true

  private
    def clear_members
      members.each do |member|
        member.group_id = nil
        member.save
      end
    end
end
