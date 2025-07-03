# frozen_string_literal: true

class RobotsController < ApplicationController
  def show
    respond_to :text

    @sitemap_url = "https://#{request.host}/sitemap.xml"

    expires_in 6.hours, public: true
  end
end
