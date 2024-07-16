class GroupsController < ApplicationController
  def index
    Group.destroy_all
    assign_group_members
    @groups = Group.all.preload(:members).map { |g| group_props(g) }
  end

  private
    def exclusive_members
      @exclusive_members ||= Member.where(group_avoid: 1)
    end

    def members
      @members ||= Member.where(group_avoid: nil)
    end

    def create_group_array
      group_id_array = []
      group_count = (members.count + exclusive_members.count) / 3
      group_count += 1 if members.count % 3 != 0 # add a group if there are people left over
      (1..group_count).each do |n|
        Group.create
        group_id_array.push([n, n, n])
      end
      group_id_array.flatten
    end

    def assign_group_members
      group_id_array = create_group_array
      exclusive_members.each_with_index do |member, index|
        member.group_id = group_id_array[index * 3]
        group_id_array.delete_at(index * 3)
        member.save
      end
      if members.count % 3 == 1 # make 2 groups have 2 members so we don't have one member alone
        if exclusive_members.count >= group_count - 2
          group_id_array.delete_at(group_id_array.length - 1)
          group_id_array.delete_at(group_id_array.length - 3)
        else
          group_id_array.delete_at(group_id_array.length - 1)
          group_id_array.delete_at(group_id_array.length - 4)
        end
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
