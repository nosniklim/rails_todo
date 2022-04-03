module UtilityMethods

  def update_with_sort(params)
    # get original params
    @position_was = self.position
    @list_id_was = self.list_id if self.class == Card
    # update
    result = self.update(params) ? true : self.errors
    # get updated params
    @position, @target_id = self.position, self.id
    @list_id = self.list_id if self.class == Card
    change_order if result
    return result
  end

  def destroy_with_sort
    @position_was = self.position
    @position, @target_id = self.class.where(reset_target).maximum(:position) + 1, self.id
    @list_id_was, @list_id = self.list_id, self.list_id if self.class == Card
    # destroy
    result = self.destroy ? true : self.errors
    change_order if result
    return result
  end

private

  def change_order
    position_from, position_to = @position_was, @position
    # Change order of List or Card, if position was changed in the same group.
    if self.class == List or @list_id_was == @list_id
      if position_to != position_from
        if position_to > position_from
          # Remove, move to the other list or move to the end
          position_max = self.class.where(reset_target).maximum(:position)
          if position_max && position_to >= position_max
            self.class.where("id <> ? and position > ?#{extra_condition}", @target_id, position_from).each {|pos| pos.decrement!(:position)}
          # Move backward
          else
            self.class.where("id <> ? and position > ? and position <= ?#{extra_condition}", @target_id, position_from, position_to).each {|pos| pos.decrement!(:position)}
          end
        elsif position_to < position_from
          # Move to the top
          if position_to == self.class.where(reset_target).minimum(:position)
            self.class.where("id <> ? and position < ?#{extra_condition}", @target_id, position_from).each {|pos| pos.increment!(:position)}
          # Move forward
          else
            self.class.where("id <> ? and position >= ? and position < ?#{extra_condition}", @target_id, position_to, position_from).each {|pos| pos.increment!(:position)}
          end
        end
      end

    elsif self.class == Card && @list_id_was != @list_id
      # Reset original list's order if move to the other list
      self.class.where("position > ?#{extra_condition}", position_from).each {|pos| pos.decrement!(:position)}
      position_max = self.class.where(reset_target).count
      if self.position > position_max
        self.position = position_max
        self.save
      else
        # Reset the list's order in a destination
        self.class.where("id <> ? and position > ?#{extra_condition_new_destination}", @target_id, position_to.to_i - 1 ).each {|pos| pos.increment!(:position)}
      end
    end
  end

  def reset_target
    if self.class == Card
      "list_id = #{self.list_id}"
    else
      "user_id = #{self.user_id}"
    end
  end

  def extra_condition
    " and list_id = #{@list_id_was}" if self.class == Card
  end

  def extra_condition_new_destination
    " and list_id = #{@list_id}" if self.class == Card
  end

end