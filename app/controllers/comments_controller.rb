class CommentsController < ApplicationController
  include SessionsHelper
  before_action do |a|
    a.require_login('Sorry, you can only create a comment if you\'re logged in')
  end
  # TODO: Unit tests galore!

  def create
    @comment = Comment.new(params_plus_user_id)
    gadget = Gadget.find_by_id(comment_params[:gadget_id])
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to gadget, notice: 'Comment was successfully created.' }
        format.json { head :no_content }
      else
        format.html { redirect_to gadget }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:gadget_id, :title, :text, :have_it)
    end

    def params_plus_user_id
      comment_params.merge({user_id: current_user.id})
    end
end
