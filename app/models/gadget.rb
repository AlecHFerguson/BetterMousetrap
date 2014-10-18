class Gadget < ActiveRecord::Base
  has_many :comments
  has_many :votes
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, :attributes => :image, :less_than => 1.megabytes

  # Calculated from Statistics2.pnormaldist(1 - (1 - 0.95)/2)
  Z_VALUE_90_PERCENT = 1.9599639715843482
  
  attr_accessor :ranking
  ## TODO: Lots of validation!!
  
  def self.find_by_sql(*args)
    records = super
    records.each do |r|
      up,down = r.upvotes, r.downvotes
      if up + down == 0
        r.ranking = 0
      else
        p = (1.0 * up) / (up + down)
        z = Z_VALUE_90_PERCENT
        n = up + down
        r.ranking = (p + z*z/(2*n) - z * Math.sqrt((p*(1-p)+z*z/(4*n))/n))/(1+z*z/n)
      end
    end
    
    return records.sort! { |x,y| y.ranking <=> x.ranking }

  end

  def upvotes
    votes(true).select { |v| v.upvote }.length
  end

  def downvotes
    votes(true).select { |v| !v.upvote }.length
  end  

  def users_vote(user)
    raw_vote = votes.select { |v| v.user_id == user.id }.first
    if raw_vote
      return raw_vote.upvote ? 'Up' : 'Down'
    else
      return 'None'
    end
  end
end
