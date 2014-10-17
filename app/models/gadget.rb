class Gadget < ActiveRecord::Base
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, :attributes => :image, :less_than => 1.megabytes

  ## TODO: Lots of validation!!
  
  def total_votes
    Vote.where(gadget_id: id)
  end

  def upvotes
    total_votes.select { |v| v.upvote }.length
  end

  def downvotes
    total_votes.select { |v| !v.upvote }.length
  end

  def users_vote(user)
    raw_vote = total_votes.select { |v| v.user_id == user.id }.first
    if raw_vote
      return raw_vote.upvote ? 'Up' : 'Down'
    else
      return 'None'
    end
  end
end
