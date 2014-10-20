require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsHelper
  setup do
    @user = users(:one)
    @password = 'testing1'
  end

  test "anon user redirected from index to login" do
    get :index
    assert_redirected_to :login
  end

  test 'Authed user redirected from index to GadgetsController' do
    sign_in @user
    get :index
    assert_redirected_to({controller: :gadgets})
  end

  test "Anon user can get login" do
    get :login
    assert_response :success
  end

  test 'Authed user redirected from login to GadgetsController' do
    sign_in @user
    get :login
    assert_redirected_to({controller: :gadgets})
  end

  test 'Email and password are correct => session created' do
    post :create, session: { email: @user.email, password: @password }
    assert_equal(current_user, @user)
    assert_redirected_to :gadgets
  end

  test "destroy makes user unauthenticated" do
    sign_in @user
    get :destroy
    assert_response :success
    assert_nil current_user!
  end

end
