require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @test_fname      = 'Filbert'
    @test_lname      = 'Scuzzlebutt'
    @test_email      = 'scuzzle@butt.co.kr'
    @test_password   = 'testing1'
    @test_confirm    = 'testing1'

    @user_params = { fname: @test_fname, lname: @test_lname, email: @test_email,
                     password: @test_password, password_confirmation: @test_confirm
                   }
  end

  test 'Valid user is saved properly' do
    user = User.new(@user_params)
    assert user.save
    assert_not_nil user.remember_token
    assert_not_equal(user.remember_token, '')
  end


  ## :fname validation
  test 'First name and last name are case changed properly' do
    user = User.new(@user_params.merge({fname: 'aBcDeFg', lname: 'TuVwXyZ'}))
    user.save

    user_after = User.all.last
    assert_equal(user_after.fname, 'Abcdefg')
    assert_equal(user_after.lname, 'Tuvwxyz')
  end

  test 'Short fname => fails to save' do
    user = User.new(@user_params.merge({fname: 'A'}))
    assert_not user.save
    assert_equal(user.errors.messages, 
      { fname: ['is too short (minimum is 3 characters)'] } )
  end

  test 'Long fname => fails to save' do
    user = User.new(@user_params.merge({fname: 'A' + 'b'*95 }))
    assert_not user.save
    assert_equal(user.errors.messages, 
      { fname: ['is too long (maximum is 90 characters)'] } )
  end

  test 'fname contains numbers => fails to save' do
    user = User.new(@user_params.merge({fname: 'Abc1' }))
    assert_not user.save
    assert_equal(user.errors.messages, { fname: [User::NAME_MESSAGE] } )
  end

  test 'fname contains special characters => fails to save' do
    user = User.new(@user_params.merge({fname: 'Xyz>' }))
    assert_not user.save
    assert_equal(user.errors.messages, { fname: [User::NAME_MESSAGE] } )
  end

  test 'Blank fname => fails to save' do
    user = User.new(@user_params.merge({fname: ''}))
    assert_not user.save
    assert_equal(user.errors.messages, 
      { fname: ["can't be blank", 'is too short (minimum is 3 characters)', User::NAME_MESSAGE] } )
  end

  test 'Missing fname param => fails to save' do
    user = User.new( @user_params.reject { |k,v| k == :fname } )
    assert_not user.save
    assert_equal(user.errors.messages, 
      { fname: ["can't be blank", 'is too short (minimum is 3 characters)', User::NAME_MESSAGE] } )
  end


  ## :lname
  test 'Short lname => fails to save' do
    user = User.new(@user_params.merge({lname: 'A'}))
    assert_not user.save
    assert_equal(user.errors.messages, 
      { lname: ['is too short (minimum is 3 characters)'] } )
  end

  test 'Long lname => fails to save' do
    user = User.new(@user_params.merge({lname: 'A' + 'b'*95 }))
    assert_not user.save
    assert_equal(user.errors.messages, 
      { lname: ['is too long (maximum is 90 characters)'] } )
  end

  test 'lname contains numbers => fails to save' do
    user = User.new(@user_params.merge({lname: 'Abc1' }))
    assert_not user.save
    assert_equal(user.errors.messages, { lname: [User::NAME_MESSAGE] } )
  end

  test 'lname contains special characters => fails to save' do
    user = User.new(@user_params.merge({lname: 'Xyz>' }))
    assert_not user.save
    assert_equal(user.errors.messages, { lname: [User::NAME_MESSAGE] } )
  end

  test 'Blank lname => fails to save' do
    user = User.new(@user_params.merge({lname: ''}))
    assert_not user.save
    assert_equal(user.errors.messages, 
      { lname: ["can't be blank", 'is too short (minimum is 3 characters)', User::NAME_MESSAGE] } )
  end

  test 'Missing lname param => fails to save' do
    user = User.new( @user_params.reject { |k,v| k == :lname } )
    assert_not user.save
    assert_equal(user.errors.messages, 
      { lname: ["can't be blank", 'is too short (minimum is 3 characters)', User::NAME_MESSAGE] } )
  end


  ## :email
  test 'Emails matching regex can save' do
    emails = ['dan+50@yahoo.com', '!#$%^&*()@+_-~`{[]}\|.co.kr', 'ab+cd@{}+.v',
              'a'*50 + '@' + 'b'*50 + '.' + 'xtc+3'
             ]
    emails.each do |e|
      user = User.new(@user_params.merge({email: e}))
      assert user.save,
          "ERROR: Unable to save email address = #{e}"
    end
  end

  test 'Emails failing regex cannot save' do
    emails = ['abcd@efgh.ij', 'abcde@fg.hi', 'abcde@fgh.', 
              'a'*51 + '@gmail.com', 'abcde@' + 'x'*51 + '.tv', 'abcde@gmail.' + 's'*6,
              'abcdefgmail.com', '@bcde@gmail.com', 'flack@h@ugh.ty', 'telev@jimmy.j@',
              'abcde@xyzcom'
             ]
    emails.each do |e|
      user = User.new(@user_params.merge({email: e}))
      assert_not user.save, "ERROR: Validation should reject #{e}, but User was able to save"
      assert_equal(user.errors.messages, { email: [User::EMAIL_MESSAGE] } )
    end
  end

  test 'Blank email => fails to save' do
    user = User.new(@user_params.merge({ email: '' }))
    assert_not user.save
    assert_equal(user.errors.messages,
              { email: ["can't be blank", 'Please enter a valid email address'] })
  end

  test 'Missing email => fails to save' do
    user = User.new(@user_params.reject {|k,v| k == :email})
    assert_not user.save
    assert_equal(user.errors.messages, 
              { email: ["can't be blank", "Please enter a valid email address"] })
  end


  # :password
  test 'Mismatched passwords => fails to save' do
    user = User.new(@user_params.merge({password: 'testing2'}))
    assert_not user.save
    assert_equal(user.errors.messages,
              { password_confirmation: ["doesn't match Password"]})
  end

  test 'Mismatched confirm password => fails to save' do
    user = User.new(@user_params.merge({password_confirmation: 'testing2'}))
    assert_not user.save
    assert_equal(user.errors.messages,
              { password_confirmation: ["doesn't match Password"]})
  end

  test 'Missing :password => fails to save' do
    user = User.new(@user_params.reject {|k,v| k == :password})
    assert_not user.save
    assert_equal(user.errors.messages, { password: 
        ["can't be blank", 'is too short (minimum is 3 characters)', "can't be blank"]})
  end

  test 'Missing :password_confirmation => fails to save' do
    user = User.new(@user_params.reject {|k,v| k == :password_confirmation})
    assert_not user.save
    assert_equal(user.errors.messages,
              { password_confirmation: ["can't be blank"]})
  end

  test 'Blank :password => fails to save' do
    user = User.new(@user_params.merge({password: ''}))
    assert_not user.save
    assert_equal(user.errors.messages, { password:
          ["can't be blank", "is too short (minimum is 3 characters)", "can't be blank"]})
  end

  test 'Blank :password_confirmation => fails to save' do
    user = User.new(@user_params.merge({password_confirmation: ''}))
    assert_not user.save
    assert_equal(user.errors.messages,
              { password_confirmation: ["doesn't match Password", "can't be blank"]})
  end

end
