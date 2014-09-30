class Gadget < ActiveRecord::Base
  
  def total_votes
    @total_votes ||= Vote.where(gadget_id: id)
  end

  def upvotes
    total_votes.select {|v| v.upvote }.length
  end

  def downvotes
    total_votes.select{|v| !v.upvote }.length
  end
end
