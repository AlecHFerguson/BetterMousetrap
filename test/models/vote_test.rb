require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @gadget = gadgets(:one)
    @vote_params = { user_id: @user.id, gadget_id: @gadget.id, upvote: [true, false].sample }
  end

  test 'All valid params => Vote is saved' do
    vote = Vote.new(@vote_params)
    assert vote.save
  end

  ## :user_id validation
  test 'Nil :user_id => fails to save' do
    vote = Vote.new(@vote_params.merge(user_id: nil))
    assert_not vote.save
    assert_equal({user: [Vote::NO_USER_FOUND_ERROR]}, vote.errors.messages )
  end

  test 'Missing :user_id => fails to save' do
    vote = Vote.new(@vote_params.reject {|k,v| k == :user_id })
    assert_not vote.save
    assert_equal({user: [Vote::NO_USER_FOUND_ERROR]}, vote.errors.messages )
  end

  test ':user_id does not exist in DB => fails to save' do
    vote = Vote.new(@vote_params.merge(user_id: 9999999))
    assert_not vote.save
    assert_equal({user: [Vote::NO_USER_FOUND_ERROR]}, vote.errors.messages )
  end

  ## :gadget_id validation
  test 'Nil :gadget_id => fails to save' do
    vote = Vote.new(@vote_params.merge(gadget_id: nil))
    assert_not vote.save
    assert_equal({gadget: [Vote::NO_GADGET_FOUND_ERROR]}, vote.errors.messages )
  end

  test 'Missing :gadget_id => fails to save' do
    vote = Vote.new(@vote_params.reject {|k,v| k == :gadget_id })
    assert_not vote.save
    assert_equal({gadget: [Vote::NO_GADGET_FOUND_ERROR]}, vote.errors.messages )
  end

  test ':gadget_id does not exist in DB => fails to save' do
    vote = Vote.new(@vote_params.merge(gadget_id: 9999999))
    assert_not vote.save
    assert_equal({gadget: [Vote::NO_GADGET_FOUND_ERROR]}, vote.errors.messages )
  end

  ## :upvote validation
  test ':upvote is nil => fails to save' do
    vote = Vote.new(@vote_params.merge(upvote: nil))
    assert_not vote.save
    assert_equal({upvote: ['Must be true or false']}, vote.errors.messages)
  end

  test ':upvote is missing => fails to save' do
    vote = Vote.new(@vote_params.reject {|k,v| k == :upvote })
    assert_not vote.save
    assert_equal({upvote: ['Must be true or false']}, vote.errors.messages)
  end
end
