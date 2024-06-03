# To run the tests: ./run_tests
#
# Available assertions:
# assert.true!
# assert.false!
# assert.equal!
# assert.exception!
# assert.includes!
# assert.not_includes!
# assert.int!
# + any that you define
#
# Powered by Dragon Test: https://github.com/DragonRidersUnite/dragon_test

return unless debug?

test Frying::Platter do |args, assert|
  platter1 = Frying::Platter.new(3)
  it 'produces an platter of the correct length' do
    assert.equal!(
      platter1.empty_platter().size,
      3,
      'produces an platter of the correct length'
    )
  end

  platter2 = Frying::Platter.new(5)
  it 'changes the platter length when a new object is created' do
    assert.equal!(
      platter2.empty_platter().size,
      5,
      'changes the platter length when a new object is created'
    )
  end

  it 'updates the previous object based on the new update' do
    assert.equal!(
      platter1.empty_platter().size,
      5,
      'updates the previous object based on the new update'
    )
  end
end

test Frying::Table do |args, assert|
  platter1 = Frying::Platter.new(3)
  table = Frying::Table.new()
  it 'references the superclass for the correct platter length' do
    assert.equal!(
      table.empty_platter().size,
      platter1.empty_platter().size,
      'references the superclass for the correct platter length'
    )
  end

  platter2 = Frying::Platter.new(5)
  it 'updates itself when the superclass is updated' do
    assert.equal!(
      table.empty_platter().size,
      platter1.empty_platter().size,
      'updates itself when the superclass is updated (1/2)'
    )
    assert.equal!(
      table.empty_platter().size,
      platter2.empty_platter().size,
      'updates itself when the superclass is updated (2/2)'
    )
  end
end

test Frying::Waiter do |args, assert|
  platter1 = Frying::Platter.new(3)
  waiter = Frying::Waiter.new()
  it 'references the superclass for the correct platter length' do
    assert.equal!(
      waiter.empty_platter().size,
      platter1.empty_platter().size,
      'references the superclass for the correct platter length'
    )
  end

  platter2 = Frying::Platter.new(5)
  it 'updates itself when the superclass is updated' do
    assert.equal!(
      waiter.empty_platter().size,
      platter1.empty_platter().size,
      'updates itself when the superclass is updated (1/2)'
    )
    assert.equal!(
      waiter.empty_platter().size,
      platter2.empty_platter().size,
      'updates itself when the superclass is updated (2/2)'
    )
  end
end

run_tests
