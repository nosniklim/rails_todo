require "test_helper"

class CardTest < ActiveSupport::TestCase
  # Similar test cases to List: moving a card in the same list
  test "id:3 move to the top in the same list" do
    target = Card.find(3)
    assert target.update_with_sort(position: 1), "Failed to save"
    assert_equal 1, target.position, "Filed to update"

    expect_value = {1=>2, 2=>3, 3=>1, 4=>4, 5=>5}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 22=>2, 23=>3}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 5, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 3, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "id:3 move forward in the same list" do
    target = Card.find(3)
    assert target.update_with_sort(position: 2), "Failed to save"
    assert_equal 2, target.position, "Filed to update"

    expect_value = {1=>1, 2=>3, 3=>2, 4=>4, 5=>5}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 22=>2, 23=>3}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 5, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 3, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

    test "id:3 move backward in the same list" do
    target = Card.find(3)
    assert target.update_with_sort(position: 4), "Failed to save"
    assert_equal 4, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>4, 4=>3, 5=>5}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 22=>2, 23=>3}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 5, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 3, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "id:3 move to the end in the same list" do
    target = Card.find(3)
    assert target.update_with_sort(position: 5), "Failed to save"
    assert_equal 5, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>5, 4=>3, 5=>4}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 22=>2, 23=>3}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 5, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 3, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "id:3 remove from the list" do
    target = Card.find(3)
    assert target.destroy_with_sort, "Failed to save"

    expect_value = {1=>1, 2=>2, 3=>nil, 4=>3, 5=>4}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 22=>2, 23=>3}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 4, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 3, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "add new card in the same list" do
    position = Card.where(list_id: 1).maximum(:position)
    position = position.nil? ? 1 : position + 1
    target = Card.new({
      id: 6,
      title: '16',
      list_id: 1,
      position: position
    })
    assert target.save, "Failed to save=>#{target.errors.full_messages}"
    assert_equal 6, target.position, "Filed to update"

    expect_value = {21=>1, 22=>2, 23=>3}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 6, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 3, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "add new card in new list" do
    position = Card.where(list_id: 3).maximum(:position)
    position = position.nil? ? 1 : position + 1
    target = Card.new({
      id: 31,
      title: '31',
      list_id: 3,
      position: position
    })
    assert target.save, "Failed to save=>#{target.errors.full_messages}"
    assert_equal 1, target.position, "Filed to update"

    expect_value = {21=>1, 22=>2, 23=>3}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 5, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 3, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 1, Card.where(list_id: 3..).count, "Filed to update"
  end

  # Additional features for Card
  test "id:3 switch to the top of the other list" do
    target = Card.find(3)
    assert target.update_with_sort(list_id: 2, position: 1), "Failed to save"
    assert_equal 1, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>1, 4=>3, 5=>4}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {3=>1, 21=>2, 22=>3, 23=>4}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 4, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 4, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "id:3 switch to the first half of the other list" do
    target = Card.find(3)
    assert target.update_with_sort(list_id: 2, position: 2), "Failed to save"
    assert_equal 2, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>2, 4=>3, 5=>4}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 3=>2, 22=>3, 23=>4}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 4, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 4, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "id:3 switch to the later half of the other list" do
    target = Card.find(3)
    assert target.update_with_sort(list_id: 2, position: 3), "Failed to save"
    assert_equal 3, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>3, 4=>3, 5=>4}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 22=>2, 3=>3, 23=>4}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 4, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 4, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "id:3 switch to the end of the other list" do
    target = Card.find(3)
    assert target.update_with_sort(list_id: 2, position: 5), "Failed to save"
    assert_equal 4, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>4, 4=>3, 5=>4}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 22=>2, 23=>3, 3=>4}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 4, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 4, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "id:3 switch to the new list" do
    target = Card.find(3)
    assert target.update_with_sort(list_id: 3, position: 5), "Failed to save"
    assert_equal 1, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>1, 4=>3, 5=>4}
    Card.where(list_id: 1).where.not(id: 3).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {21=>1, 22=>2, 23=>3}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 4, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 3, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 1, Card.where(list_id: 3..).count, "Filed to update"
  end

  test "move new card to the existing list" do
    target = Card.new({
      id: 31,
      title: '31',
      list_id: 3,
      position: 1
    })
    assert target.save, "Failed to save=>#{target.errors.full_messages}"
    assert_equal 1, target.position, "Filed to update"
    assert_equal 1, Card.where(list_id: 3..).count, "Filed to update"

    # move to the top of the existing list
    assert target.update_with_sort(list_id: 2, position: 1), "Failed to save"
    assert_equal 1, target.position, "Filed to update"

    expect_value = {1=>1, 2=>2, 3=>3, 4=>4, 5=>5}
    Card.where(list_id: 1).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order in id=#{card.id}"
    end

    expect_value = {31=>1, 21=>2, 22=>3, 23=>4}
    Card.where(list_id: 2).each do |card|
      position = expect_value[card.id]
      assert_equal position, card.position, "Failed to change order"
    end
    assert_equal 5, Card.where(list_id: 1).count, "Filed to update"
    assert_equal 4, Card.where(list_id: 2).count, "Filed to update"
    assert_equal 0, Card.where(list_id: 3..).count, "Filed to update"
  end

end
