class Comment < ActiveRecord::Base
  include CommentsHelper

  validates :user_id, presence: true, numericality: true
  validates :gadget_id, presence: true, numericality: true
  validates :title, length: { in: 10..70 }

  belongs_to :user
  # validates_associated :user
  validates :user, { presence: true, message: NO_USER_FOUND_ERROR }

  belongs_to :gadget
  validates_associated :gadget
  validates :gadget, { presence: true, message: NO_GADGET_FOUND_ERROR }
  

  def user_email
    User.find_by_id(self.user_id).email
  end
end
