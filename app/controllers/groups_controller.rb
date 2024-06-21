class GroupsController < ApplicationController
  def index
    rearrange_groups
    @groups = Group.all.preload(:members).map { |g| group_props(g) }
  end

  private
    def members
      @members = Member.all
    end

    def rearrange_groups
      Group.destroy_all
      group_count = members.count / 3
      group_count += 1 if members.count % 3 != 0 # add a group if there are people left over
      group_id_array = []
      (1..group_count).each do |n|
        Group.create
        group_id_array << [n, n, n]
      end
      group_id_array = group_id_array.flatten
      if members.count % 3 == 1 # make 2 groups have 2 members so we don't have one member alone
        group_id_array.delete_at(group_id_array.length - 1)
        group_id_array.delete_at(group_id_array.length - 4)
      end
      group_id_array = group_id_array.shuffle
      members.each do |member|
        member.group_id = group_id_array.pop
        member.save
      end
    end

    def group_props(group)
      {
        members: group.members.map { |m| { name: "#{m.first_name} #{m.last_name}" } }
      }
    end
end
