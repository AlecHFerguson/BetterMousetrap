require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  include CommentsHelper
  setup do
    @user = users(:one)
    @gadget = gadgets(:one)
    @comment_params = { user_id: @user.id, gadget_id: @gadget.id, title: 'Boolean Operator',
                        text: 'This is a good way to think logically', have_it: true
                      }
  end

  test 'Valid params => comment is saved' do
    comment = Comment.new(@comment_params)
    assert comment.save
  end

  # validate user_id
  test 'Non-numeric user_id => fails to save' do
    comment = Comment.new(@comment_params.merge(user_id: '123'))
    assert_not comment.save
    assert_equal comment.errors.messages, { user: [NO_USER_FOUND_ERROR] }
  end

  test 'Nonexistent user_id => fails to save' do
    comment = Comment.new(@comment_params.merge(user_id: 9999999))
    assert_not comment.save
    assert_equal comment.errors.messages, { user: [NO_USER_FOUND_ERROR] }
  end

  test 'Blank user_id => fails to save' do
    comment = Comment.new(@comment_params.merge(user_id: nil))
    assert_not comment.save
    assert_equal({ user_id: ["can't be blank", 'is not a number'], user: [NO_USER_FOUND_ERROR] },
        comment.errors.messages)
  end

  test 'Missing user_id => fails to save' do
    comment = Comment.new(@comment_params.reject { |k,v| k == :user_id })
    assert_not comment.save
    assert_equal({ user_id: ["can't be blank", 'is not a number'], user: [NO_USER_FOUND_ERROR] },
        comment.errors.messages )
  end


  # validate gadget_id
  test 'Non-numeric gadget_id => fails to save' do
    comment = Comment.new(@comment_params.merge(gadget_id: '123'))
    assert_not comment.save
    assert_equal({gadget: [NO_GADGET_FOUND_ERROR]}, comment.errors.messages)
  end

  test 'Nonexistent gadget_id => fails to save' do
    comment = Comment.new(@comment_params.merge(gadget_id: 9999999))
    assert_not comment.save
    assert_equal({gadget: [NO_GADGET_FOUND_ERROR]}, comment.errors.messages)
  end

  test 'Blank gadget_id => fails to save' do
    comment = Comment.new(@comment_params.merge(gadget_id: nil))
    assert_not comment.save
    assert_equal({gadget_id: ["can't be blank", 'is not a number'], gadget: [NO_GADGET_FOUND_ERROR]},
      comment.errors.messages)
  end

  test 'Missing gadget_id => fails to save' do
    comment = Comment.new(@comment_params.reject { |k,v| k == :gadget_id })
    assert_not comment.save
    assert_equal({gadget_id: ["can't be blank", 'is not a number'], gadget: [NO_GADGET_FOUND_ERROR]},
      comment.errors.messages)
  end


  # validate title
  test 'Title too short => Fails to save' do
    comment = Comment.new(@comment_params.merge(title: 'A'*9))
    assert_not comment.save
    assert_equal(comment.errors.messages,
      title: ['is too short (minimum is 10 characters)'])
  end
end
