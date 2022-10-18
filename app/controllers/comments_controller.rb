class CommentsController < ApplicationController

  def show
    @meta = { title: "Comments" }
    query = auth_hash.merge({ 'id' => params[:id] })
    @swap = lnp_api_json("get_comments", query)
  end

  def new
    @swap_id = params[:id]
  end

  def create
    query = auth_hash.merge({ 'id' => params[:id], 'body' => params[:body] })
    @json = lnp_api_json("create_comment", query)
    if @json["errors"].present?
      redirect_to "/swaps", notice: "Sorry, posting the comment failed. Error(s): " + humanize_errors(@json)
    else
      redirect_to "/comments/" + @json["id"].to_s, notice: "Comment was successfully posted."
    end
  end

end
