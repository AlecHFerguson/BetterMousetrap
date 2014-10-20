require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include SessionsHelper
  setup do
    @user = users(:one)
    @gadget = gadgets(:one)
    @comment_params = { gadget_id: @gadget.id, title: 'I love it!', text:
                'This gadget is the bestest!', have_it: true }
  end

  test 'Unauthed user cannot create comment' do
    all_comments = Comment.all
    post :create, comment: @comment_params
    assert_equal all_comments, Comment.all
  end

  test 'Authed user can create comment' do
    sign_in @user
    assert_difference('Comment.where(gadget_id: @gadget.id).count') do
      post :create, comment: @comment_params
    end
    assert_redirected_to @gadget
  end
end
