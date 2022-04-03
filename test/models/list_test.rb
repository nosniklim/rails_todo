require "test_helper"

class ListTest < ActiveSupport::TestCase
  test "id:3 move to the top" do
    target = List.find(3)
    assert target.update_with_sort(position: 1), "Failed to save"
    assert_equal 1, target.position, "Filed to update"

    expect_value = {1=>2, 2=>3, 3=>1, 4=>4, 5=>5}
    List.where.not(id: 3).each do |list|
      position = expect_value[list.id]
      assert_equal position, list.position, "Failed to change order in id=#{list.id}"
    end
    assert_equal 5, List.count, "Filed to update"
  end

  test "id:3 move forward" do
    target = List.find(3)
    assert target.update_with_sort(position: 2), "Failed to save"
    assert_equal 2, target.position, "Filed to update"

    expect_value = {1=>1, 2=>3, 3=>2, 4=>4, 5=>5}
    List.where.not(id: 3).each do |list|
      position = expect_value[list.id]
      assert_equal position, list.position, "Failed to change order in id=#{list.id}"
    end
    assert_equal 5, List.count, "Filed to update"
  end

    test "id:3 move backward" do
    target = List.find(3)
    assert target.update_with_sort(position: 4), "Failed to save"
    assert_equal 4, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>4, 4=>3, 5=>5}
    List.where.not(id: 3).each do |list|
      position = expect_value[list.id]
      assert_equal position, list.position, "Failed to change order in id=#{list.id}"
    end
    assert_equal 5, List.count, "Filed to update"
  end

  test "id:3 move to the end" do
    target = List.find(3)
    assert target.update_with_sort(position: 5), "Failed to save"
    assert_equal 5, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>5, 4=>3, 5=>4}
    List.where.not(id: 3).each do |list|
      position = expect_value[list.id]
      assert_equal position, list.position, "Failed to change order in id=#{list.id}"
    end
    assert_equal 5, List.count, "Filed to update"
  end

  test "id:3 remove from the list" do
    target = List.find(3)
    assert target.destroy_with_sort, "Failed to save"

    expect_value = {1=>1, 2=>2, 3=>nil, 4=>3, 5=>4}
    List.where.not(id: 3).each do |list|
      position = expect_value[list.id]
      assert_equal position, list.position, "Failed to change order in id=#{list.id}"
    end
    assert_equal 4, List.count, "Filed to update"
  end

  test "add new list" do
    position = List.where(user_id: 1).maximum(:position)
    position = position.nil? ? 1 : position + 1
    target = List.new({
      id: 6,
      title: '6',
      user_id: 1,
      position: position
    })
    assert target.save, "Failed to save=>#{target.errors.full_messages}"
    assert_equal 6, target.position, "Filed to update"
    assert_equal 6, List.count, "Filed to update"
  end

end
