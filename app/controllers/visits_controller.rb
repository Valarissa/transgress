class VisitsController < ApplicationController
  def index
  end

  def show
    @response = Page.get_page(params[:page])
    render inline: @response.to_s 
  end
end
