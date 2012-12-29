class LinksController < ApplicationController
  before_filter :authenticate_user!, except: [:forward_to_original_url]

  def index
    @links = current_user.links.order('created_at DESC').includes(:visits)
  end

  def create
    if params[:original_url].present?
      link = current_user.links.create(original_url: params[:original_url])
      render json: {shorturl: short_link_url(link)}
    else
      render json: {success: false}
    end
  end

  def destroy
    link = current_user.links.find_by_slug params[:id]
    if link && link.destroy
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  def show
    @link = current_user.links.find_by_slug(params[:id])
  end

  def forward_to_original_url
    link = Link.find_by_slug params[:id]
    return head 404 unless link
    link.visits.create
    redirect_to link.original_url, status: :moved_permanently
  end
end
