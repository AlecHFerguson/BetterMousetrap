class Comment < ActiveRecord::Base
  include CommentsHelper

  validates :user_id, presence: true, numericality: true
  validates :gadget_id, presence: true, numericality: true
  validates :title, length: { in: 10..70 }

  belongs_to :user
  validates :user, presence: { message: NO_USER_FOUND_ERROR }

  belongs_to :gadget
  validates :gadget, presence: { message: NO_GADGET_FOUND_ERROR }
  

  def user_email
    User.find_by_id(self.user_id).email
  end
end
