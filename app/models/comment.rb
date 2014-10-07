class Comment < ActiveRecord::Base
  # TODO: Validation. Unit tests!

  def user_email
    User.find_by_id(self.user_id).email
  end
end
