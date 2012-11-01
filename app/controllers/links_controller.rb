class LinksController < ApplicationController
  before_filter :authenticate_user!, except: [:show]

  def index

  end

  def create
    if params[:original_url].present?
      link = Link.create(original_url: params[:original_url])
      render :json => {shorturl: short_link_url(link)}
    end
  end

  def edit

  end

  def update

  end

  def new

  end

  def destroy

  end

  def show
    link = Link.find_by_slug params[:id]
    return head 404 unless link
    redirect_to link.original_url, status: :moved_permanently
  end
end
