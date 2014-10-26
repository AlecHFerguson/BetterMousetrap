require 'test_helper'

class GadgetTest < ActiveSupport::TestCase
  setup do
    @name        = 'My Gadget'
    @website     = 'https://www.mygadget.com'
    @description = 'This is an awesome gadget. You should buy it.'
    @buy_now_url = 'https://www.alibaba.com/mygadget'

    @gadget_params = { name: @name, website: @website, description: @description,
                       buy_now_url: @buy_now_url
                    }

    @invalid_urls = [ 'httb://www.blah.com', 'http:/www.a.com', 'http//www.b.com',
                      'http:://www.c.com', 'http:///www.a.com', '+https://www.abc.com',
                      'http://w@w.abc.com', 'http://.a.com', 'http://a.com',
                      'http://ab.bc', 'http://ab.cd/123' ]
  end

  test 'Valid gadget is saved properly' do
    gadget = Gadget.new(@gadget_params)
    assert gadget.save
  end

  # Name validation
  test 'Name too short => fails to save' do
    gadget = Gadget.new(@gadget_params.merge(name: 'XZ'))
    assert_not gadget.save
    assert_equal(gadget.errors.messages, { name: ['is too short (minimum is 3 characters)'] } )
  end

  test 'Name too long => fails to save' do
    gadget = Gadget.new(@gadget_params.merge(name: 'V'*101))
    assert_not gadget.save
    assert_equal(gadget.errors.messages, { name: ['is too long (maximum is 100 characters)'] } )
  end

  test 'Blank name => fails to save' do
    gadget = Gadget.new(@gadget_params.merge(name: ''))
    assert_not gadget.save
    assert_equal(gadget.errors.messages, 
      { name: ["can't be blank", 'is too short (minimum is 3 characters)'] } )
  end

  test 'Missing name => fails to save' do
    gadget = Gadget.new(@gadget_params.reject { |k,v| k == :name })
    assert_not gadget.save
    assert_equal(gadget.errors.messages, 
      { name: ["can't be blank", 'is too short (minimum is 3 characters)'] } )
  end

  # Description validation
  test 'Description too short => fails to save' do
    gadget = Gadget.new(@gadget_params.merge(description: 'V'*19))
    assert_not gadget.save
    assert_equal(gadget.errors.messages,
      { description: ['is too short (minimum is 20 characters)']} )
  end

  test 'Description too long => fails to save' do
    gadget = Gadget.new(@gadget_params.merge(description: 'V'*501))
    assert_not gadget.save
    assert_equal(gadget.errors.messages,
      { description: ['is too long (maximum is 500 characters)']} )
  end

  test 'Blank description => fails to save' do
    gadget = Gadget.new(@gadget_params.merge(description: ''))
    assert_not gadget.save
    assert_equal(gadget.errors.messages,
      { description: ["can't be blank", 'is too short (minimum is 20 characters)']} )
  end

  test 'Missing description => fails to save' do
    gadget = Gadget.new(@gadget_params.reject { |k,v| k == :description })
    assert_not gadget.save
    assert_equal(gadget.errors.messages,
      { description: ["can't be blank", 'is too short (minimum is 20 characters)']} )
  end


  # Website validation
  test 'Website has invalid url => fails to save' do
    @invalid_urls.each do |test_url|
      gadget = Gadget.new(@gadget_params.merge(website: test_url))
      assert_not gadget.save
      assert_equal(gadget.errors.messages,
        { website: ['Sorry, it appears this URL is not valid. It must contain http(s)://']} )
    end
  end


  # Buy now URL validation
  test 'Buy Now URL has invalid url => fails to save' do
    @invalid_urls.each do |test_url|
      gadget = Gadget.new(@gadget_params.merge(buy_now_url: test_url))
      assert_not gadget.save
      assert_equal(gadget.errors.messages,
        { buy_now_url: ['Sorry, it appears this URL is not valid. It must contain http(s)://']} )
    end
  end


  # Upvotes and Downvotes methods
  test 'Upvotes and downvotes methods returns correct numbers' do
    gadget   = gadgets(:one)
    upvote   = votes(:user_1_gadget_1)
    downvote = votes(:user_2_gadget_1)

    gadget_1 = Gadget.find_by_id gadget.id
    assert_equal 1, gadget_1.upvotes
    assert_equal 2, gadget_1.downvotes
  end

  # users_vote
  test 'users_vote is found properly' do
    gadget       = gadgets(:one)
    upvote       = votes(:user_1_gadget_1)
    downvote     = votes(:user_2_gadget_1)
    no_vote_user = users(:no_votes)

    gadget1 = Gadget.find_by_id gadget.id
    user1 = User.find_by_id upvote.user_id
    assert_equal 'Up', gadget1.users_vote(user1)

    user2 = User.find_by_id downvote.user_id
    assert_equal 'Down', gadget1.users_vote(user2)

    user3 = User.find_by_id no_vote_user.id
    assert_equal 'None', gadget1.users_vote(user3)
  end

end
