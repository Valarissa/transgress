class VisitsController < ApplicationController
  def index
  end

  def show
    @response = Page.get_page(params[:page])
  end
end
