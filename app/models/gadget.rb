class Gadget < ActiveRecord::Base
  
  def total_votes
    @total_votes ||= Vote.where(gadget_id: id)
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
      return raw_vote ? 'Up' : 'Down'
    else
      return 'None'
    end
  end
end
