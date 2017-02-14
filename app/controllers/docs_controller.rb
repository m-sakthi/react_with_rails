class DocsController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    render layout: false
  end
end
