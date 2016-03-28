class StaticPagesController < ApplicationController
    include ImagesHelper

  def home
    @user = current_user
    if(@user==nil)
      redirect_to login_url
    elsif
      @images = current_user.list_items
      @google_images = google_auth_session.files
    end
  end
end
