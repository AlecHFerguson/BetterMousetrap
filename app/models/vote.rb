class Vote < ActiveRecord::Base
  NO_USER_FOUND_ERROR = 'It appears you changed the user id when posting the vote. Please reload the page and try again.'
  NO_GADGET_FOUND_ERROR = 'It appears you changed the gadget id when posting the vote. Please reload the page and try again.'

  belongs_to :gadget
  validates :gadget, presence: { message: NO_GADGET_FOUND_ERROR }
  belongs_to :user
  validates :user, presence: { message: NO_USER_FOUND_ERROR }

  validates :upvote, presence: true, { in: [true, false] }
end
