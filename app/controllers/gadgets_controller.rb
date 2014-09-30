class GadgetsController < ApplicationController
  include SessionsHelper, GadgetsHelper
  before_action :set_gadget, only: 
        [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :require_login, only: 
        [:new, :edit, :create, :destroy, :upvote, :downvote]

  # GET /gadgets
  # GET /gadgets.json
  def index
    @gadgets = Gadget.all
    @today = Date.today
  end

  # GET /gadgets/1
  # GET /gadgets/1.json
  def show
  end

  # GET /gadgets/new
  def new
    @gadget = Gadget.new
  end

  # GET /gadgets/1/edit
  def edit
  end

  # POST /gadgets
  # POST /gadgets.json
  def create
    @gadget = Gadget.new(gadget_params)

    respond_to do |format|
      if @gadget.save
        format.html { redirect_to @gadget, notice: 'Gadget was successfully created.' }
        format.json { render action: 'show', status: :created, location: @gadget }
      else
        format.html { render action: 'new' }
        format.json { render json: @gadget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gadgets/1
  # PATCH/PUT /gadgets/1.json
  def update
    respond_to do |format|
      if @gadget.update(gadget_params)
        format.html { redirect_to @gadget, notice: 'Gadget was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gadget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gadgets/1
  # DELETE /gadgets/1.json
  def destroy
    @gadget.destroy
    respond_to do |format|
      format.html { redirect_to gadgets_url }
      format.json { head :no_content }
    end
  end

  def upvote
    set_vote(true)
  end

  def downvote
    set_vote(false)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gadget
      @gadget = Gadget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gadget_params
      params.require(:gadget).permit(:name, :website, :description, :buy_now_url)
    end

    def vote_params
      params.require(:gadget).permit
    end

    def set_vote(upvote = true)

      in_db = Vote.where( user_id: current_user.id, gadget_id: @gadget.id )
      if in_db.count == 1
        in_db[0].upvote = upvote
        in_db[0].save
      elsif in_db.count == 0
        new_vote = Vote.new( user_id: current_user.id, gadget_id: @gadget.id,
                             upvote: upvote
                          )
        new_vote.save
      else
        raise
      end
      render :nothing => true
    end
end
