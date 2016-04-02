class HomeController < ApplicationController
  def index
    params[:header_template] = 'header_home'
  end
end
