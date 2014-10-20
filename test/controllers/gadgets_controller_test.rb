require 'test_helper'

class GadgetsControllerTest < ActionController::TestCase
  include SessionsHelper
  setup do
    @user = users(:one)
    @gadget = gadgets(:one)
    ## Unable to pass :image param because Paperclip blows up.
    # TODO: Test post requests with image params.
    @new_gadget = { name: 'gadget1', website: 'www.gadget1.com', 
                    description: 'Awesome gadget!',  buy_now_url: 'buynow.gadget1.com'
                  }
  end

  test "should get index unauthed" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gadgets)
  end

  test "should get index authed" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:gadgets)
  end

  test "unable to get new unauthed" do
    get :new
    assert_redirected_to({controller: :sessions, action: :login})
  end

  test "can get new authed" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "unauthed user cannot create gadget" do
    assert_no_difference('Gadget.count') do
      post :create, gadget: @new_gadget
    end

    assert_redirected_to({controller: :sessions, action: :login})
  end

  test "authed user can create gadget" do
    sign_in @user
    assert_difference('Gadget.count') do
      post :create, gadget: @new_gadget
    end

    assert_redirected_to gadget_path(assigns(:gadget))
  end

  test "Anon user can get show gadget" do
    get :show, id: @gadget
    assert_response :success
  end

  test "Authed user can get show gadget" do
    sign_in @user
    get :show, id: @gadget
    assert_response :success
  end

  test "Anon user cannot get edit" do
    get :edit, id: @gadget
    assert_redirected_to({controller: :sessions, action: :login})
  end

  test "should get edit" do
    sign_in @user
    get :edit, id: @gadget
    assert_response :success
  end

  test "Anon user cannot update gadget" do
    patch :update, id: @gadget, gadget: @new_gadget
    assert_redirected_to({controller: :sessions, action: :login})
  end

  test "Authed user can update gadget" do
    sign_in @user
    patch :update, id: @gadget, gadget: @new_gadget
    assert_redirected_to gadget_path(assigns(:gadget))
  end

  test "Anon user cannot destroy gadget" do
    assert_no_difference('Gadget.count') do
      delete :destroy, id: @gadget
    end

    assert_redirected_to({controller: :sessions, action: :login})
  end

  test "Authed user can destroy gadget" do
    sign_in @user
    assert_difference('Gadget.count', -1) do
      delete :destroy, id: @gadget
    end

    assert_redirected_to gadgets_path
  end

  test 'Anon user cannot upvote' do
    votes_before = Vote.all
    post :upvote, id: @gadget, format: :json
    assert_equal votes_before, Vote.all
  end

  test 'Authed user upvotes for first time => new vote is created' do
    sign_in @user
    assert_difference('Vote.where(gadget_id: @gadget.id, user_id: @user.id, upvote: true).count') do
      post :upvote, id: @gadget, format: :json
    end
  end

  test 'Authed user upvotes existing upvote => no changes' do
    vote = votes(:user_1_gadget_1)
    sign_in @user
    votes_before = Vote.all
    post :upvote, id: @gadget, format: :json
    assert_equal votes_before, Vote.all
  end

  test 'Authed user upvotes existing downvote => vote is changed' do
    sign_in @user
    vote = votes(:user_1_downvote)
    post :upvote, id: @gadget, format: :json
    assert Vote.where(user_id: @user.id, gadget_id: @gadget.id)[0].upvote
  end

  test 'Anon user cannot downvote' do
    votes_before = Vote.all
    post :downvote, id: @gadget, format: :json
    assert_equal votes_before, Vote.all
  end

  test 'Authed user downvotes for first time => new vote is created' do
    sign_in @user
    assert_difference('Vote.where(gadget_id: @gadget.id, user_id: @user.id, upvote: false).count') do
      post :downvote, id: @gadget, format: :json
    end
  end

  test 'Authed user downvotes existing downvote => no changes' do
    vote = votes(:user_1_downvote)
    sign_in @user
    votes_before = Vote.all
    post :downvote, id: @gadget, format: :json
    assert_equal votes_before, Vote.all
  end

  test 'Authed user downvotes existing upvote => vote is changed' do
    sign_in @user
    vote = votes(:user_1_gadget_1)
    post :downvote, id: @gadget, format: :json
    assert_not Vote.where(user_id: @user.id, gadget_id: @gadget.id)[0].upvote
  end
  
end
