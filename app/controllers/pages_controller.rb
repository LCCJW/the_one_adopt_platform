class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
  end

  def introduction
    if !current_user.nil?
      redirect_to pages_path
    end
  end

  def landingpage
  end
end
